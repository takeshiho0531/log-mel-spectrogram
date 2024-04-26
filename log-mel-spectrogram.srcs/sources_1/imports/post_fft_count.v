`timescale 1ns / 1ns
module post_fft_count #(
    parameter I_BW       = 14,
    parameter O_BW       = 14,
    parameter TOTAL_DATA = 91136
) (
    input clk_i,
    input rst_i,
    input en_i,
    input [I_BW-1:0] re_i,
    input [I_BW-1:0] im_i,
    output reg en_o,
    output reg [O_BW-1:0] re_o,
    output reg [O_BW-1:0] im_o,
    output [9:0] post_fft_count_o
);

  function [9:0] bit_reversaled;
    input [9:0] data_i;
    begin
      bit_reversaled[0] = data_i[9];
      bit_reversaled[1] = data_i[8];
      bit_reversaled[2] = data_i[7];
      bit_reversaled[3] = data_i[6];
      bit_reversaled[4] = data_i[5];
      bit_reversaled[5] = data_i[4];
      bit_reversaled[6] = data_i[3];
      bit_reversaled[7] = data_i[2];
      bit_reversaled[8] = data_i[1];
      bit_reversaled[9] = data_i[0];
    end
  endfunction

  integer count;
  assign post_fft_count_o = bit_reversaled((count - 1) % 1024);  // zero start

  always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
      count <= 0;
      en_o  <= 0;
      re_o  <= 0;
      im_o  <= 0;
    end else if (en_i) begin
      re_o  <= re_i;
      im_o  <= im_i;
      count <= count + 1;
      en_o  <= 1;
    end else begin
      re_o  <= re_i;
      im_o  <= im_i;
      count <= count;
      en_o  <= 0;
    end
  end
endmodule
