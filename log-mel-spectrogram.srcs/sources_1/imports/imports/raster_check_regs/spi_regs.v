`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Tokyo
// Engineer: Kota Shiba
// 
// Module Name: spi_regs
// Project Name: NLN
// Target Devices: Ultra96v2
// 
// Description:
// 
//////////////////////////////////////////////////////////////////////////////////

module spi_regs (
    rst_n_i,
    spi_cs_i,
    command_i,
    transfer_enable_flag_i,
    sys_clk_i,
    selected_sys_clk_i,
    addr_i,
    data_i,
    next_i,
    wr_act_i,
    data_o,

    // BASIC Registers 
    REG_IN_A_000_o,
    REG_IN_A_001_o,
    REG_IN_A_002_o,
    REG_IN_A_003_o,
    REG_IN_A_004_o,
    REG_IN_A_005_o,
    REG_IN_A_006_o,
    REG_IN_A_007_o,
    REG_IN_A_008_o,
    REG_IN_A_009_o,
    REG_IN_A_010_o,
    REG_IN_A_011_o,
    REG_IN_A_012_o,
    REG_IN_A_013_o,
    REG_IN_A_014_o,
    REG_IN_A_015_o,
    REG_IN_A_016_o,
    REG_IN_A_017_o,
    REG_IN_A_018_o,
    REG_IN_A_019_o,
    REG_IN_A_020_o,
    REG_IN_A_021_o,
    REG_IN_A_022_o,
    REG_IN_A_023_o,
    REG_IN_A_024_o,
    REG_IN_A_025_o,
    REG_IN_A_026_o,
    REG_IN_A_027_o,
    REG_IN_A_028_o,
    REG_IN_A_029_o,
    REG_IN_A_030_o,
    REG_IN_A_031_o,
    REG_IN_A_032_o,
    REG_IN_A_033_o,
    REG_IN_A_034_o,
    REG_IN_A_035_o,
    REG_IN_A_036_o,
    REG_IN_A_037_o,
    REG_IN_A_038_o,
    REG_IN_A_039_o,
    REG_IN_A_040_o,
    REG_IN_A_041_o,
    REG_IN_A_042_o,
    REG_IN_A_043_o,
    REG_IN_A_044_o,
    REG_IN_A_045_o,
    REG_IN_A_046_o,
    REG_IN_A_047_o,
    REG_IN_A_048_o,
    REG_IN_A_049_o,
    REG_IN_A_050_o,
    REG_IN_A_051_o,
    REG_IN_A_052_o,
    REG_IN_A_053_o,
    REG_IN_A_054_o,
    REG_IN_A_055_o,
    REG_IN_A_056_o,
    REG_IN_A_057_o,
    REG_IN_A_058_o,
    REG_IN_A_059_o,
    REG_IN_A_060_o,
    REG_IN_A_061_o,
    REG_IN_A_062_o,
    REG_IN_A_063_o,
    REG_IN_B_000_o,

    REG_OUT_A_000_i,
    REG_OUT_B_000_i,
    rst_for_logmel_i,

    spi_reg_out_req_i,
    spi_reg_out_req_addr_i
);

  //-----------------------------------------------------------------------
  // Parameter Definition
  //-----------------------------------------------------------------------
  // packet parameter
  parameter al = 15;  // address length, excluding R/W bit
  parameter dl = 24;  // data length
  parameter wc = 1'b1;  // write command_i
  parameter rc = 1'b0;  // read command_i
  parameter rl = 14;  // register length


  //-----------------------------------------------------------------------
  // Port Declaration
  //-----------------------------------------------------------------------
  input rst_n_i;
  input spi_cs_i;
  input command_i;
  input [al-1:0] addr_i;
  input [dl-1:0] data_i;
  input next_i;
  input wr_act_i;
  input sys_clk_i;
  input selected_sys_clk_i;
  input transfer_enable_flag_i;
  output   reg [dl-1:0] data_o;

  // BASIC Registers
  output   reg [rl-1:0] REG_IN_A_000_o;
  output   reg [rl-1:0] REG_IN_A_001_o;
  output   reg [rl-1:0] REG_IN_A_002_o;
  output   reg [rl-1:0] REG_IN_A_003_o;
  output   reg [rl-1:0] REG_IN_A_004_o;
  output   reg [rl-1:0] REG_IN_A_005_o;
  output   reg [rl-1:0] REG_IN_A_006_o;
  output   reg [rl-1:0] REG_IN_A_007_o;
  output   reg [rl-1:0] REG_IN_A_008_o;
  output   reg [rl-1:0] REG_IN_A_009_o;
  output   reg [rl-1:0] REG_IN_A_010_o;
  output   reg [rl-1:0] REG_IN_A_011_o;
  output   reg [rl-1:0] REG_IN_A_012_o;
  output   reg [rl-1:0] REG_IN_A_013_o;
  output   reg [rl-1:0] REG_IN_A_014_o;
  output   reg [rl-1:0] REG_IN_A_015_o;
  output   reg [rl-1:0] REG_IN_A_016_o;
  output   reg [rl-1:0] REG_IN_A_017_o;
  output   reg [rl-1:0] REG_IN_A_018_o;
  output   reg [rl-1:0] REG_IN_A_019_o;
  output   reg [rl-1:0] REG_IN_A_020_o;
  output   reg [rl-1:0] REG_IN_A_021_o;
  output   reg [rl-1:0] REG_IN_A_022_o;
  output   reg [rl-1:0] REG_IN_A_023_o;
  output   reg [rl-1:0] REG_IN_A_024_o;
  output   reg [rl-1:0] REG_IN_A_025_o;
  output   reg [rl-1:0] REG_IN_A_026_o;
  output   reg [rl-1:0] REG_IN_A_027_o;
  output   reg [rl-1:0] REG_IN_A_028_o;
  output   reg [rl-1:0] REG_IN_A_029_o;
  output   reg [rl-1:0] REG_IN_A_030_o;
  output   reg [rl-1:0] REG_IN_A_031_o;
  output   reg [rl-1:0] REG_IN_A_032_o;
  output   reg [rl-1:0] REG_IN_A_033_o;
  output   reg [rl-1:0] REG_IN_A_034_o;
  output   reg [rl-1:0] REG_IN_A_035_o;
  output   reg [rl-1:0] REG_IN_A_036_o;
  output   reg [rl-1:0] REG_IN_A_037_o;
  output   reg [rl-1:0] REG_IN_A_038_o;
  output   reg [rl-1:0] REG_IN_A_039_o;
  output   reg [rl-1:0] REG_IN_A_040_o;
  output   reg [rl-1:0] REG_IN_A_041_o;
  output   reg [rl-1:0] REG_IN_A_042_o;
  output   reg [rl-1:0] REG_IN_A_043_o;
  output   reg [rl-1:0] REG_IN_A_044_o;
  output   reg [rl-1:0] REG_IN_A_045_o;
  output   reg [rl-1:0] REG_IN_A_046_o;
  output   reg [rl-1:0] REG_IN_A_047_o;
  output   reg [rl-1:0] REG_IN_A_048_o;
  output   reg [rl-1:0] REG_IN_A_049_o;
  output   reg [rl-1:0] REG_IN_A_050_o;
  output   reg [rl-1:0] REG_IN_A_051_o;
  output   reg [rl-1:0] REG_IN_A_052_o;
  output   reg [rl-1:0] REG_IN_A_053_o;
  output   reg [rl-1:0] REG_IN_A_054_o;
  output   reg [rl-1:0] REG_IN_A_055_o;
  output   reg [rl-1:0] REG_IN_A_056_o;
  output   reg [rl-1:0] REG_IN_A_057_o;
  output   reg [rl-1:0] REG_IN_A_058_o;
  output   reg [rl-1:0] REG_IN_A_059_o;
  output   reg [rl-1:0] REG_IN_A_060_o;
  output   reg [rl-1:0] REG_IN_A_061_o;
  output   reg [rl-1:0] REG_IN_A_062_o;
  output   reg [rl-1:0] REG_IN_A_063_o;
  output   reg [rl-1:0] REG_IN_B_000_o;

  input [(rl*64)-1:0] REG_OUT_A_000_i;

  input [rl-1:0] REG_OUT_B_000_i;
  input rst_for_logmel_i;
  input spi_reg_out_req_i;
  input [4:0] spi_reg_out_req_addr_i;

  //-----------------------------------------------------------------------
  // Signal Declaration
  //-----------------------------------------------------------------------
  wire rst_n_i;
  wire spi_cs_i;
  wire command_i;
  wire [al-1:0] addr_i;
  wire [dl-1:0] data_i;
  wire next_i;
  wire wr_act_i;

  //--- asynchronous handshaking
  reg spi_cs_q;
  reg next_q1;
  reg next_q2;
  reg next_q3;
  reg rd_act_q1;
  reg rd_act_q2;
  reg wr_act_q1;
  reg wr_act_q2;
  reg wr_act_q3;
  reg wr_pulse;
  reg wr_pulse_q;
  reg [dl-1:0] wr_data;
  reg [al-1:0] addr_in_q;
  reg command_q;

  reg [10:0] di_en_reg;
  // reg   [9:0]  di_en_sub_reg;
  integer clk_cnt;

  initial begin
    di_en_reg <= 11'b0;
    clk_cnt   <= 0;
    // di_en_sub_reg <= 10'b0;
  end

  always @(posedge sys_clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      spi_cs_q <= 1'b0;
    end else if (transfer_enable_flag_i == 1'b0) begin
      spi_cs_q <= spi_cs_i;
    end
  end


  always @(posedge sys_clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      next_q1 <= 1'b0;
      next_q2 <= 1'b0;
      next_q3 <= 1'b0;
    end else if (transfer_enable_flag_i == 1'b0) begin
      next_q1 <= next_i;
      next_q2 <= next_q1;
      next_q3 <= next_q2;
    end
  end

  always @(posedge sys_clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      wr_act_q1 <= 1'b0;
      wr_act_q2 <= 1'b0;
      wr_act_q3 <= 1'b0;
    end else if (transfer_enable_flag_i == 1'b0) begin
      wr_act_q1 <= wr_act_i;
      wr_act_q2 <= wr_act_q1;
      wr_act_q3 <= wr_act_q2;
    end
  end

  always @(posedge sys_clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      wr_pulse   <= 1'b0;
      wr_pulse_q <= 1'b0;
    end else if (transfer_enable_flag_i == 1'b0) begin
      wr_pulse   <= wr_act_q2 && ~wr_act_q3;
      wr_pulse_q <= wr_pulse;
    end
  end

  always @(posedge sys_clk_i or negedge rst_n_i)
    if (!rst_n_i) begin
      rd_act_q1 <= 1'b0;
      rd_act_q2 <= 1'b0;
    end else if (transfer_enable_flag_i == 1'b0) begin
      rd_act_q1 <= next_q2 && ~next_q3;
      rd_act_q2 <= rd_act_q1;
    end

  always @(posedge sys_clk_i or negedge rst_n_i) begin
    // $display("addr_i=%d, addr_in_q=%d", addr_i, addr_in_q);  // ここの時点で62までしか入ってない
    if (!rst_n_i) addr_in_q <= {al{1'b0}};
    else if (transfer_enable_flag_i == 1'b0) begin
      if (rd_act_q1) begin
        addr_in_q <= addr_i;
      end else begin
        addr_in_q <= addr_in_q;
      end
    end
  end

  always @(posedge sys_clk_i or negedge rst_n_i) begin
    if (!rst_n_i) wr_data <= {dl{1'b0}};
    else if (transfer_enable_flag_i == 1'b0) begin
      if (wr_pulse) wr_data <= data_i;
      else wr_data <= wr_data;
    end
  end

  always @(posedge sys_clk_i or negedge rst_n_i) begin
    // $display("addr_in_q=%d, data_o=%d, REG_OUT_A_000_i[100]=%d", addr_in_q, data_o, REG_OUT_A_000_i[100]);
    if (!rst_n_i) command_q <= 1'b0;
    else if (transfer_enable_flag_i == 1'b0) begin
      if (~spi_cs_q) command_q <= command_i;
      else command_q <= command_q;
    end
  end

  always @(posedge selected_sys_clk_i or negedge rst_n_i) begin
    $display("spi_reg_out_req_i=%d, spi_reg_out_req_addr_i=%d", spi_reg_out_req_i, spi_reg_out_req_addr_i);
    if (!rst_n_i) begin
      REG_IN_A_000_o <= {rl{1'b0}};
      REG_IN_A_001_o <= {rl{1'b0}};
      REG_IN_A_002_o <= {rl{1'b0}};
      REG_IN_A_003_o <= {rl{1'b0}};
      REG_IN_A_004_o <= {rl{1'b0}};
      REG_IN_A_005_o <= {rl{1'b0}};
      REG_IN_A_006_o <= {rl{1'b0}};
      REG_IN_A_007_o <= {rl{1'b0}};
      REG_IN_A_008_o <= {rl{1'b0}};
      REG_IN_A_009_o <= {rl{1'b0}};
      REG_IN_A_010_o <= {rl{1'b0}};
      REG_IN_A_011_o <= {rl{1'b0}};
      REG_IN_A_012_o <= {rl{1'b0}};
      REG_IN_A_013_o <= {rl{1'b0}};
      REG_IN_A_014_o <= {rl{1'b0}};
      REG_IN_A_015_o <= {rl{1'b0}};
      REG_IN_A_016_o <= {rl{1'b0}};
      REG_IN_A_017_o <= {rl{1'b0}};
      REG_IN_A_018_o <= {rl{1'b0}};
      REG_IN_A_019_o <= {rl{1'b0}};
      REG_IN_A_020_o <= {rl{1'b0}};
      REG_IN_A_021_o <= {rl{1'b0}};
      REG_IN_A_022_o <= {rl{1'b0}};
      REG_IN_A_023_o <= {rl{1'b0}};
      REG_IN_A_024_o <= {rl{1'b0}};
      REG_IN_A_025_o <= {rl{1'b0}};
      REG_IN_A_026_o <= {rl{1'b0}};
      REG_IN_A_027_o <= {rl{1'b0}};
      REG_IN_A_028_o <= {rl{1'b0}};
      REG_IN_A_029_o <= {rl{1'b0}};
      REG_IN_A_030_o <= {rl{1'b0}};
      REG_IN_A_031_o <= {rl{1'b0}};
      REG_IN_A_032_o <= {rl{1'b0}};
      REG_IN_A_033_o <= {rl{1'b0}};
      REG_IN_A_034_o <= {rl{1'b0}};
      REG_IN_A_035_o <= {rl{1'b0}};
      REG_IN_A_036_o <= {rl{1'b0}};
      REG_IN_A_037_o <= {rl{1'b0}};
      REG_IN_A_038_o <= {rl{1'b0}};
      REG_IN_A_039_o <= {rl{1'b0}};
      REG_IN_A_040_o <= {rl{1'b0}};
      REG_IN_A_041_o <= {rl{1'b0}};
      REG_IN_A_042_o <= {rl{1'b0}};
      REG_IN_A_043_o <= {rl{1'b0}};
      REG_IN_A_044_o <= {rl{1'b0}};
      REG_IN_A_039_o <= {rl{1'b0}};
      REG_IN_A_040_o <= {rl{1'b0}};
      REG_IN_A_041_o <= {rl{1'b0}};
      REG_IN_A_042_o <= {rl{1'b0}};
      REG_IN_A_043_o <= {rl{1'b0}};
      REG_IN_A_044_o <= {rl{1'b0}};
      REG_IN_A_045_o <= {rl{1'b0}};
      REG_IN_A_046_o <= {rl{1'b0}};
      REG_IN_A_047_o <= {rl{1'b0}};
      REG_IN_A_048_o <= {rl{1'b0}};
      REG_IN_A_049_o <= {rl{1'b0}};
      REG_IN_A_050_o <= {rl{1'b0}};
      REG_IN_A_051_o <= {rl{1'b0}};
      REG_IN_A_052_o <= {rl{1'b0}};
      REG_IN_A_053_o <= {rl{1'b0}};
      REG_IN_A_054_o <= {rl{1'b0}};
      REG_IN_A_055_o <= {rl{1'b0}};
      REG_IN_A_056_o <= {rl{1'b0}};
      REG_IN_A_057_o <= {rl{1'b0}};
      REG_IN_A_058_o <= {rl{1'b0}};
      REG_IN_A_059_o <= {rl{1'b0}};
      REG_IN_A_060_o <= {rl{1'b0}};
      REG_IN_A_061_o <= {rl{1'b0}};
      REG_IN_A_062_o <= {rl{1'b0}};
      REG_IN_A_063_o <= {rl{1'b0}};


      REG_IN_B_000_o <= {rl{1'b0}};
      clk_cnt <= 0;
    end else if (transfer_enable_flag_i == 1'b1) begin
      if (rst_for_logmel_i) begin
        if (clk_cnt < 1024) begin
          REG_IN_B_000_o <= 2'b1;
        end else if ((clk_cnt % 1024 < 160)) begin
          REG_IN_B_000_o <= 2'b1;
        end else if ((clk_cnt % 1024) >= 160) begin
          REG_IN_B_000_o <= 2'd2;
        end else begin
          REG_IN_B_000_o <= 2'b0;
        end

        if (((0 < clk_cnt) & (clk_cnt < 1024)) | (clk_cnt >= 1024 & (clk_cnt % 1024 < 160))) begin // clk_cnt==0を除いているのは0の時はその時入ってる値をlogmelにいれたいため
          REG_IN_A_000_o <= REG_IN_A_001_o;
          REG_IN_A_001_o <= REG_IN_A_002_o;
          REG_IN_A_002_o <= REG_IN_A_003_o;
          REG_IN_A_003_o <= REG_IN_A_004_o;
          REG_IN_A_004_o <= REG_IN_A_005_o;
          REG_IN_A_005_o <= REG_IN_A_006_o;
          REG_IN_A_006_o <= REG_IN_A_007_o;
          REG_IN_A_007_o <= REG_IN_A_008_o;
          REG_IN_A_008_o <= REG_IN_A_009_o;
          REG_IN_A_009_o <= REG_IN_A_010_o;
          REG_IN_A_010_o <= REG_IN_A_011_o;
          REG_IN_A_011_o <= REG_IN_A_012_o;
          REG_IN_A_012_o <= REG_IN_A_013_o;
          REG_IN_A_013_o <= REG_IN_A_014_o;
          REG_IN_A_014_o <= REG_IN_A_015_o;
          REG_IN_A_015_o <= REG_IN_A_016_o;
          REG_IN_A_016_o <= REG_IN_A_017_o;
          REG_IN_A_017_o <= REG_IN_A_018_o;
          REG_IN_A_018_o <= REG_IN_A_019_o;
          REG_IN_A_019_o <= REG_IN_A_020_o;
          REG_IN_A_020_o <= REG_IN_A_021_o;
          REG_IN_A_021_o <= REG_IN_A_022_o;
          REG_IN_A_022_o <= REG_IN_A_023_o;
          REG_IN_A_023_o <= REG_IN_A_024_o;
          REG_IN_A_024_o <= REG_IN_A_025_o;
          REG_IN_A_025_o <= REG_IN_A_026_o;
          REG_IN_A_026_o <= REG_IN_A_027_o;
          REG_IN_A_027_o <= REG_IN_A_028_o;
          REG_IN_A_028_o <= REG_IN_A_029_o;
          REG_IN_A_029_o <= REG_IN_A_030_o;
          REG_IN_A_030_o <= REG_IN_A_031_o;
          REG_IN_A_031_o <= REG_IN_A_032_o;
          REG_IN_A_032_o <= REG_IN_A_033_o;
          REG_IN_A_033_o <= REG_IN_A_034_o;
          REG_IN_A_034_o <= REG_IN_A_035_o;
          REG_IN_A_035_o <= REG_IN_A_036_o;
          REG_IN_A_036_o <= REG_IN_A_037_o;
          REG_IN_A_037_o <= REG_IN_A_038_o;
          REG_IN_A_038_o <= REG_IN_A_039_o;
          REG_IN_A_039_o <= REG_IN_A_040_o;
          REG_IN_A_040_o <= REG_IN_A_041_o;
          REG_IN_A_041_o <= REG_IN_A_042_o;
          REG_IN_A_042_o <= REG_IN_A_043_o;
          REG_IN_A_043_o <= REG_IN_A_044_o;
          REG_IN_A_044_o <= REG_IN_A_045_o;
          REG_IN_A_045_o <= REG_IN_A_046_o;
          REG_IN_A_046_o <= REG_IN_A_047_o;
          REG_IN_A_047_o <= REG_IN_A_048_o;
          REG_IN_A_048_o <= REG_IN_A_049_o;
          REG_IN_A_049_o <= REG_IN_A_050_o;
          REG_IN_A_050_o <= REG_IN_A_051_o;
          REG_IN_A_051_o <= REG_IN_A_052_o;
          REG_IN_A_052_o <= REG_IN_A_053_o;
          REG_IN_A_053_o <= REG_IN_A_054_o;
          REG_IN_A_054_o <= REG_IN_A_055_o;
          REG_IN_A_055_o <= REG_IN_A_056_o;
          REG_IN_A_056_o <= REG_IN_A_057_o;
          REG_IN_A_057_o <= REG_IN_A_058_o;
          REG_IN_A_058_o <= REG_IN_A_059_o;
          REG_IN_A_059_o <= REG_IN_A_060_o;
          REG_IN_A_060_o <= REG_IN_A_061_o;
          REG_IN_A_061_o <= REG_IN_A_062_o;
          REG_IN_A_062_o <= REG_IN_A_063_o;
          REG_IN_A_063_o <= REG_IN_A_000_o;
          clk_cnt <= clk_cnt + 1;
        end else begin
          REG_IN_A_000_o <= REG_IN_A_000_o;
          REG_IN_A_001_o <= REG_IN_A_001_o;
          REG_IN_A_002_o <= REG_IN_A_002_o;
          REG_IN_A_003_o <= REG_IN_A_003_o;
          REG_IN_A_004_o <= REG_IN_A_004_o;
          REG_IN_A_005_o <= REG_IN_A_005_o;
          REG_IN_A_006_o <= REG_IN_A_006_o;
          REG_IN_A_007_o <= REG_IN_A_007_o;
          REG_IN_A_008_o <= REG_IN_A_008_o;
          REG_IN_A_009_o <= REG_IN_A_009_o;
          REG_IN_A_010_o <= REG_IN_A_010_o;
          REG_IN_A_011_o <= REG_IN_A_011_o;
          REG_IN_A_012_o <= REG_IN_A_012_o;
          REG_IN_A_013_o <= REG_IN_A_013_o;
          REG_IN_A_014_o <= REG_IN_A_014_o;
          REG_IN_A_015_o <= REG_IN_A_015_o;
          REG_IN_A_016_o <= REG_IN_A_016_o;
          REG_IN_A_017_o <= REG_IN_A_017_o;
          REG_IN_A_018_o <= REG_IN_A_018_o;
          REG_IN_A_019_o <= REG_IN_A_019_o;
          REG_IN_A_020_o <= REG_IN_A_020_o;
          REG_IN_A_021_o <= REG_IN_A_021_o;
          REG_IN_A_022_o <= REG_IN_A_022_o;
          REG_IN_A_023_o <= REG_IN_A_023_o;
          REG_IN_A_024_o <= REG_IN_A_024_o;
          REG_IN_A_025_o <= REG_IN_A_025_o;
          REG_IN_A_026_o <= REG_IN_A_026_o;
          REG_IN_A_027_o <= REG_IN_A_027_o;
          REG_IN_A_028_o <= REG_IN_A_028_o;
          REG_IN_A_029_o <= REG_IN_A_029_o;
          REG_IN_A_030_o <= REG_IN_A_030_o;
          REG_IN_A_031_o <= REG_IN_A_031_o;
          REG_IN_A_032_o <= REG_IN_A_032_o;
          REG_IN_A_033_o <= REG_IN_A_033_o;
          REG_IN_A_034_o <= REG_IN_A_034_o;
          REG_IN_A_035_o <= REG_IN_A_035_o;
          REG_IN_A_036_o <= REG_IN_A_036_o;
          REG_IN_A_037_o <= REG_IN_A_037_o;
          REG_IN_A_038_o <= REG_IN_A_038_o;
          REG_IN_A_039_o <= REG_IN_A_039_o;
          REG_IN_A_040_o <= REG_IN_A_040_o;
          REG_IN_A_041_o <= REG_IN_A_041_o;
          REG_IN_A_042_o <= REG_IN_A_042_o;
          REG_IN_A_043_o <= REG_IN_A_043_o;
          REG_IN_A_044_o <= REG_IN_A_044_o;
          REG_IN_A_045_o <= REG_IN_A_045_o;
          REG_IN_A_046_o <= REG_IN_A_046_o;
          REG_IN_A_047_o <= REG_IN_A_047_o;
          REG_IN_A_048_o <= REG_IN_A_048_o;
          REG_IN_A_049_o <= REG_IN_A_049_o;
          REG_IN_A_050_o <= REG_IN_A_050_o;
          REG_IN_A_051_o <= REG_IN_A_051_o;
          REG_IN_A_052_o <= REG_IN_A_052_o;
          REG_IN_A_053_o <= REG_IN_A_053_o;
          REG_IN_A_054_o <= REG_IN_A_054_o;
          REG_IN_A_055_o <= REG_IN_A_055_o;
          REG_IN_A_056_o <= REG_IN_A_056_o;
          REG_IN_A_057_o <= REG_IN_A_057_o;
          REG_IN_A_058_o <= REG_IN_A_058_o;
          REG_IN_A_059_o <= REG_IN_A_059_o;
          REG_IN_A_060_o <= REG_IN_A_060_o;
          REG_IN_A_061_o <= REG_IN_A_061_o;
          REG_IN_A_062_o <= REG_IN_A_062_o;
          REG_IN_A_063_o <= REG_IN_A_063_o;
          clk_cnt <= clk_cnt + 1;
        end
      end else begin
        REG_IN_B_000_o <= 2'b0;
        REG_IN_A_000_o <= REG_IN_A_000_o;
        REG_IN_A_001_o <= REG_IN_A_001_o;
        REG_IN_A_002_o <= REG_IN_A_002_o;
        REG_IN_A_003_o <= REG_IN_A_003_o;
        REG_IN_A_004_o <= REG_IN_A_004_o;
        REG_IN_A_005_o <= REG_IN_A_005_o;
        REG_IN_A_006_o <= REG_IN_A_006_o;
        REG_IN_A_007_o <= REG_IN_A_007_o;
        REG_IN_A_008_o <= REG_IN_A_008_o;
        REG_IN_A_009_o <= REG_IN_A_009_o;
        REG_IN_A_010_o <= REG_IN_A_010_o;
        REG_IN_A_011_o <= REG_IN_A_011_o;
        REG_IN_A_012_o <= REG_IN_A_012_o;
        REG_IN_A_013_o <= REG_IN_A_013_o;
        REG_IN_A_014_o <= REG_IN_A_014_o;
        REG_IN_A_015_o <= REG_IN_A_015_o;
        REG_IN_A_016_o <= REG_IN_A_016_o;
        REG_IN_A_017_o <= REG_IN_A_017_o;
        REG_IN_A_018_o <= REG_IN_A_018_o;
        REG_IN_A_019_o <= REG_IN_A_019_o;
        REG_IN_A_020_o <= REG_IN_A_020_o;
        REG_IN_A_021_o <= REG_IN_A_021_o;
        REG_IN_A_022_o <= REG_IN_A_022_o;
        REG_IN_A_023_o <= REG_IN_A_023_o;
        REG_IN_A_024_o <= REG_IN_A_024_o;
        REG_IN_A_025_o <= REG_IN_A_025_o;
        REG_IN_A_026_o <= REG_IN_A_026_o;
        REG_IN_A_027_o <= REG_IN_A_027_o;
        REG_IN_A_028_o <= REG_IN_A_028_o;
        REG_IN_A_029_o <= REG_IN_A_029_o;
        REG_IN_A_030_o <= REG_IN_A_030_o;
        REG_IN_A_031_o <= REG_IN_A_031_o;
        REG_IN_A_032_o <= REG_IN_A_032_o;
        REG_IN_A_033_o <= REG_IN_A_033_o;
        REG_IN_A_034_o <= REG_IN_A_034_o;
        REG_IN_A_035_o <= REG_IN_A_035_o;
        REG_IN_A_036_o <= REG_IN_A_036_o;
        REG_IN_A_037_o <= REG_IN_A_037_o;
        REG_IN_A_038_o <= REG_IN_A_038_o;
        REG_IN_A_039_o <= REG_IN_A_039_o;
        REG_IN_A_040_o <= REG_IN_A_040_o;
        REG_IN_A_041_o <= REG_IN_A_041_o;
        REG_IN_A_042_o <= REG_IN_A_042_o;
        REG_IN_A_043_o <= REG_IN_A_043_o;
        REG_IN_A_044_o <= REG_IN_A_044_o;
        REG_IN_A_045_o <= REG_IN_A_045_o;
        REG_IN_A_046_o <= REG_IN_A_046_o;
        REG_IN_A_047_o <= REG_IN_A_047_o;
        REG_IN_A_048_o <= REG_IN_A_048_o;
        REG_IN_A_049_o <= REG_IN_A_049_o;
        REG_IN_A_050_o <= REG_IN_A_050_o;
        REG_IN_A_051_o <= REG_IN_A_051_o;
        REG_IN_A_052_o <= REG_IN_A_052_o;
        REG_IN_A_053_o <= REG_IN_A_053_o;
        REG_IN_A_054_o <= REG_IN_A_054_o;
        REG_IN_A_055_o <= REG_IN_A_055_o;
        REG_IN_A_056_o <= REG_IN_A_056_o;
        REG_IN_A_057_o <= REG_IN_A_057_o;
        REG_IN_A_058_o <= REG_IN_A_058_o;
        REG_IN_A_059_o <= REG_IN_A_059_o;
        REG_IN_A_060_o <= REG_IN_A_060_o;
        REG_IN_A_061_o <= REG_IN_A_061_o;
        REG_IN_A_062_o <= REG_IN_A_062_o;
        REG_IN_A_063_o <= REG_IN_A_063_o;
        clk_cnt <= clk_cnt;
      end
      // di_en_reg <= di_en_reg + 1'b1;
      // if (di_en_reg == 11'd1024) begin
      //    REG_IN_B_000_o <= 2'b0;
      // end
    end else begin
      if ((command_q == wc) && wr_pulse_q) begin // addr_in_qが入らないのはこいつらのせいではない
        case (addr_in_q)
          15'd0:  REG_IN_A_000_o <= wr_data[rl-1:0];
          15'd1:  REG_IN_A_001_o <= wr_data[rl-1:0];
          15'd2:  REG_IN_A_002_o <= wr_data[rl-1:0];
          15'd3:  REG_IN_A_003_o <= wr_data[rl-1:0];
          15'd4:  REG_IN_A_004_o <= wr_data[rl-1:0];
          15'd5:  REG_IN_A_005_o <= wr_data[rl-1:0];
          15'd6:  REG_IN_A_006_o <= wr_data[rl-1:0];
          15'd7:  REG_IN_A_007_o <= wr_data[rl-1:0];
          15'd8:  REG_IN_A_008_o <= wr_data[rl-1:0];
          15'd9:  REG_IN_A_009_o <= wr_data[rl-1:0];
          15'd10: REG_IN_A_010_o <= wr_data[rl-1:0];
          15'd11: REG_IN_A_011_o <= wr_data[rl-1:0];
          15'd12: REG_IN_A_012_o <= wr_data[rl-1:0];
          15'd13: REG_IN_A_013_o <= wr_data[rl-1:0];
          15'd14: REG_IN_A_014_o <= wr_data[rl-1:0];
          15'd15: REG_IN_A_015_o <= wr_data[rl-1:0];
          15'd16: REG_IN_A_016_o <= wr_data[rl-1:0];
          15'd17: REG_IN_A_017_o <= wr_data[rl-1:0];
          15'd18: REG_IN_A_018_o <= wr_data[rl-1:0];
          15'd19: REG_IN_A_019_o <= wr_data[rl-1:0];
          15'd20: REG_IN_A_020_o <= wr_data[rl-1:0];
          15'd21: REG_IN_A_021_o <= wr_data[rl-1:0];
          15'd22: REG_IN_A_022_o <= wr_data[rl-1:0];
          15'd23: REG_IN_A_023_o <= wr_data[rl-1:0];
          15'd24: REG_IN_A_024_o <= wr_data[rl-1:0];
          15'd25: REG_IN_A_025_o <= wr_data[rl-1:0];
          15'd26: REG_IN_A_026_o <= wr_data[rl-1:0];
          15'd27: REG_IN_A_027_o <= wr_data[rl-1:0];
          15'd28: REG_IN_A_028_o <= wr_data[rl-1:0];
          15'd29: REG_IN_A_029_o <= wr_data[rl-1:0];
          15'd30: REG_IN_A_030_o <= wr_data[rl-1:0];
          15'd31: REG_IN_A_031_o <= wr_data[rl-1:0];
          15'd32: REG_IN_A_032_o <= wr_data[rl-1:0];
          15'd33: REG_IN_A_033_o <= wr_data[rl-1:0];
          15'd34: REG_IN_A_034_o <= wr_data[rl-1:0];
          15'd35: REG_IN_A_035_o <= wr_data[rl-1:0];
          15'd36: REG_IN_A_036_o <= wr_data[rl-1:0];
          15'd37: REG_IN_A_037_o <= wr_data[rl-1:0];
          15'd38: REG_IN_A_038_o <= wr_data[rl-1:0];
          15'd39: REG_IN_A_039_o <= wr_data[rl-1:0];
          15'd40: REG_IN_A_040_o <= wr_data[rl-1:0];
          15'd41: REG_IN_A_041_o <= wr_data[rl-1:0];
          15'd42: REG_IN_A_042_o <= wr_data[rl-1:0];
          15'd43: REG_IN_A_043_o <= wr_data[rl-1:0];
          15'd44: REG_IN_A_044_o <= wr_data[rl-1:0];
          15'd45: REG_IN_A_045_o <= wr_data[rl-1:0];
          15'd46: REG_IN_A_046_o <= wr_data[rl-1:0];
          15'd47: REG_IN_A_047_o <= wr_data[rl-1:0];
          15'd48: REG_IN_A_048_o <= wr_data[rl-1:0];
          15'd49: REG_IN_A_049_o <= wr_data[rl-1:0];
          15'd50: REG_IN_A_050_o <= wr_data[rl-1:0];
          15'd51: REG_IN_A_051_o <= wr_data[rl-1:0];
          15'd52: REG_IN_A_052_o <= wr_data[rl-1:0];
          15'd53: REG_IN_A_053_o <= wr_data[rl-1:0];
          15'd54: REG_IN_A_054_o <= wr_data[rl-1:0];
          15'd55: REG_IN_A_055_o <= wr_data[rl-1:0];
          15'd56: REG_IN_A_056_o <= wr_data[rl-1:0];
          15'd57: REG_IN_A_057_o <= wr_data[rl-1:0];
          15'd58: REG_IN_A_058_o <= wr_data[rl-1:0];
          15'd59: REG_IN_A_059_o <= wr_data[rl-1:0];
          15'd60: REG_IN_A_060_o <= wr_data[rl-1:0];
          15'd61: REG_IN_A_061_o <= wr_data[rl-1:0];
          15'd62: REG_IN_A_062_o <= wr_data[rl-1:0];
          15'd63: REG_IN_A_063_o <= wr_data[rl-1:0];

          15'b111111111111111: REG_IN_B_000_o <= wr_data[rl-1:0];
        endcase
      end
    else if (spi_reg_out_req_i) begin // この条件がおかしいしaddr_in_qのまわり方もおかしい
        $display("REG_OUT_A_000_i[13*1-1:13*0]=%d", REG_OUT_A_000_i[13*1-1:13*0]);
        case (spi_reg_out_req_addr_i)
          15'b111111111111111: data_o[rl-1:0] <= REG_IN_B_000_o;

          15'd0:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*1-1:13*0]};
          15'd1:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*2-1:13*1]};
          15'd2:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*3-1:13*2]};
          15'd3:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*4-1:13*3]};
          15'd4:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*5-1:13*4]};
          15'd5:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*6-1:13*5]};
          15'd6:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*7-1:13*6]};
          15'd7:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*8-1:13*7]};
          15'd8:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*9-1:13*8]};
          15'd9:  data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*10-1:13*9]};
          15'd10: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*11-1:13*10]};
          15'd11: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*12-1:13*11]};
          15'd12: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*13-1:13*12]};
          15'd13: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*14-1:13*13]};
          15'd14: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*15-1:13*14]};
          15'd15: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*16-1:13*15]};
          15'd16: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*17-1:13*16]};
          15'd17: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*18-1:13*17]};
          15'd18: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*19-1:13*18]};
          15'd19: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*20-1:13*19]};
          15'd20: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*21-1:13*20]};
          15'd21: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*22-1:13*21]};
          15'd22: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*23-1:13*22]};
          15'd23: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*24-1:13*23]};
          15'd24: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*25-1:13*24]};
          15'd25: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*26-1:13*25]};
          15'd26: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*27-1:13*26]};
          15'd27: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*28-1:13*27]};
          15'd28: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*29-1:13*28]};
          15'd29: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*30-1:13*29]};
          15'd30: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*31-1:13*30]};
          15'd31: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*32-1:13*31]};
          15'd32: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*33-1:13*32]};
          15'd33: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*34-1:13*33]};
          15'd34: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*35-1:13*34]};
          15'd35: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*36-1:13*35]};
          15'd36: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*37-1:13*36]};
          15'd37: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*38-1:13*37]};
          15'd38: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*39-1:13*38]};
          15'd39: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*40-1:13*39]};
          15'd40: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*41-1:13*40]};
          15'd41: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*42-1:13*41]};
          15'd42: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*43-1:13*42]};
          15'd43: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*44-1:13*43]};
          15'd44: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*45-1:13*44]};
          15'd45: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*46-1:13*45]};
          15'd46: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*47-1:13*46]};
          15'd47: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*48-1:13*47]};
          15'd48: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*49-1:13*48]};
          15'd49: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*50-1:13*49]};
          15'd50: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*51-1:13*50]};
          15'd51: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*52-1:13*51]};
          15'd52: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*53-1:13*52]};
          15'd53: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*54-1:13*53]};
          15'd54: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*55-1:13*54]};
          15'd55: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*56-1:13*55]};
          15'd56: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*57-1:13*56]};
          15'd57: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*58-1:13*57]};
          15'd58: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*59-1:13*58]};
          15'd59: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*60-1:13*59]};
          15'd60: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*61-1:13*60]};
          15'd61: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*62-1:13*61]};
          15'd62: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*63-1:13*62]};
          15'd63: data_o[rl-1:0] <= {1'b1, REG_OUT_A_000_i[13*64-1:13*63]};


          // 15'd65:      data_o[rl-1:0] <= REG_OUT_B_000_i;

          default: data_o <= {dl{1'b0}};
        endcase
      end
    end
  end
endmodule  //spi_regs

