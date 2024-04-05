`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Tokyo
// Engineer: Kota Shiba
// 
// Module Name: spi_if
// Project Name: NLN
// Target Devices: Ultra96v2
// 
// Description:
// 
//////////////////////////////////////////////////////////////////////////////////

module spi_if (
    rst_n_i,
    spi_cs_i,
    spi_mosi_i,
    spi_miso_o,
    spi_miso_en_o,
    spi_clk_i,
    clk_i,

    addr_out_o,
    wr_data_o,
    rd_data_i,
    next_o,
    wr_act_o,
    command_o,
    transfer_enable_flag,

    spi_reg_out_req_o,
    spi_reg_out_req_addr_o
);


  //-----------------------------------------------------------------------
  // Parameter Definition
  //-----------------------------------------------------------------------
  parameter al = 16;  // address length, including R/W bit
  parameter dl = 24;  // data length
  parameter wc = 1'b1;  // write command_o
  parameter rc = 1'b0;  // read command_o
  parameter cl = 3;  // counter length
  parameter nb = 3;  // number of data byte
  parameter ap = al - 1;  // R/W flag in address field
  parameter rl = 14;  // register length


  //-----------------------------------------------------------------------
  // Port Declaration
  //-----------------------------------------------------------------------
  input rst_n_i;
  input spi_cs_i;
  input spi_mosi_i;
  input spi_clk_i;
  input clk_i;
  output spi_miso_o;
  output spi_miso_en_o;

  output [al-2:0] addr_out_o;
  output [dl-1:0] wr_data_o;
  input [dl-1:0] rd_data_i;

  output next_o;
  output wr_act_o;
  output command_o;
  output transfer_enable_flag_o;

  output reg spi_reg_out_req_o;
  output reg [4:0] spi_reg_out_req_addr_o;  // 14桁なので....


  //-----------------------------------------------------------------------
  // Signal Declaration
  //-----------------------------------------------------------------------
  wire    rst_n_i;
  wire    spi_cs_i;
  wire    spi_mosi_i;
  reg    spi_miso_o;
  reg   spi_miso_en_o;

  wire [al-2:0] addr_out_o;
  reg [dl-1:0] wr_data_o;
  wire [dl-1:0] rd_data_i;

  reg    next_o;   // next_o byte
  reg    wr_act_o;   // write data
  reg   command_o;  // write = 1, read = 0


  //-----------------------------------------------------------------------
  // Operations
  //-----------------------------------------------------------------------
  reg [al-2:0] addr;
  wire [dl-1:0] data_out;
  reg [cl-1:0] count;
  reg [nb-1:0] num_bytes;
  reg   [10:0] flag_counter_spi; // 追記
  wire   transfer_enable_flag; //　追記
  reg   transfer_enable_flag_spi;
  wire   spi_clk_b;
  wire transfer_enable_flag_nnn;

  assign addr_out_o = addr[ap-1:0];
  assign transfer_enable_flag_nnn = 0;  // 今回はnnn関係ないので


  assign spi_clk_b = ~spi_clk_i;
  assign transfer_enable_flag = transfer_enable_flag_spi ^ transfer_enable_flag_nnn;

  always @(posedge spi_clk_i or negedge rst_n_i) begin  // Positive Edge
    if (!rst_n_i) begin
      flag_counter_spi <= 0;
      num_bytes <= {nb{1'b0}};
      transfer_enable_flag_spi <= 0;
      count <= {cl{1'b0}};
    end else if (spi_cs_i == 1'b1) begin
      num_bytes <= {nb{1'b0}};
      flag_counter_spi <= 0;
      transfer_enable_flag_spi <= 0;
      count <= {cl{1'b0}};
    end else if (transfer_enable_flag == 1'b0) begin
      if ((count == 3'h7) && ~spi_cs_i && (num_bytes <= 3'b011)) begin
        num_bytes <= num_bytes + 1;
        flag_counter_spi <= flag_counter_spi;
        transfer_enable_flag_spi <= transfer_enable_flag_spi;
        count <= count + 1;
      end else if ((count == 3'h7) && ~spi_cs_i && (num_bytes == 3'b100)) begin
        num_bytes <= {nb{1'b0}};
        flag_counter_spi <= flag_counter_spi + 1;
        transfer_enable_flag_spi <= transfer_enable_flag_spi;
        count <= count + 1;
      end else if ((count == 3'h0) && (flag_counter_spi == 11'd65)) begin
        flag_counter_spi <= 0;
        transfer_enable_flag_spi <= transfer_enable_flag_spi + 1'b1;
        count <= {cl{1'b0}};
        num_bytes <= {nb{1'b0}};
      end else begin
        num_bytes <= num_bytes;
        flag_counter_spi <= flag_counter_spi;
        transfer_enable_flag_spi <= transfer_enable_flag_spi;
        count <= count + 1;
      end
    end
  end


  // serial address input

  always @(posedge spi_clk_i or negedge rst_n_i) begin  // Positive Edge
    // $display("addr=%d", addr); // ここの時点で62までしか入ってない
    if (!rst_n_i) addr <= {ap{1'b0}};
    else if (transfer_enable_flag == 1'b0) begin
      if ((count < al) && ~spi_cs_i && (num_bytes <= 3'b001)) begin
        addr <= {addr[ap-2:0], spi_mosi_i};
      end else addr <= addr;
    end
  end


  // command_o detection

  always @(posedge spi_clk_i or negedge rst_n_i)  // Positive Edge // write command_o = 1
    if (!rst_n_i) begin
      command_o <= 1'b0;
    end else if (transfer_enable_flag == 1'b0) begin
      if (spi_cs_i) begin
        command_o <= 1'b0;
      end else if ((num_bytes == {nb{1'b0}}) && (count == {cl{1'b0}}) && ~spi_cs_i) begin
        command_o <= spi_mosi_i;
      end else if ((num_bytes == 3'd2) && (count == {cl{1'b0}}) && ~spi_cs_i) begin
        command_o <= command_o;
      end else begin
        command_o <= command_o;
      end
    end

  // serial data input from mosi

  always @(posedge spi_clk_i or negedge rst_n_i)  // Positive Edge
    if (!rst_n_i) wr_data_o <= {dl{1'b0}};
    else if (transfer_enable_flag == 1'b0) begin
      if (spi_cs_i) wr_data_o <= {dl{1'b0}};
      else if ((num_bytes >= 3'b010) && ~spi_cs_i && (command_o == wc))
        wr_data_o <= {wr_data_o[dl-2:0], spi_mosi_i};
      else wr_data_o <= wr_data_o;
    end


  // serial data output from miso

  // always @(posedge spi_clk_b or negedge rst_n_i) begin   // Negative Edge
  //    $display("spi_miso_en_o=%d, num_bytes=%d, count=%d, flag_counter_spi=%d, spi_cs_i=%d, rst_n_i=%d", spi_miso_en_o, num_bytes, count, flag_counter_spi, spi_cs_i, rst_n_i);
  //    if (!rst_n_i)
  //       begin
  //       data_out <= {dl{1'b0}};
  //       spi_miso_o <= 1'b0;
  //       spi_miso_en_o <= 1'b0; // For miso bus
  //       end
  //    else if (transfer_enable_flag == 1'b0) begin
  //       if ((num_bytes <= 3'b001) && ~spi_cs_i)
  //          begin
  //          data_out <= {dl{1'b0}};
  //          spi_miso_o <= 1'b0;
  //          spi_miso_en_o <= 1'b0; // For miso bus
  //          end
  //       else if ((num_bytes >= 3'b010) && ~spi_cs_i && (command_o == rc))
  //          begin
  //          if (next_o)
  //             begin
  //             data_out <= {rd_data_i[dl-2:0], 1'b0};
  //             spi_miso_o <= rd_data_i[dl-1];
  //             spi_miso_en_o <= 1'b1;
  //             end
  //          else
  //             begin
  //             data_out <= {data_out[dl-2:0], 1'b0};
  //             spi_miso_o <= data_out[dl-1];
  //             spi_miso_en_o <= 1'b1;
  //             end
  //          end
  //       else
  //          begin
  //          data_out <= data_out;			// should be clear ?
  //          spi_miso_o <= spi_miso_o;			// should be clear ?
  //          spi_miso_en_o <= spi_miso_en_o;		// should be clear ?
  //          end
  //    end
  // end


  // integer spi_reg_out_req_addr_o;
  integer addr_in_data_out;
  // reg spi_reg_out_req_o;
  assign spi_reg_out_en = rd_data_i[dl-1];
  assign data_out = (spi_reg_out_en && addr_in_data_out == 13) ? rd_data_i[dl-1-1:0] : data_out;

  always @(posedge spi_clk_b or negedge rst_n_i) begin  // Negative Edge
    // $display("spi_miso_o=%d, spi_miso_en_o=%d", spi_miso_o, spi_miso_en_o);
    if (!rst_n_i) begin
      // data_out <= {dl{1'b0}};
      spi_miso_o <= 1'b0;
      spi_miso_en_o <= 1'b0;  // For miso bus
      addr_in_data_out <= 0;
      spi_reg_out_req_o <= 0;
      spi_reg_out_req_addr_o <= 0;
    end else if (transfer_enable_flag == 0 && spi_reg_out_en && addr_in_data_out==13) begin // TODO
      spi_miso_o <= data_out[13];
      spi_miso_en_o <= 1;
      addr_in_data_out <= 12;
      spi_reg_out_req_addr_o <= spi_reg_out_req_addr_o;
      spi_reg_out_req_o <= 0;
      $display("1: spi_miso_o=%d, spi_miso_en_o=%d", spi_miso_o, spi_miso_en_o);
    end else if (transfer_enable_flag == 0 && spi_reg_out_en && addr_in_data_out > 0) begin
      spi_miso_o <= data_out[addr_in_data_out];
      spi_miso_en_o <= 1;
      addr_in_data_out <= addr_in_data_out - 1;
      spi_reg_out_req_addr_o <= spi_reg_out_req_addr_o;
      spi_reg_out_req_o <= 0;
      $display("2: spi_miso_o=%d, spi_miso_en_o=%d", spi_miso_o, spi_miso_en_o);
    end else if (transfer_enable_flag == 0 && spi_reg_out_en && addr_in_data_out == 0) begin
      spi_miso_o <= data_out[0];
      spi_miso_en_o <= 1;
      addr_in_data_out <= 13;
      spi_reg_out_req_addr_o <= spi_reg_out_req_addr_o + 1;
      spi_reg_out_req_o <= 1;
      $display("3 spi_miso_o=%d, spi_miso_en_o=%d", spi_miso_o, spi_miso_en_o);
    end else begin
      $display("4 spi_miso_o=%d, spi_miso_en_o=%d", spi_miso_o, spi_miso_en_o);
      spi_miso_o <= 0;
      spi_miso_en_o <= 0;
      addr_in_data_out <= 0;  // ?????
      spi_reg_out_req_addr_o <= spi_reg_out_req_addr_o;
      spi_reg_out_req_o <= 0;  // ?????
    end
  end



  //--- Data Handling

  // always @(posedge spi_clk_i or negedge rst_n_i)    // Positive Edge
  //    if (!rst_n_i)
  //       next_o <= 1'b0;
  //    else if (transfer_enable_flag == 1'b0) begin
  //       if ((count == 'h7) && ~spi_cs_i && (num_bytes == 3'b001))
  //          next_o <= 1'b1;
  //       else
  //          next_o <= 1'b0;
  //    end


  //--- Write Data Handling

  always @(posedge spi_clk_i or negedge rst_n_i)  // Positive Edge
    if (!rst_n_i) wr_act_o <= 1'b0;
    else if (transfer_enable_flag == 1'b0) begin
      if ((count == 'h7) && ~spi_cs_i && (num_bytes == 3'b100) && (command_o == wc))
        wr_act_o <= 1'b1;
      else wr_act_o <= 1'b0;
    end

endmodule  //spi_if
