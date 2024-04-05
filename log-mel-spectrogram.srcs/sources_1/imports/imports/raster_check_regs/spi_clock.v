`timescale 1ns / 1ps

module spi_clock(
// spi_clk_in,  // 外部からのSPIクロック入力
sys_clk_i,
clk_i,
transfer_enable_flag_i,        // クロックを制御するフラグ
clk_o,
selected_sys_clk_o
);

// input			spi_clk_in;
input			clk_i;
input           sys_clk_i;
input			transfer_enable_flag_i;
output wire		clk_o;
output wire    selected_sys_clk_o;

assign clk_o = (transfer_enable_flag_i == 1'b1) ? clk_i : 1'b0;
assign selected_sys_clk_o = (transfer_enable_flag_i == 1'b1) ? clk_i : sys_clk_i;
endmodule


