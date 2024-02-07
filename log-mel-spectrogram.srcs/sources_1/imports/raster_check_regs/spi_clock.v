`timescale 1ns / 1ps

module spi_clock(
// spi_clk_in,  // 外部からのSPIクロック入力
sys_clk_in,
clk_in,
transfer_enable_flag,        // クロックを制御するフラグ
clk_out,
selected_sys_clk
);

// input			spi_clk_in;
input			clk_in;
input           sys_clk_in;
input			transfer_enable_flag;
output wire		clk_out;
output wire    selected_sys_clk;

assign clk_out = (transfer_enable_flag == 1'b1) ? clk_in : 1'b0;
assign selected_sys_clk = (transfer_enable_flag == 1'b1) ? clk_in : sys_clk_in;
endmodule


