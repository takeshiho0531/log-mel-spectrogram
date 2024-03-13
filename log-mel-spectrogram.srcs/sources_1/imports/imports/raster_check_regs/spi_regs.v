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
rst_n,
spi_cs,
command,
transfer_enable_flag,
sys_clk,
selected_sys_clk,
addr_in,
data_in,
next,
wr_act,
data_out,

// BASIC Registers 
REG_IN_A_000,
REG_IN_A_001,
REG_IN_A_002,
REG_IN_A_003,
REG_IN_A_004,
REG_IN_A_005,
REG_IN_A_006,
REG_IN_A_007,
REG_IN_A_008,
REG_IN_A_009,
REG_IN_A_010,
REG_IN_A_011,
REG_IN_A_012,
REG_IN_A_013,
REG_IN_A_014,
REG_IN_A_015,
REG_IN_A_016,
REG_IN_A_017,
REG_IN_A_018,
REG_IN_A_019,
REG_IN_A_020,
REG_IN_A_021,
REG_IN_A_022,
REG_IN_A_023,
REG_IN_A_024,
REG_IN_A_025,
REG_IN_A_026,
REG_IN_A_027,
REG_IN_A_028,
REG_IN_A_029,
REG_IN_A_030,
REG_IN_A_031,
REG_IN_A_032,
REG_IN_A_033,
REG_IN_A_034,
REG_IN_A_035,
REG_IN_A_036,
REG_IN_A_037,
REG_IN_A_038,
REG_IN_A_039,
REG_IN_A_040,
REG_IN_A_041,
REG_IN_A_042,
REG_IN_A_043,
REG_IN_A_044,
REG_IN_A_045,
REG_IN_A_046,
REG_IN_A_047,
REG_IN_A_048,
REG_IN_A_049,
REG_IN_A_050,
REG_IN_A_051,
REG_IN_A_052,
REG_IN_A_053,
REG_IN_A_054,
REG_IN_A_055,
REG_IN_A_056,
REG_IN_A_057,
REG_IN_A_058,
REG_IN_A_059,
REG_IN_A_060,
REG_IN_A_061,
REG_IN_A_062,
REG_IN_A_063,
REG_IN_B_000,

REG_OUT_A_000,
REG_OUT_B_000,
rst_for_logmel
);

//-----------------------------------------------------------------------
// Parameter Definition
//-----------------------------------------------------------------------
// packet parameter
parameter al = 15;		// address length, excluding R/W bit
parameter dl = 24;		// data length
parameter wc = 1'b1;		// write command
parameter rc = 1'b0;		// read command
parameter rl = 14;       // register length


//-----------------------------------------------------------------------
// Port Declaration
//-----------------------------------------------------------------------
input			rst_n;
input			spi_cs;
input			command;
input	[al-1:0]	addr_in;
input	[dl-1:0]	data_in;
input			next;
input			wr_act;
input       sys_clk;
input       selected_sys_clk;
input       transfer_enable_flag;
output   reg	[dl-1:0]	data_out;

// BASIC Registers
output   reg  [rl-1:0]        REG_IN_A_000;
output   reg  [rl-1:0]        REG_IN_A_001;
output   reg  [rl-1:0]        REG_IN_A_002;
output   reg  [rl-1:0]        REG_IN_A_003;
output   reg  [rl-1:0]        REG_IN_A_004;
output   reg  [rl-1:0]        REG_IN_A_005;
output   reg  [rl-1:0]        REG_IN_A_006;
output   reg  [rl-1:0]        REG_IN_A_007;
output   reg  [rl-1:0]        REG_IN_A_008;
output   reg  [rl-1:0]        REG_IN_A_009;
output   reg  [rl-1:0]        REG_IN_A_010;
output   reg  [rl-1:0]        REG_IN_A_011;
output   reg  [rl-1:0]        REG_IN_A_012;
output   reg  [rl-1:0]        REG_IN_A_013;
output   reg  [rl-1:0]        REG_IN_A_014;
output   reg  [rl-1:0]        REG_IN_A_015;
output   reg  [rl-1:0]        REG_IN_A_016;
output   reg  [rl-1:0]        REG_IN_A_017;
output   reg  [rl-1:0]        REG_IN_A_018;
output   reg  [rl-1:0]        REG_IN_A_019;
output   reg  [rl-1:0]        REG_IN_A_020;
output   reg  [rl-1:0]        REG_IN_A_021;
output   reg  [rl-1:0]        REG_IN_A_022;
output   reg  [rl-1:0]        REG_IN_A_023;
output   reg  [rl-1:0]        REG_IN_A_024;
output   reg  [rl-1:0]        REG_IN_A_025;
output   reg  [rl-1:0]        REG_IN_A_026;
output   reg  [rl-1:0]        REG_IN_A_027;
output   reg  [rl-1:0]        REG_IN_A_028;
output   reg  [rl-1:0]        REG_IN_A_029;
output   reg  [rl-1:0]        REG_IN_A_030;
output   reg  [rl-1:0]        REG_IN_A_031;
output   reg  [rl-1:0]        REG_IN_A_032;
output   reg  [rl-1:0]        REG_IN_A_033;
output   reg  [rl-1:0]        REG_IN_A_034;
output   reg  [rl-1:0]        REG_IN_A_035;
output   reg  [rl-1:0]        REG_IN_A_036;
output   reg  [rl-1:0]        REG_IN_A_037;
output   reg  [rl-1:0]        REG_IN_A_038;
output   reg  [rl-1:0]        REG_IN_A_039;
output   reg  [rl-1:0]        REG_IN_A_040;
output   reg  [rl-1:0]        REG_IN_A_041;
output   reg  [rl-1:0]        REG_IN_A_042;
output   reg  [rl-1:0]        REG_IN_A_043;
output   reg  [rl-1:0]        REG_IN_A_044;
output   reg  [rl-1:0]        REG_IN_A_045;
output   reg  [rl-1:0]        REG_IN_A_046;
output   reg  [rl-1:0]        REG_IN_A_047;
output   reg  [rl-1:0]        REG_IN_A_048;
output   reg  [rl-1:0]        REG_IN_A_049;
output   reg  [rl-1:0]        REG_IN_A_050;
output   reg  [rl-1:0]        REG_IN_A_051;
output   reg  [rl-1:0]        REG_IN_A_052;
output   reg  [rl-1:0]        REG_IN_A_053;
output   reg  [rl-1:0]        REG_IN_A_054;
output   reg  [rl-1:0]        REG_IN_A_055;
output   reg  [rl-1:0]        REG_IN_A_056;
output   reg  [rl-1:0]        REG_IN_A_057;
output   reg  [rl-1:0]        REG_IN_A_058;
output   reg  [rl-1:0]        REG_IN_A_059;
output   reg  [rl-1:0]        REG_IN_A_060;
output   reg  [rl-1:0]        REG_IN_A_061;
output   reg  [rl-1:0]        REG_IN_A_062;
output   reg  [rl-1:0]        REG_IN_A_063;
output   reg  [rl-1:0]        REG_IN_B_000;

input   [(rl*64)-1:0]              REG_OUT_A_000;

input   [rl-1:0]              REG_OUT_B_000;
input rst_for_logmel;

//-----------------------------------------------------------------------
// Signal Declaration
//-----------------------------------------------------------------------
wire			rst_n;
wire			spi_cs;
wire			command;
wire	[al-1:0]	addr_in;
wire	[dl-1:0]	data_in;
wire			next;
wire			wr_act;

//--- asynchronous handshaking
reg			spi_cs_q;
reg			next_q1;
reg			next_q2;
reg			next_q3;
reg			rd_act_q1;
reg			rd_act_q2;
reg			wr_act_q1;
reg			wr_act_q2;
reg			wr_act_q3;
reg			wr_pulse;
reg			wr_pulse_q;
reg	[dl-1:0]	wr_data;
reg	[al-1:0]	addr_in_q;
reg			command_q;

reg   [10:0] di_en_reg;
// reg   [9:0]  di_en_sub_reg;
integer clk_cnt;

initial begin
   di_en_reg <= 11'b0;
   clk_cnt <= 0;
   // di_en_sub_reg <= 10'b0;
end

always @(posedge sys_clk or negedge rst_n) begin
   if (!rst_n) begin
      spi_cs_q <= 1'b0;   
   end

   else if (transfer_enable_flag == 1'b0) begin
      spi_cs_q <= spi_cs;
   end
end


always @(posedge sys_clk or negedge rst_n)
if (!rst_n)
   begin
   next_q1 <= 1'b0;
   next_q2 <= 1'b0;
   next_q3 <= 1'b0;
   end
else if (transfer_enable_flag == 1'b0) 
   begin
   next_q1 <= next;
   next_q2 <= next_q1;
   next_q3 <= next_q2;
   end

always @(posedge sys_clk or negedge rst_n) begin
if (!rst_n)
   begin
   wr_act_q1 <= 1'b0;
   wr_act_q2 <= 1'b0;
   wr_act_q3 <= 1'b0;
   end
else if (transfer_enable_flag == 1'b0)
   begin
   wr_act_q1 <= wr_act;
   wr_act_q2 <= wr_act_q1;
   wr_act_q3 <= wr_act_q2;
   end
end

always @(posedge sys_clk or negedge rst_n) begin
if (!rst_n)
begin
   wr_pulse   <= 1'b0;
   wr_pulse_q <= 1'b0;
end
else if (transfer_enable_flag == 1'b0)
   begin
      wr_pulse   <= wr_act_q2 && ~wr_act_q3;
      wr_pulse_q <= wr_pulse;
   end
end

always @(posedge sys_clk or negedge rst_n)
if (!rst_n)
begin
   rd_act_q1 <= 1'b0;
   rd_act_q2 <= 1'b0;
end
else if (transfer_enable_flag == 1'b0)
begin
   rd_act_q1 <= next_q2 && ~next_q3;
   rd_act_q2 <= rd_act_q1;
end

always @(posedge sys_clk or negedge rst_n) begin
// $display("addr_in=%d, addr_in_q=%d", addr_in, addr_in_q);  // ここの時点で62までしか入ってない
if (!rst_n)
   addr_in_q <= {al{1'b0}};
else if (transfer_enable_flag == 1'b0) begin
   if (rd_act_q1)
      addr_in_q <= addr_in;
   else
      addr_in_q <= addr_in_q;
end
end

always @(posedge sys_clk or negedge rst_n) begin
if (!rst_n)
   wr_data <= {dl{1'b0}};
else if (transfer_enable_flag == 1'b0) begin
   if (wr_pulse)
      wr_data <= data_in;
   else
      wr_data <= wr_data;
end
end

always @(posedge sys_clk or negedge rst_n) begin
$display("addr_in_q=%d, data_out=%d, REG_OUT_A_000[100]=%d", addr_in_q, data_out, REG_OUT_A_000[100]);
if (!rst_n)
   command_q <= 1'b0;
else if (transfer_enable_flag == 1'b0) begin
   if (~spi_cs_q)
      command_q <= command;
   else
      command_q <= command_q;
end
end

always @(posedge selected_sys_clk or negedge rst_n) begin
if (!rst_n) begin
   REG_IN_A_000 <= {rl{1'b0}};
   REG_IN_A_001 <= {rl{1'b0}};
   REG_IN_A_002 <= {rl{1'b0}};
   REG_IN_A_003 <= {rl{1'b0}};
   REG_IN_A_004 <= {rl{1'b0}};
   REG_IN_A_005 <= {rl{1'b0}};
   REG_IN_A_006 <= {rl{1'b0}};
   REG_IN_A_007 <= {rl{1'b0}};
   REG_IN_A_008 <= {rl{1'b0}};
   REG_IN_A_009 <= {rl{1'b0}};
   REG_IN_A_010 <= {rl{1'b0}};
   REG_IN_A_011 <= {rl{1'b0}};
   REG_IN_A_012 <= {rl{1'b0}};
   REG_IN_A_013 <= {rl{1'b0}};
   REG_IN_A_014 <= {rl{1'b0}};
   REG_IN_A_015 <= {rl{1'b0}};
   REG_IN_A_016 <= {rl{1'b0}};
   REG_IN_A_017 <= {rl{1'b0}};
   REG_IN_A_018 <= {rl{1'b0}};
   REG_IN_A_019 <= {rl{1'b0}};
   REG_IN_A_020 <= {rl{1'b0}};
   REG_IN_A_021 <= {rl{1'b0}};
   REG_IN_A_022 <= {rl{1'b0}};
   REG_IN_A_023 <= {rl{1'b0}};
   REG_IN_A_024 <= {rl{1'b0}};
   REG_IN_A_025 <= {rl{1'b0}};
   REG_IN_A_026 <= {rl{1'b0}};
   REG_IN_A_027 <= {rl{1'b0}};
   REG_IN_A_028 <= {rl{1'b0}};
   REG_IN_A_029 <= {rl{1'b0}};
   REG_IN_A_030 <= {rl{1'b0}};
   REG_IN_A_031 <= {rl{1'b0}};
   REG_IN_A_032 <= {rl{1'b0}};
   REG_IN_A_033 <= {rl{1'b0}};
   REG_IN_A_034 <= {rl{1'b0}};
   REG_IN_A_035 <= {rl{1'b0}};
   REG_IN_A_036 <= {rl{1'b0}};
   REG_IN_A_037 <= {rl{1'b0}};
   REG_IN_A_038 <= {rl{1'b0}};
   REG_IN_A_039 <= {rl{1'b0}};
   REG_IN_A_040 <= {rl{1'b0}};
   REG_IN_A_041 <= {rl{1'b0}};
   REG_IN_A_042 <= {rl{1'b0}};
   REG_IN_A_043 <= {rl{1'b0}};
   REG_IN_A_044 <= {rl{1'b0}};
   REG_IN_A_039 <= {rl{1'b0}};
   REG_IN_A_040 <= {rl{1'b0}};
   REG_IN_A_041 <= {rl{1'b0}};
   REG_IN_A_042 <= {rl{1'b0}};
   REG_IN_A_043 <= {rl{1'b0}};
   REG_IN_A_044 <= {rl{1'b0}};
   REG_IN_A_045 <= {rl{1'b0}};
   REG_IN_A_046 <= {rl{1'b0}};
   REG_IN_A_047 <= {rl{1'b0}};
   REG_IN_A_048 <= {rl{1'b0}};
   REG_IN_A_049 <= {rl{1'b0}};
   REG_IN_A_050 <= {rl{1'b0}};
   REG_IN_A_051 <= {rl{1'b0}};
   REG_IN_A_052 <= {rl{1'b0}};
   REG_IN_A_053 <= {rl{1'b0}};
   REG_IN_A_054 <= {rl{1'b0}};
   REG_IN_A_055 <= {rl{1'b0}};
   REG_IN_A_056 <= {rl{1'b0}};
   REG_IN_A_057 <= {rl{1'b0}};
   REG_IN_A_058 <= {rl{1'b0}};
   REG_IN_A_059 <= {rl{1'b0}};
   REG_IN_A_060 <= {rl{1'b0}};
   REG_IN_A_061 <= {rl{1'b0}};
   REG_IN_A_062 <= {rl{1'b0}};
   REG_IN_A_063 <= {rl{1'b0}};


   REG_IN_B_000 <= {rl{1'b0}};
   clk_cnt <= 0;
end
else if (transfer_enable_flag == 1'b1) begin
   if (rst_for_logmel) begin
      if (clk_cnt < 1024) begin
         REG_IN_B_000 <= 2'b1;
      end
      else if ((clk_cnt % 1024 < 160))begin
         REG_IN_B_000 <= 2'b1;
      end
      else if ((clk_cnt % 1024) >= 160) begin
         REG_IN_B_000 <= 2'd2;
      end
      else begin
         REG_IN_B_000 <= 2'b0;
      end

      if (((0 < clk_cnt) & (clk_cnt < 1024)) | (clk_cnt >= 1024 & (clk_cnt % 1024 < 160))) begin // clk_cnt==0を除いているのは0の時はその時入ってる値をlogmelにいれたいため
         REG_IN_A_000 <= REG_IN_A_001;
         REG_IN_A_001 <= REG_IN_A_002;
         REG_IN_A_002 <= REG_IN_A_003;
         REG_IN_A_003 <= REG_IN_A_004;
         REG_IN_A_004 <= REG_IN_A_005;
         REG_IN_A_005 <= REG_IN_A_006;
         REG_IN_A_006 <= REG_IN_A_007;
         REG_IN_A_007 <= REG_IN_A_008;
         REG_IN_A_008 <= REG_IN_A_009;
         REG_IN_A_009 <= REG_IN_A_010;
         REG_IN_A_010 <= REG_IN_A_011;
         REG_IN_A_011 <= REG_IN_A_012;
         REG_IN_A_012 <= REG_IN_A_013;
         REG_IN_A_013 <= REG_IN_A_014;
         REG_IN_A_014 <= REG_IN_A_015;
         REG_IN_A_015 <= REG_IN_A_016;
         REG_IN_A_016 <= REG_IN_A_017;
         REG_IN_A_017 <= REG_IN_A_018;
         REG_IN_A_018 <= REG_IN_A_019;
         REG_IN_A_019 <= REG_IN_A_020;
         REG_IN_A_020 <= REG_IN_A_021;
         REG_IN_A_021 <= REG_IN_A_022;
         REG_IN_A_022 <= REG_IN_A_023;
         REG_IN_A_023 <= REG_IN_A_024;
         REG_IN_A_024 <= REG_IN_A_025;
         REG_IN_A_025 <= REG_IN_A_026;
         REG_IN_A_026 <= REG_IN_A_027;
         REG_IN_A_027 <= REG_IN_A_028;
         REG_IN_A_028 <= REG_IN_A_029;
         REG_IN_A_029 <= REG_IN_A_030;
         REG_IN_A_030 <= REG_IN_A_031;
         REG_IN_A_031 <= REG_IN_A_032;
         REG_IN_A_032 <= REG_IN_A_033;
         REG_IN_A_033 <= REG_IN_A_034;
         REG_IN_A_034 <= REG_IN_A_035;
         REG_IN_A_035 <= REG_IN_A_036;
         REG_IN_A_036 <= REG_IN_A_037;
         REG_IN_A_037 <= REG_IN_A_038;
         REG_IN_A_038 <= REG_IN_A_039;
         REG_IN_A_039 <= REG_IN_A_040;
         REG_IN_A_040 <= REG_IN_A_041;
         REG_IN_A_041 <= REG_IN_A_042;
         REG_IN_A_042 <= REG_IN_A_043;
         REG_IN_A_043 <= REG_IN_A_044;
         REG_IN_A_044 <= REG_IN_A_045;
         REG_IN_A_045 <= REG_IN_A_046;
         REG_IN_A_046 <= REG_IN_A_047;
         REG_IN_A_047 <= REG_IN_A_048;
         REG_IN_A_048 <= REG_IN_A_049;
         REG_IN_A_049 <= REG_IN_A_050;
         REG_IN_A_050 <= REG_IN_A_051;
         REG_IN_A_051 <= REG_IN_A_052;
         REG_IN_A_052 <= REG_IN_A_053;
         REG_IN_A_053 <= REG_IN_A_054;
         REG_IN_A_054 <= REG_IN_A_055;
         REG_IN_A_055 <= REG_IN_A_056;
         REG_IN_A_056 <= REG_IN_A_057;
         REG_IN_A_057 <= REG_IN_A_058;
         REG_IN_A_058 <= REG_IN_A_059;
         REG_IN_A_059 <= REG_IN_A_060;
         REG_IN_A_060 <= REG_IN_A_061;
         REG_IN_A_061 <= REG_IN_A_062;
         REG_IN_A_062 <= REG_IN_A_063;
         REG_IN_A_063 <= REG_IN_A_000;
         clk_cnt <= clk_cnt + 1;
      end
      else begin
         REG_IN_A_000 <= REG_IN_A_000;
         REG_IN_A_001 <= REG_IN_A_001;
         REG_IN_A_002 <= REG_IN_A_002;
         REG_IN_A_003 <= REG_IN_A_003;
         REG_IN_A_004 <= REG_IN_A_004;
         REG_IN_A_005 <= REG_IN_A_005;
         REG_IN_A_006 <= REG_IN_A_006;
         REG_IN_A_007 <= REG_IN_A_007;
         REG_IN_A_008 <= REG_IN_A_008;
         REG_IN_A_009 <= REG_IN_A_009;
         REG_IN_A_010 <= REG_IN_A_010;
         REG_IN_A_011 <= REG_IN_A_011;
         REG_IN_A_012 <= REG_IN_A_012;
         REG_IN_A_013 <= REG_IN_A_013;
         REG_IN_A_014 <= REG_IN_A_014;
         REG_IN_A_015 <= REG_IN_A_015;
         REG_IN_A_016 <= REG_IN_A_016;
         REG_IN_A_017 <= REG_IN_A_017;
         REG_IN_A_018 <= REG_IN_A_018;
         REG_IN_A_019 <= REG_IN_A_019;
         REG_IN_A_020 <= REG_IN_A_020;
         REG_IN_A_021 <= REG_IN_A_021;
         REG_IN_A_022 <= REG_IN_A_022;
         REG_IN_A_023 <= REG_IN_A_023;
         REG_IN_A_024 <= REG_IN_A_024;
         REG_IN_A_025 <= REG_IN_A_025;
         REG_IN_A_026 <= REG_IN_A_026;
         REG_IN_A_027 <= REG_IN_A_027;
         REG_IN_A_028 <= REG_IN_A_028;
         REG_IN_A_029 <= REG_IN_A_029;
         REG_IN_A_030 <= REG_IN_A_030;
         REG_IN_A_031 <= REG_IN_A_031;
         REG_IN_A_032 <= REG_IN_A_032;
         REG_IN_A_033 <= REG_IN_A_033;
         REG_IN_A_034 <= REG_IN_A_034;
         REG_IN_A_035 <= REG_IN_A_035;
         REG_IN_A_036 <= REG_IN_A_036;
         REG_IN_A_037 <= REG_IN_A_037;
         REG_IN_A_038 <= REG_IN_A_038;
         REG_IN_A_039 <= REG_IN_A_039;
         REG_IN_A_040 <= REG_IN_A_040;
         REG_IN_A_041 <= REG_IN_A_041;
         REG_IN_A_042 <= REG_IN_A_042;
         REG_IN_A_043 <= REG_IN_A_043;
         REG_IN_A_044 <= REG_IN_A_044;
         REG_IN_A_045 <= REG_IN_A_045;
         REG_IN_A_046 <= REG_IN_A_046;
         REG_IN_A_047 <= REG_IN_A_047;
         REG_IN_A_048 <= REG_IN_A_048;
         REG_IN_A_049 <= REG_IN_A_049;
         REG_IN_A_050 <= REG_IN_A_050;
         REG_IN_A_051 <= REG_IN_A_051;
         REG_IN_A_052 <= REG_IN_A_052;
         REG_IN_A_053 <= REG_IN_A_053;
         REG_IN_A_054 <= REG_IN_A_054;
         REG_IN_A_055 <= REG_IN_A_055;
         REG_IN_A_056 <= REG_IN_A_056;
         REG_IN_A_057 <= REG_IN_A_057;
         REG_IN_A_058 <= REG_IN_A_058;
         REG_IN_A_059 <= REG_IN_A_059;
         REG_IN_A_060 <= REG_IN_A_060;
         REG_IN_A_061 <= REG_IN_A_061;
         REG_IN_A_062 <= REG_IN_A_062;
         REG_IN_A_063 <= REG_IN_A_063;
         clk_cnt <= clk_cnt + 1;
      end
   end
   else begin
      REG_IN_B_000 <= 2'b0;
      REG_IN_A_000 <= REG_IN_A_000;
      REG_IN_A_001 <= REG_IN_A_001;
      REG_IN_A_002 <= REG_IN_A_002;
      REG_IN_A_003 <= REG_IN_A_003;
      REG_IN_A_004 <= REG_IN_A_004;
      REG_IN_A_005 <= REG_IN_A_005;
      REG_IN_A_006 <= REG_IN_A_006;
      REG_IN_A_007 <= REG_IN_A_007;
      REG_IN_A_008 <= REG_IN_A_008;
      REG_IN_A_009 <= REG_IN_A_009;
      REG_IN_A_010 <= REG_IN_A_010;
      REG_IN_A_011 <= REG_IN_A_011;
      REG_IN_A_012 <= REG_IN_A_012;
      REG_IN_A_013 <= REG_IN_A_013;
      REG_IN_A_014 <= REG_IN_A_014;
      REG_IN_A_015 <= REG_IN_A_015;
      REG_IN_A_016 <= REG_IN_A_016;
      REG_IN_A_017 <= REG_IN_A_017;
      REG_IN_A_018 <= REG_IN_A_018;
      REG_IN_A_019 <= REG_IN_A_019;
      REG_IN_A_020 <= REG_IN_A_020;
      REG_IN_A_021 <= REG_IN_A_021;
      REG_IN_A_022 <= REG_IN_A_022;
      REG_IN_A_023 <= REG_IN_A_023;
      REG_IN_A_024 <= REG_IN_A_024;
      REG_IN_A_025 <= REG_IN_A_025;
      REG_IN_A_026 <= REG_IN_A_026;
      REG_IN_A_027 <= REG_IN_A_027;
      REG_IN_A_028 <= REG_IN_A_028;
      REG_IN_A_029 <= REG_IN_A_029;
      REG_IN_A_030 <= REG_IN_A_030;
      REG_IN_A_031 <= REG_IN_A_031;
      REG_IN_A_032 <= REG_IN_A_032;
      REG_IN_A_033 <= REG_IN_A_033;
      REG_IN_A_034 <= REG_IN_A_034;
      REG_IN_A_035 <= REG_IN_A_035;
      REG_IN_A_036 <= REG_IN_A_036;
      REG_IN_A_037 <= REG_IN_A_037;
      REG_IN_A_038 <= REG_IN_A_038;
      REG_IN_A_039 <= REG_IN_A_039;
      REG_IN_A_040 <= REG_IN_A_040;
      REG_IN_A_041 <= REG_IN_A_041;
      REG_IN_A_042 <= REG_IN_A_042;
      REG_IN_A_043 <= REG_IN_A_043;
      REG_IN_A_044 <= REG_IN_A_044;
      REG_IN_A_045 <= REG_IN_A_045;
      REG_IN_A_046 <= REG_IN_A_046;
      REG_IN_A_047 <= REG_IN_A_047;
      REG_IN_A_048 <= REG_IN_A_048;
      REG_IN_A_049 <= REG_IN_A_049;
      REG_IN_A_050 <= REG_IN_A_050;
      REG_IN_A_051 <= REG_IN_A_051;
      REG_IN_A_052 <= REG_IN_A_052;
      REG_IN_A_053 <= REG_IN_A_053;
      REG_IN_A_054 <= REG_IN_A_054;
      REG_IN_A_055 <= REG_IN_A_055;
      REG_IN_A_056 <= REG_IN_A_056;
      REG_IN_A_057 <= REG_IN_A_057;
      REG_IN_A_058 <= REG_IN_A_058;
      REG_IN_A_059 <= REG_IN_A_059;
      REG_IN_A_060 <= REG_IN_A_060;
      REG_IN_A_061 <= REG_IN_A_061;
      REG_IN_A_062 <= REG_IN_A_062;
      REG_IN_A_063 <= REG_IN_A_063;
      clk_cnt <= clk_cnt;
   end
   // di_en_reg <= di_en_reg + 1'b1;
   // if (di_en_reg == 11'd1024) begin
   //    REG_IN_B_000 <= 2'b0;
   // end
end
else begin
   if ((command_q == wc) && wr_pulse_q) begin // addr_in_qが入らないのはこいつらのせいではない
      case (addr_in_q)
         15'd0:   REG_IN_A_000 <= wr_data[rl-1:0];
         15'd1:   REG_IN_A_001 <= wr_data[rl-1:0];
         15'd2:   REG_IN_A_002 <= wr_data[rl-1:0];
         15'd3:   REG_IN_A_003 <= wr_data[rl-1:0];
         15'd4:   REG_IN_A_004 <= wr_data[rl-1:0];
         15'd5:   REG_IN_A_005 <= wr_data[rl-1:0];
         15'd6:   REG_IN_A_006 <= wr_data[rl-1:0];
         15'd7:   REG_IN_A_007 <= wr_data[rl-1:0];
         15'd8:   REG_IN_A_008 <= wr_data[rl-1:0];
         15'd9:   REG_IN_A_009 <= wr_data[rl-1:0];
         15'd10:   REG_IN_A_010 <= wr_data[rl-1:0];
         15'd11:   REG_IN_A_011 <= wr_data[rl-1:0];
         15'd12:   REG_IN_A_012 <= wr_data[rl-1:0];
         15'd13:   REG_IN_A_013 <= wr_data[rl-1:0];
         15'd14:   REG_IN_A_014 <= wr_data[rl-1:0];
         15'd15:   REG_IN_A_015 <= wr_data[rl-1:0];
         15'd16:   REG_IN_A_016 <= wr_data[rl-1:0];
         15'd17:   REG_IN_A_017 <= wr_data[rl-1:0];
         15'd18:   REG_IN_A_018 <= wr_data[rl-1:0];
         15'd19:   REG_IN_A_019 <= wr_data[rl-1:0];
         15'd20:   REG_IN_A_020 <= wr_data[rl-1:0];
         15'd21:   REG_IN_A_021 <= wr_data[rl-1:0];
         15'd22:   REG_IN_A_022 <= wr_data[rl-1:0];
         15'd23:   REG_IN_A_023 <= wr_data[rl-1:0];
         15'd24:   REG_IN_A_024 <= wr_data[rl-1:0];
         15'd25:   REG_IN_A_025 <= wr_data[rl-1:0];
         15'd26:   REG_IN_A_026 <= wr_data[rl-1:0];
         15'd27:   REG_IN_A_027 <= wr_data[rl-1:0];
         15'd28:   REG_IN_A_028 <= wr_data[rl-1:0];
         15'd29:   REG_IN_A_029 <= wr_data[rl-1:0];
         15'd30:   REG_IN_A_030 <= wr_data[rl-1:0];
         15'd31:   REG_IN_A_031 <= wr_data[rl-1:0];
         15'd32:   REG_IN_A_032 <= wr_data[rl-1:0];
         15'd33:   REG_IN_A_033 <= wr_data[rl-1:0];
         15'd34:   REG_IN_A_034 <= wr_data[rl-1:0];
         15'd35:   REG_IN_A_035 <= wr_data[rl-1:0];
         15'd36:   REG_IN_A_036 <= wr_data[rl-1:0];
         15'd37:   REG_IN_A_037 <= wr_data[rl-1:0];
         15'd38:   REG_IN_A_038 <= wr_data[rl-1:0];
         15'd39:   REG_IN_A_039 <= wr_data[rl-1:0];
         15'd40:   REG_IN_A_040 <= wr_data[rl-1:0];
         15'd41:   REG_IN_A_041 <= wr_data[rl-1:0];
         15'd42:   REG_IN_A_042 <= wr_data[rl-1:0];
         15'd43:   REG_IN_A_043 <= wr_data[rl-1:0];
         15'd44:   REG_IN_A_044 <= wr_data[rl-1:0];
         15'd45:   REG_IN_A_045 <= wr_data[rl-1:0];
         15'd46:   REG_IN_A_046 <= wr_data[rl-1:0];
         15'd47:   REG_IN_A_047 <= wr_data[rl-1:0];
         15'd48:   REG_IN_A_048 <= wr_data[rl-1:0];
         15'd49:   REG_IN_A_049 <= wr_data[rl-1:0];
         15'd50:   REG_IN_A_050 <= wr_data[rl-1:0];
         15'd51:   REG_IN_A_051 <= wr_data[rl-1:0];
         15'd52:   REG_IN_A_052 <= wr_data[rl-1:0];
         15'd53:   REG_IN_A_053 <= wr_data[rl-1:0];
         15'd54:   REG_IN_A_054 <= wr_data[rl-1:0];
         15'd55:   REG_IN_A_055 <= wr_data[rl-1:0];
         15'd56:   REG_IN_A_056 <= wr_data[rl-1:0];
         15'd57:   REG_IN_A_057 <= wr_data[rl-1:0];
         15'd58:   REG_IN_A_058 <= wr_data[rl-1:0];
         15'd59:   REG_IN_A_059 <= wr_data[rl-1:0];
         15'd60:   REG_IN_A_060 <= wr_data[rl-1:0];
         15'd61:   REG_IN_A_061 <= wr_data[rl-1:0];
         15'd62:   REG_IN_A_062 <= wr_data[rl-1:0];
         15'd63:   REG_IN_A_063 <= wr_data[rl-1:0];

         15'b111111111111111:   REG_IN_B_000 <= wr_data[rl-1:0];
      endcase
   end
   else if (rd_act_q2) begin // この条件がおかしいしaddr_in_qのまわり方もおかしい
      // $display("addr_in_q=%d, data_out=%d, REG_OUT_A_000[100]=%d", addr_in_q, data_out, REG_OUT_A_000[100]);
      case (addr_in_q)
         15'b111111111111111:      data_out[rl-1:0] <= REG_IN_B_000;

         15'd0:      data_out[rl-1:0] <= REG_OUT_A_000[13*1-1:13*0];
         15'd1:      data_out[rl-1:0] <= REG_OUT_A_000[13*2-1:13*1];
         15'd2:      data_out[rl-1:0] <= REG_OUT_A_000[13*3-1:13*2];
         15'd3:      data_out[rl-1:0] <= REG_OUT_A_000[13*4-1:13*3];
         15'd4:      data_out[rl-1:0] <= REG_OUT_A_000[13*5-1:13*4];
         15'd5:      data_out[rl-1:0] <= REG_OUT_A_000[13*6-1:13*5];
         15'd6:      data_out[rl-1:0] <= REG_OUT_A_000[13*7-1:13*6];
         15'd7:      data_out[rl-1:0] <= REG_OUT_A_000[13*8-1:13*7];
         15'd8:      data_out[rl-1:0] <= REG_OUT_A_000[13*9-1:13*8];
         15'd9:      data_out[rl-1:0] <= REG_OUT_A_000[13*10-1:13*9];
         15'd10:      data_out[rl-1:0] <= REG_OUT_A_000[13*11-1:13*10];
         15'd11:      data_out[rl-1:0] <= REG_OUT_A_000[13*12-1:13*11];
         15'd12:      data_out[rl-1:0] <= REG_OUT_A_000[13*13-1:13*12];
         15'd13:      data_out[rl-1:0] <= REG_OUT_A_000[13*14-1:13*13];
         15'd14:      data_out[rl-1:0] <= REG_OUT_A_000[13*15-1:13*14];
         15'd15:      data_out[rl-1:0] <= REG_OUT_A_000[13*16-1:13*15];
         15'd16:      data_out[rl-1:0] <= REG_OUT_A_000[13*17-1:13*16];
         15'd17:      data_out[rl-1:0] <= REG_OUT_A_000[13*18-1:13*17];
         15'd18:      data_out[rl-1:0] <= REG_OUT_A_000[13*19-1:13*18];
         15'd19:      data_out[rl-1:0] <= REG_OUT_A_000[13*20-1:13*19];
         15'd20:      data_out[rl-1:0] <= REG_OUT_A_000[13*21-1:13*20];
         15'd21:      data_out[rl-1:0] <= REG_OUT_A_000[13*22-1:13*21];
         15'd22:      data_out[rl-1:0] <= REG_OUT_A_000[13*23-1:13*22];
         15'd23:      data_out[rl-1:0] <= REG_OUT_A_000[13*24-1:13*23];
         15'd24:      data_out[rl-1:0] <= REG_OUT_A_000[13*25-1:13*24];
         15'd25:      data_out[rl-1:0] <= REG_OUT_A_000[13*26-1:13*25];
         15'd26:      data_out[rl-1:0] <= REG_OUT_A_000[13*27-1:13*26];
         15'd27:      data_out[rl-1:0] <= REG_OUT_A_000[13*28-1:13*27];
         15'd28:      data_out[rl-1:0] <= REG_OUT_A_000[13*29-1:13*28];
         15'd29:      data_out[rl-1:0] <= REG_OUT_A_000[13*30-1:13*29];
         15'd30:      data_out[rl-1:0] <= REG_OUT_A_000[13*31-1:13*30];
         15'd31:      data_out[rl-1:0] <= REG_OUT_A_000[13*32-1:13*31];
         15'd32:      data_out[rl-1:0] <= REG_OUT_A_000[13*33-1:13*32];
         15'd33:      data_out[rl-1:0] <= REG_OUT_A_000[13*34-1:13*33];
         15'd34:      data_out[rl-1:0] <= REG_OUT_A_000[13*35-1:13*34];
         15'd35:      data_out[rl-1:0] <= REG_OUT_A_000[13*36-1:13*35];
         15'd36:      data_out[rl-1:0] <= REG_OUT_A_000[13*37-1:13*36];
         15'd37:      data_out[rl-1:0] <= REG_OUT_A_000[13*38-1:13*37];
         15'd38:      data_out[rl-1:0] <= REG_OUT_A_000[13*39-1:13*38];
         15'd39:      data_out[rl-1:0] <= REG_OUT_A_000[13*40-1:13*39];
         15'd40:      data_out[rl-1:0] <= REG_OUT_A_000[13*41-1:13*40];
         15'd41:      data_out[rl-1:0] <= REG_OUT_A_000[13*42-1:13*41];
         15'd42:      data_out[rl-1:0] <= REG_OUT_A_000[13*43-1:13*42];
         15'd43:      data_out[rl-1:0] <= REG_OUT_A_000[13*44-1:13*43];
         15'd44:      data_out[rl-1:0] <= REG_OUT_A_000[13*45-1:13*44];
         15'd45:      data_out[rl-1:0] <= REG_OUT_A_000[13*46-1:13*45];
         15'd46:      data_out[rl-1:0] <= REG_OUT_A_000[13*47-1:13*46];
         15'd47:      data_out[rl-1:0] <= REG_OUT_A_000[13*48-1:13*47];
         15'd48:      data_out[rl-1:0] <= REG_OUT_A_000[13*49-1:13*48];
         15'd49:      data_out[rl-1:0] <= REG_OUT_A_000[13*50-1:13*49];
         15'd50:      data_out[rl-1:0] <= REG_OUT_A_000[13*51-1:13*50];
         15'd51:      data_out[rl-1:0] <= REG_OUT_A_000[13*52-1:13*51];
         15'd52:      data_out[rl-1:0] <= REG_OUT_A_000[13*53-1:13*52];
         15'd53:      data_out[rl-1:0] <= REG_OUT_A_000[13*54-1:13*53];
         15'd54:      data_out[rl-1:0] <= REG_OUT_A_000[13*55-1:13*54];
         15'd55:      data_out[rl-1:0] <= REG_OUT_A_000[13*56-1:13*55];
         15'd56:      data_out[rl-1:0] <= REG_OUT_A_000[13*57-1:13*56];
         15'd57:      data_out[rl-1:0] <= REG_OUT_A_000[13*58-1:13*57];
         15'd58:      data_out[rl-1:0] <= REG_OUT_A_000[13*59-1:13*58];
         15'd59:      data_out[rl-1:0] <= REG_OUT_A_000[13*60-1:13*59];
         15'd60:      data_out[rl-1:0] <= REG_OUT_A_000[13*61-1:13*60];
         15'd61:      data_out[rl-1:0] <= REG_OUT_A_000[13*62-1:13*61];
         15'd62:      data_out[rl-1:0] <= REG_OUT_A_000[13*63-1:13*62];
         15'd63:      data_out[rl-1:0] <= REG_OUT_A_000[13*64-1:13*63];


         15'd65:      data_out[rl-1:0] <= REG_OUT_B_000;

         default:       data_out <= {dl{1'b0}};
      endcase
   end
end
end
endmodule	//spi_regs

