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
rst_n,
spi_cs,
spi_mosi,
spi_miso,
spi_miso_en,
spi_clk,
clk,

addr_out,
wr_data,
rd_data,
next,
wr_act,
command,
transfer_enable_flag
);


//-----------------------------------------------------------------------
// Parameter Definition
//-----------------------------------------------------------------------
parameter al = 16;		// address length, including R/W bit
parameter dl = 24;		// data length
parameter wc = 1'b1;		// write command
parameter rc = 1'b0;		// read command
parameter cl = 3;		// counter length
parameter nb = 3;		// number of data byte
parameter ap = al - 1;		// R/W flag in address field
parameter rl = 14;       // register length


//-----------------------------------------------------------------------
// Port Declaration
//-----------------------------------------------------------------------
input			rst_n;
input			spi_cs;
input			spi_mosi;
input       spi_clk;
input        clk;
output			spi_miso;
output			spi_miso_en;

output	[al-2:0]	addr_out;
output	[dl-1:0]	wr_data;
input	[dl-1:0]	rd_data;

output			next;
output			wr_act;
output			command;
output         transfer_enable_flag;


//-----------------------------------------------------------------------
// Signal Declaration
//-----------------------------------------------------------------------
wire 			rst_n;
wire 			spi_cs;
wire 			spi_mosi;
reg 			spi_miso;
reg			spi_miso_en;

wire	[al-2:0]	addr_out;
reg	[dl-1:0]	wr_data;
wire	[dl-1:0]	rd_data;

reg 			next;			// next byte
reg 			wr_act;			// write data
reg			command;		// write = 1, read = 0


//-----------------------------------------------------------------------
// Operations
//-----------------------------------------------------------------------
reg	[al-2:0]	addr;
reg	[dl-1:0]	data_out;
reg	[cl-1:0]	count;
reg	[nb-1:0]	num_bytes;
reg   [10:0] flag_counter_spi; // 追記
reg   [9:0] flag_counter_nnn;
wire   transfer_enable_flag; //　追記
reg   transfer_enable_flag_spi;
reg   transfer_enable_flag_nnn;
reg         inference_type; // whole_frame = 1, just_one_line = 0
wire			spi_clk_b;

assign addr_out = addr[ap-1:0];




assign spi_clk_b = ~spi_clk;
assign transfer_enable_flag = transfer_enable_flag_spi ^ transfer_enable_flag_nnn;

always @(posedge spi_clk or negedge rst_n) begin   // Positive Edge
   // $display("spi clock");
   // $display("flag_counter_spi=%d", flag_counter_spi);
   if (!rst_n) begin
      flag_counter_spi <= 0;
      num_bytes <= {nb{1'b0}};
      transfer_enable_flag_spi <= 0;
      count <= {cl{1'b0}};
   end else if (spi_cs == 1'b1) begin
      num_bytes <= {nb{1'b0}};
      flag_counter_spi <= 0;
      transfer_enable_flag_spi <= 0;
      count <= {cl{1'b0}};
   end else if (transfer_enable_flag == 1'b0) begin
    if ((count == 3'h7) && ~spi_cs && (num_bytes <= 3'b011)) begin
         num_bytes <= num_bytes + 1;
         flag_counter_spi <= flag_counter_spi;
         transfer_enable_flag_spi <= transfer_enable_flag_spi;
         count <= count + 1;
      end else if ((count == 3'h7) && ~spi_cs && (num_bytes == 3'b100)) begin
         num_bytes <= {nb{1'b0}};
         flag_counter_spi <= flag_counter_spi + 1;
         transfer_enable_flag_spi <= transfer_enable_flag_spi;
         count <= count + 1;
      end else if ((count == 3'h0) && (flag_counter_spi == 11'd65)) begin
         // end else if ((count == 3'h0) && (flag_counter_spi == 11'd66)) begin
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

always @(posedge clk or negedge rst_n) begin
   // $display("flag_counter_nnn=%d, transfer_enable_flag=%d, transfer_enable_flag_nnn=%d, spi_cs=%d, inference_type=%d", flag_counter_nnn, transfer_enable_flag, transfer_enable_flag_nnn, spi_cs, inference_type);
   //  if (transfer_enable_flag_nnn!=0 | spi_cs!=0 | inference_type!=1) begin
   //    $display("flag_counter_nnn=%d, transfer_enable_flag_nnn=%d, spi_cs=%d, inference_type=%d", flag_counter_nnn, transfer_enable_flag_nnn, spi_cs, inference_type);
   //  end
    if (!rst_n) begin
      flag_counter_nnn <= 0;
      transfer_enable_flag_nnn <= 0;
    end else if (spi_cs == 1'b1) begin
      flag_counter_nnn <= 0;
      transfer_enable_flag_nnn <= 0;
    end else if (transfer_enable_flag == 1'b1) begin 
      if ((flag_counter_nnn == 10'd64) && (inference_type == 1'b0)) begin
         flag_counter_nnn <= 0;
         transfer_enable_flag_nnn <= transfer_enable_flag_nnn + 1'b1;
      end else if ((flag_counter_nnn == 10'd64) && (inference_type == 1'b1)) begin
         flag_counter_nnn <= 0;
         transfer_enable_flag_nnn <= transfer_enable_flag_nnn;
      end else begin
         flag_counter_nnn <= flag_counter_nnn + 1'b1;
      end
    end
end

// serial address input

always @(posedge spi_clk or negedge rst_n)  begin  // Positive Edge
   $display("transfer_enable_flag=%d", transfer_enable_flag);
   // $display("transfer_enable_flag=%d, transfer_enable_flag_spi=%d, transfer_enable_flag_nnn=%d", transfer_enable_flag, transfer_enable_flag_spi, transfer_enable_flag_nnn);
   // $display("addr=%d", addr); // ここの時点で62までしか入ってない
   if (!rst_n)
      addr <= {ap{1'b0}};
   else if (transfer_enable_flag == 1'b0) begin
      // $display("transfer_enable_flag=%d, count=%d, spi_cs=%d, num_bytes=%d, addr=%b", transfer_enable_flag, count, spi_cs, num_bytes, addr);
      // $display("spi_cs=%d, addr=%d", spi_cs, addr);
      if ((count < al) && ~spi_cs && (num_bytes <= 3'b001)) begin
         addr <= {addr[ap-2:0],spi_mosi};
         // $display("spi_if spi_mosi=%d", spi_mosi);
         // $display("addr=%b", addr);
         // $display("addr_out addr is equal=%d", addr_out == addr);
      end
      else
         addr <= addr;
   end
end


// command detection

always @(posedge spi_clk or negedge rst_n)    // Positive Edge // write command = 1
   if (!rst_n) begin
      command <= 1'b0;
      inference_type <= 1'b0;
   end else if (transfer_enable_flag == 1'b0) begin
      if (spi_cs) begin
         command <= 1'b0;
         inference_type <= 1'b0;
      end else if ((num_bytes == {nb{1'b0}}) && (count == {cl{1'b0}}) && ~spi_cs) begin
         command <= spi_mosi;
         inference_type <= inference_type;
      end else if ((num_bytes == 3'd2) && (count == {cl{1'b0}}) && ~spi_cs) begin
         command <= command;
         inference_type <= spi_mosi;
      end else begin
         command <= command;
         inference_type <= inference_type;
      end
   end

// serial data input from mosi

always @(posedge spi_clk or negedge rst_n)    // Positive Edge
   if (!rst_n)
      wr_data <= {dl{1'b0}};
   else if (transfer_enable_flag == 1'b0) begin
      if (spi_cs)
         wr_data <= {dl{1'b0}};
      else if ((num_bytes >= 3'b010) && ~spi_cs && (command == wc))
         wr_data <= {wr_data[dl-2:0], spi_mosi};
      else
         wr_data <= wr_data;
   end


// serial data output from miso

always @(posedge spi_clk_b or negedge rst_n)    // Negative Edge
   if (!rst_n)
      begin
      data_out <= {dl{1'b0}};
      spi_miso <= 1'b0;
      spi_miso_en <= 1'b0; // For miso bus
      end
   else if (transfer_enable_flag == 1'b0) begin
      if ((num_bytes <= 3'b001) && ~spi_cs)
         begin
         data_out <= {dl{1'b0}};
         spi_miso <= 1'b0;
         spi_miso_en <= 1'b0; // For miso bus
         end
      else if ((num_bytes >= 3'b010) && ~spi_cs && (command == rc))
         begin
         if (next)
            begin
            data_out <= {rd_data[dl-2:0], 1'b0};
            spi_miso <= rd_data[dl-1];
            spi_miso_en <= 1'b1;
            end
         else
            begin
            data_out <= {data_out[dl-2:0], 1'b0};
            spi_miso <= data_out[dl-1];
            spi_miso_en <= 1'b1;
            end
         end
      else
         begin
         data_out <= data_out;			// should be clear ?
         spi_miso <= spi_miso;			// should be clear ?
         spi_miso_en <= spi_miso_en;		// should be clear ?
         end
   end


//--- Data Handling

always @(posedge spi_clk or negedge rst_n)    // Positive Edge
   if (!rst_n)
      next <= 1'b0;
   else if (transfer_enable_flag == 1'b0) begin
      if ((count == 'h7) && ~spi_cs && (num_bytes == 3'b001))
         next <= 1'b1;
      else
         next <= 1'b0;
   end


//--- Write Data Handling

always @(posedge spi_clk or negedge rst_n)    // Positive Edge
   if (!rst_n)
      wr_act <= 1'b0;
   else if (transfer_enable_flag == 1'b0) begin
      if ((count == 'h7) && ~spi_cs && (num_bytes == 3'b100) && (command == wc))
         wr_act <= 1'b1;
      else
         wr_act <= 1'b0;
   end

endmodule	//spi_if
