`timescale 1ns / 1ns
module counter #(
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
    output [$clog2(TOTAL_DATA)-1:0] num_o
);

  integer count;
  assign num_o = count - 1;  // zero start

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
