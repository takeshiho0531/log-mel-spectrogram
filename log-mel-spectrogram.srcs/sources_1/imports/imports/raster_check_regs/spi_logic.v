`timescale 1ns / 1ps
//`include "spi_if.v"
//`include "spi_regs.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Tokyo
// Engineer: Kota Shiba
// 
// Module Name: spi_logic
// Project Name: NLN
// Target Devices: Ultra96v2
// 
// Description:
// 
//////////////////////////////////////////////////////////////////////////////////

module spi_logic (
  input clk_i,

  input sys_clk_i,
  input rst_n_i,
  input rst_for_logmel_i;

  input spi_clk_i,
  input spi_cs_i,
  input spi_mosi_i,
  output spi_miso,
  output spi_miso_en,

  // BASIC Registers 
  output [rl-1:0] REG_IN_A_000_o,
  output [rl-1:0] REG_IN_A_001_o,
  output [rl-1:0] REG_IN_A_002_o,
  output [rl-1:0] REG_IN_A_003_o,
  output [rl-1:0] REG_IN_A_004_o,
  output [rl-1:0] REG_IN_A_005_o,
  output [rl-1:0] REG_IN_A_006_o,
  output [rl-1:0] REG_IN_A_007_o,
  output [rl-1:0] REG_IN_A_008_o,
  output [rl-1:0] REG_IN_A_009_o,
  output [rl-1:0] REG_IN_A_010_o,
  output [rl-1:0] REG_IN_A_011_o,
  output [rl-1:0] REG_IN_A_012_o,
  output [rl-1:0] REG_IN_A_013_o,
  output [rl-1:0] REG_IN_A_014_o,
  output [rl-1:0] REG_IN_A_015_o,
  output [rl-1:0] REG_IN_A_016_o,
  output [rl-1:0] REG_IN_A_017_o,
  output [rl-1:0] REG_IN_A_018_o,
  output [rl-1:0] REG_IN_A_019_o,
  output [rl-1:0] REG_IN_A_020_o,
  output [rl-1:0] REG_IN_A_021_o,
  output [rl-1:0] REG_IN_A_022_o,
  output [rl-1:0] REG_IN_A_023_o,
  output [rl-1:0] REG_IN_A_024_o,
  output [rl-1:0] REG_IN_A_025_o,
  output [rl-1:0] REG_IN_A_026_o,
  output [rl-1:0] REG_IN_A_027_o,
  output [rl-1:0] REG_IN_A_028_o,
  output [rl-1:0] REG_IN_A_029_o,
  output [rl-1:0] REG_IN_A_030_o,
  output [rl-1:0] REG_IN_A_031_o,
  output [rl-1:0] REG_IN_A_032_o,
  output [rl-1:0] REG_IN_A_033_o,
  output [rl-1:0] REG_IN_A_034_o,
  output [rl-1:0] REG_IN_A_035_o,
  output [rl-1:0] REG_IN_A_036_o,
  output [rl-1:0] REG_IN_A_037_o,
  output [rl-1:0] REG_IN_A_038_o,
  output [rl-1:0] REG_IN_A_039_o,
  output [rl-1:0] REG_IN_A_040_o,
  output [rl-1:0] REG_IN_A_041_o,
  output [rl-1:0] REG_IN_A_042_o,
  output [rl-1:0] REG_IN_A_043_o,
  output [rl-1:0] REG_IN_A_044_o,
  output [rl-1:0] REG_IN_A_045_o,
  output [rl-1:0] REG_IN_A_046_o,
  output [rl-1:0] REG_IN_A_047_o,
  output [rl-1:0] REG_IN_A_048_o,
  output [rl-1:0] REG_IN_A_049_o,
  output [rl-1:0] REG_IN_A_050_o,
  output [rl-1:0] REG_IN_A_051_o,
  output [rl-1:0] REG_IN_A_052_o,
  output [rl-1:0] REG_IN_A_053_o,
  output [rl-1:0] REG_IN_A_054_o,
  output [rl-1:0] REG_IN_A_055_o,
  output [rl-1:0] REG_IN_A_056_o,
  output [rl-1:0] REG_IN_A_057_o,
  output [rl-1:0] REG_IN_A_058_o,
  output [rl-1:0] REG_IN_A_059_o,
  output [rl-1:0] REG_IN_A_060_o,
  output [rl-1:0] REG_IN_A_061_o,
  output [rl-1:0] REG_IN_A_062_o,
  output [rl-1:0] REG_IN_A_063_o,
  output logmel_do_en,
  output [(14*64)-1:0] logmel_data_o,

  output [rl-1:0] REG_IN_B_000_o,

  input [(rl*64)-1:0] REG_OUT_A_000_i,


  input [rl-1:0] REG_OUT_B_000_i
);


  //-----------------------------------------------------------------------
  // Parameter Definition
  //-----------------------------------------------------------------------
  parameter al = 16;  // address length, including R/W bit
  parameter dl = 24;  // data length
  parameter wc = 1'b1;  // write command
  parameter rc = 1'b0;  // read command
  parameter cl = 3;  // counter length
  parameter nb = 3;  // number of data byte
  parameter ap = al - 1;  // R/W flag in address field
  parameter rl = 14;  // register length

  //-----------------------------------------------------------------------
  // Operations
  //-----------------------------------------------------------------------
  wire [al-2:0] addr_out;
  wire [dl-1:0] wr_data;
  wire [dl-1:0] rd_data;
  wire next;
  wire wr_act;
  wire command;
  wire transfer_enable_flag;  //　追記




  spi_clock spi_clock_inst (
      .sys_clk_i             (sys_clk_i),            // 外部からのSPIクロック入力
      .clk_i                 (clk_i),
      .transfer_enable_flag_i(transfer_enable_flag),  // クロックを制御するフラグ
      .clk_o                 (clk_out),
      .selected_sys_clk_o    (selected_sys_clk)
  );

  wire spi_reg_out_req;
  wire [4:0] spi_reg_out_req_addr;

  spi_if spi_if_inst (
      .rst_n_i               (rst_n_i),
      .spi_cs_i              (spi_cs_i),
      .spi_mosi_i            (spi_mosi_i),
      .spi_miso_o            (spi_miso),
      .spi_miso_en_o         (spi_miso_en),
      .addr_out_o            (addr_out),
      .wr_data_o             (wr_data),
      .rd_data_i             (rd_data),
      .next_o                (next),
      .wr_act_o              (wr_act),
      .command_o             (command),
      .spi_clk_i             (spi_clk_i),
      .transfer_enable_flag_o(transfer_enable_flag),
      .clk_i                 (clk_i),
      .spi_reg_out_req_o     (spi_reg_out_req),
      .spi_reg_out_req_addr_o(spi_reg_out_req_addr)
  );




  // spi_regs instance

  spi_regs spi_regs_inst (
      .rst_n_i(rst_n_i),
      .spi_cs_i(spi_cs_i),
      .addr_i(addr_out),
      .data_i(wr_data),
      .next_i(next),
      .wr_act_i(wr_act),
      .data_o(rd_data),
      .command_i(command),
      .transfer_enable_flag_i(transfer_enable_flag),
      .sys_clk_i(sys_clk_i),
      .selected_sys_clk_i(selected_sys_clk_i),

      // BASIC Registers
      .REG_IN_A_000_o(REG_IN_A_000_o),
      .REG_IN_A_001_o(REG_IN_A_001_o),
      .REG_IN_A_002_o(REG_IN_A_002_o),
      .REG_IN_A_003_o(REG_IN_A_003_o),
      .REG_IN_A_004_o(REG_IN_A_004_o),
      .REG_IN_A_005_o(REG_IN_A_005_o),
      .REG_IN_A_006_o(REG_IN_A_006_o),
      .REG_IN_A_007_o(REG_IN_A_007_o),
      .REG_IN_A_008_o(REG_IN_A_008_o),
      .REG_IN_A_009_o(REG_IN_A_009_o),
      .REG_IN_A_010_o(REG_IN_A_010_o),
      .REG_IN_A_011_o(REG_IN_A_011_o),
      .REG_IN_A_012_o(REG_IN_A_012_o),
      .REG_IN_A_013_o(REG_IN_A_013_o),
      .REG_IN_A_014_o(REG_IN_A_014_o),
      .REG_IN_A_015_o(REG_IN_A_015_o),
      .REG_IN_A_016_o(REG_IN_A_016_o),
      .REG_IN_A_017_o(REG_IN_A_017_o),
      .REG_IN_A_018_o(REG_IN_A_018_o),
      .REG_IN_A_019_o(REG_IN_A_019_o),
      .REG_IN_A_020_o(REG_IN_A_020_o),
      .REG_IN_A_021_o(REG_IN_A_021_o),
      .REG_IN_A_022_o(REG_IN_A_022_o),
      .REG_IN_A_023_o(REG_IN_A_023_o),
      .REG_IN_A_024_o(REG_IN_A_024_o),
      .REG_IN_A_025_o(REG_IN_A_025_o),
      .REG_IN_A_026_o(REG_IN_A_026_o),
      .REG_IN_A_027_o(REG_IN_A_027_o),
      .REG_IN_A_028_o(REG_IN_A_028_o),
      .REG_IN_A_029_o(REG_IN_A_029_o),
      .REG_IN_A_030_o(REG_IN_A_030_o),
      .REG_IN_A_031_o(REG_IN_A_031_o),
      .REG_IN_A_032_o(REG_IN_A_032_o),
      .REG_IN_A_033_o(REG_IN_A_033_o),
      .REG_IN_A_034_o(REG_IN_A_034_o),
      .REG_IN_A_035_o(REG_IN_A_035_o),
      .REG_IN_A_036_o(REG_IN_A_036_o),
      .REG_IN_A_037_o(REG_IN_A_037_o),
      .REG_IN_A_038_o(REG_IN_A_038_o),
      .REG_IN_A_039_o(REG_IN_A_039_o),
      .REG_IN_A_040_o(REG_IN_A_040_o),
      .REG_IN_A_041_o(REG_IN_A_041_o),
      .REG_IN_A_042_o(REG_IN_A_042_o),
      .REG_IN_A_043_o(REG_IN_A_043_o),
      .REG_IN_A_044_o(REG_IN_A_044_o),
      .REG_IN_A_045_o(REG_IN_A_045_o),
      .REG_IN_A_046_o(REG_IN_A_046_o),
      .REG_IN_A_047_o(REG_IN_A_047_o),
      .REG_IN_A_048_o(REG_IN_A_048_o),
      .REG_IN_A_049_o(REG_IN_A_049_o),
      .REG_IN_A_050_o(REG_IN_A_050_o),
      .REG_IN_A_051_o(REG_IN_A_051_o),
      .REG_IN_A_052_o(REG_IN_A_052_o),
      .REG_IN_A_053_o(REG_IN_A_053_o),
      .REG_IN_A_054_o(REG_IN_A_054_o),
      .REG_IN_A_055_o(REG_IN_A_055_o),
      .REG_IN_A_056_o(REG_IN_A_056_o),
      .REG_IN_A_057_o(REG_IN_A_057_o),
      .REG_IN_A_058_o(REG_IN_A_058_o),
      .REG_IN_A_059_o(REG_IN_A_059_o),
      .REG_IN_A_060_o(REG_IN_A_060_o),
      .REG_IN_A_061_o(REG_IN_A_061_o),
      .REG_IN_A_062_o(REG_IN_A_062_o),
      .REG_IN_A_063_o(REG_IN_A_063_o),



      .REG_IN_B_000_o   (REG_IN_B_000_o),
      .REG_OUT_A_000_i  (REG_OUT_A_000_i),
      .REG_OUT_B_000_i  (REG_OUT_B_000_i),
      .rst_for_logmel_i(rst_for_logmel_i),
      .spi_reg_out_req_i(spi_reg_out_req),
      .spi_reg_out_req_addr_i(spi_reg_out_req_addr)
  );

  wire [1:0] logmel_di_en;
  wire logmel_do_en;
  // wire [(14*64)-1:0] logmel_data_o;

  assign logmel_di_en = REG_IN_B_000_o[1:0];
  // assign logmel_do_en = REG_OUT_B_000_i0];
  assign REG_OUT_B_000_i = logmel_do_en;
  assign REG_OUT_A_000_i = logmel_do_en ? logmel_data_o : REG_OUT_A_000_i;

  // 入力先のトップモジュール
  log_mel_spectrogram #(
      .TOTAL_DATA(1024),
      .OUT_FRAMING_TOTAL_DATA(1024)
  ) logmel (
      .clk(clk_out),
      .rst(rst_for_logmel_i),
      .di_en(logmel_di_en),
      .data_i(REG_IN_A_000_o),
      .do_en(logmel_do_en),
      .data_o(logmel_data_o)
  );

  always @(posedge clk_out) begin
    if (logmel_do_en) begin
      // $display("logmel_data_o[100]=%d", logmel_data_o[100]);
    end
  end


endmodule  //spi_logic


