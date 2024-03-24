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
clk_in,
sys_clk_in,
rst_n,
rst_for_logmel,

spi_clk_in,
spi_cs,
spi_mosi,
spi_miso,
spi_miso_en,

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
logmel_do_en,
logmel_data_o,

REG_OUT_A_000,

REG_OUT_B_000
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
input           clk_in;

input			sys_clk_in;
input			rst_n;
input           rst_for_logmel;

input			spi_clk_in;
input			spi_cs;
input			spi_mosi;
output			spi_miso;
output			spi_miso_en;

// BASIC Registers 
output  [rl-1:0]        REG_IN_A_000;
output  [rl-1:0]        REG_IN_A_001;
output  [rl-1:0]        REG_IN_A_002;
output  [rl-1:0]        REG_IN_A_003;
output  [rl-1:0]        REG_IN_A_004;
output  [rl-1:0]        REG_IN_A_005;
output  [rl-1:0]        REG_IN_A_006;
output  [rl-1:0]        REG_IN_A_007;
output  [rl-1:0]        REG_IN_A_008;
output  [rl-1:0]        REG_IN_A_009;
output  [rl-1:0]        REG_IN_A_010;
output  [rl-1:0]        REG_IN_A_011;
output  [rl-1:0]        REG_IN_A_012;
output  [rl-1:0]        REG_IN_A_013;
output  [rl-1:0]        REG_IN_A_014;
output  [rl-1:0]        REG_IN_A_015;
output  [rl-1:0]        REG_IN_A_016;
output  [rl-1:0]        REG_IN_A_017;
output  [rl-1:0]        REG_IN_A_018;
output  [rl-1:0]        REG_IN_A_019;
output  [rl-1:0]        REG_IN_A_020;
output  [rl-1:0]        REG_IN_A_021;
output  [rl-1:0]        REG_IN_A_022;
output  [rl-1:0]        REG_IN_A_023;
output  [rl-1:0]        REG_IN_A_024;
output  [rl-1:0]        REG_IN_A_025;
output  [rl-1:0]        REG_IN_A_026;
output  [rl-1:0]        REG_IN_A_027;
output  [rl-1:0]        REG_IN_A_028;
output  [rl-1:0]        REG_IN_A_029;
output  [rl-1:0]        REG_IN_A_030;
output  [rl-1:0]        REG_IN_A_031;
output  [rl-1:0]        REG_IN_A_032;
output  [rl-1:0]        REG_IN_A_033;
output  [rl-1:0]        REG_IN_A_034;
output  [rl-1:0]        REG_IN_A_035;
output  [rl-1:0]        REG_IN_A_036;
output  [rl-1:0]        REG_IN_A_037;
output  [rl-1:0]        REG_IN_A_038;
output  [rl-1:0]        REG_IN_A_039;
output  [rl-1:0]        REG_IN_A_040;
output  [rl-1:0]        REG_IN_A_041;
output  [rl-1:0]        REG_IN_A_042;
output  [rl-1:0]        REG_IN_A_043;
output  [rl-1:0]        REG_IN_A_044;
output  [rl-1:0]        REG_IN_A_045;
output  [rl-1:0]        REG_IN_A_046;
output  [rl-1:0]        REG_IN_A_047;
output  [rl-1:0]        REG_IN_A_048;
output  [rl-1:0]        REG_IN_A_049;
output  [rl-1:0]        REG_IN_A_050;
output  [rl-1:0]        REG_IN_A_051;
output  [rl-1:0]        REG_IN_A_052;
output  [rl-1:0]        REG_IN_A_053;
output  [rl-1:0]        REG_IN_A_054;
output  [rl-1:0]        REG_IN_A_055;
output  [rl-1:0]        REG_IN_A_056;
output  [rl-1:0]        REG_IN_A_057;
output  [rl-1:0]        REG_IN_A_058;
output  [rl-1:0]        REG_IN_A_059;
output  [rl-1:0]        REG_IN_A_060;
output  [rl-1:0]        REG_IN_A_061;
output  [rl-1:0]        REG_IN_A_062;
output  [rl-1:0]        REG_IN_A_063;
output logmel_do_en;
output [(14*64)-1:0] logmel_data_o;

output  [rl-1:0]        REG_IN_B_000;

input   [(rl*64)-1:0]        REG_OUT_A_000;


input   [rl-1:0]        REG_OUT_B_000;


//-----------------------------------------------------------------------
// Operations
//-----------------------------------------------------------------------
wire	[al-2:0]	addr_out;
wire	[dl-1:0]	wr_data;
wire	[dl-1:0]	rd_data;
wire			next;
wire			wr_act;
wire			command;
wire   transfer_enable_flag; //　追記




spi_clock spi_clock_inst(
// .spi_clk_in (spi_clk_in),  // 外部からのSPIクロック入力
.sys_clk_in (sys_clk_in),
.clk_in (clk_in),
.transfer_enable_flag(transfer_enable_flag),        // クロックを制御するフラグ
.clk_out(clk_out),
.selected_sys_clk(selected_sys_clk)
);

spi_if spi_if_inst(
.rst_n		(rst_n		),
.spi_cs		(spi_cs		),
.spi_mosi	(spi_mosi	),
.spi_miso	(spi_miso	),
.spi_miso_en	(spi_miso_en	),
.addr_out	(addr_out	),
.wr_data	(wr_data	),
.rd_data	(rd_data	),
.next		(next		),
.wr_act		(wr_act		),
.command	(command	),
.spi_clk    (spi_clk_in),
.transfer_enable_flag(transfer_enable_flag),
.clk(clk_in)
);


// spi_regs instance

spi_regs spi_regs_inst(
.rst_n		(rst_n		),
.spi_cs		(spi_cs		),
.addr_in	(addr_out	),
.data_in	(wr_data	),
.next		(next		),
.wr_act		(wr_act		),
.data_out	(rd_data	),
.command	(command	),
.transfer_enable_flag(transfer_enable_flag),
.sys_clk(sys_clk_in),
.selected_sys_clk(selected_sys_clk),

// BASIC Registers
.REG_IN_A_000   (REG_IN_A_000),
.REG_IN_A_001   (REG_IN_A_001),
.REG_IN_A_002   (REG_IN_A_002),
.REG_IN_A_003   (REG_IN_A_003),
.REG_IN_A_004   (REG_IN_A_004),
.REG_IN_A_005   (REG_IN_A_005),
.REG_IN_A_006   (REG_IN_A_006),
.REG_IN_A_007   (REG_IN_A_007),
.REG_IN_A_008   (REG_IN_A_008),
.REG_IN_A_009   (REG_IN_A_009),
.REG_IN_A_010   (REG_IN_A_010),
.REG_IN_A_011   (REG_IN_A_011),
.REG_IN_A_012   (REG_IN_A_012),
.REG_IN_A_013   (REG_IN_A_013),
.REG_IN_A_014   (REG_IN_A_014),
.REG_IN_A_015   (REG_IN_A_015),
.REG_IN_A_016   (REG_IN_A_016),
.REG_IN_A_017   (REG_IN_A_017),
.REG_IN_A_018   (REG_IN_A_018),
.REG_IN_A_019   (REG_IN_A_019),
.REG_IN_A_020   (REG_IN_A_020),
.REG_IN_A_021   (REG_IN_A_021),
.REG_IN_A_022   (REG_IN_A_022),
.REG_IN_A_023   (REG_IN_A_023),
.REG_IN_A_024   (REG_IN_A_024),
.REG_IN_A_025   (REG_IN_A_025),
.REG_IN_A_026   (REG_IN_A_026),
.REG_IN_A_027   (REG_IN_A_027),
.REG_IN_A_028   (REG_IN_A_028),
.REG_IN_A_029   (REG_IN_A_029),
.REG_IN_A_030   (REG_IN_A_030),
.REG_IN_A_031   (REG_IN_A_031),
.REG_IN_A_032   (REG_IN_A_032),
.REG_IN_A_033   (REG_IN_A_033),
.REG_IN_A_034   (REG_IN_A_034),
.REG_IN_A_035   (REG_IN_A_035),
.REG_IN_A_036   (REG_IN_A_036),
.REG_IN_A_037   (REG_IN_A_037),
.REG_IN_A_038   (REG_IN_A_038),
.REG_IN_A_039   (REG_IN_A_039),
.REG_IN_A_040   (REG_IN_A_040),
.REG_IN_A_041   (REG_IN_A_041),
.REG_IN_A_042   (REG_IN_A_042),
.REG_IN_A_043   (REG_IN_A_043),
.REG_IN_A_044   (REG_IN_A_044),
.REG_IN_A_045   (REG_IN_A_045),
.REG_IN_A_046   (REG_IN_A_046),
.REG_IN_A_047   (REG_IN_A_047),
.REG_IN_A_048   (REG_IN_A_048),
.REG_IN_A_049   (REG_IN_A_049),
.REG_IN_A_050   (REG_IN_A_050),
.REG_IN_A_051   (REG_IN_A_051),
.REG_IN_A_052   (REG_IN_A_052),
.REG_IN_A_053   (REG_IN_A_053),
.REG_IN_A_054   (REG_IN_A_054),
.REG_IN_A_055   (REG_IN_A_055),
.REG_IN_A_056   (REG_IN_A_056),
.REG_IN_A_057   (REG_IN_A_057),
.REG_IN_A_058   (REG_IN_A_058),
.REG_IN_A_059   (REG_IN_A_059),
.REG_IN_A_060   (REG_IN_A_060),
.REG_IN_A_061   (REG_IN_A_061),
.REG_IN_A_062   (REG_IN_A_062),
.REG_IN_A_063   (REG_IN_A_063),



.REG_IN_B_000   (REG_IN_B_000),
.REG_OUT_A_000  (REG_OUT_A_000),
.REG_OUT_B_000  (REG_OUT_B_000),
.rst_for_logmel(rst_for_logmel)
);

wire [1:0] logmel_di_en;
wire logmel_do_en;
// wire [(14*64)-1:0] logmel_data_o;

assign logmel_di_en = REG_IN_B_000[1:0];
assign logmel_do_en = REG_OUT_B_000[0];
assign REG_OUT_A_000 = logmel_data_o;

// 入力先のトップモジュール
log_mel_spectrogram # (
    .TOTAL_DATA(1024),
    .OUT_FRAMING_TOTAL_DATA(1024)
) logmel(
    .clk(clk_out),
    .rst(rst_for_logmel),
    .di_en(logmel_di_en),
    .data_i(REG_IN_A_000),
    .do_en(logmel_do_en),
    .data_o(logmel_data_o)
);

always @(posedge clk_out) begin
    if (logmel_do_en) begin
        // $display("logmel_data_o[100]=%d", logmel_data_o[100]);
    end
end


endmodule	//spi_logic


