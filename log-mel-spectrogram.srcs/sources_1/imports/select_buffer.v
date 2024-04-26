`timescale 1ns / 1ns
module select_buffer #(
    parameter I_BW = 14,
    parameter O_BW = 14
) (
    input clk_i,
    input rst_i,
    input en_i,
    input signed [I_BW-1:0] re_i,
    input signed [I_BW-1:0] im_i,
    input [9:0] group_idx_i,  // 0-1023
    input [6:0] group_num_i,  // 0-88
    output reg en_o,
    output reg signed [O_BW-1:0] re_o,
    output reg signed [O_BW-1:0] im_o,
    output reg [9:0] group_idx_o,  // 0-512
    output reg [6:0] group_num_o
);
  always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
      en_o <= 0;
      re_o <= 0;
      im_o <= 0;
      group_idx_o <= 0;
      group_num_o <= 0;
    end else if (en_i & group_idx_i <= 512) begin
      en_o <= en_i;
      re_o <= re_i;
      im_o <= im_i;
      group_idx_o <= group_idx_i;
      group_num_o <= group_num_o;
    end else begin
      en_o <= 0;
      re_o <= re_i;
      im_o <= im_i;
      group_idx_o <= group_idx_i;
      group_num_o <= group_num_i;
    end
  end
endmodule
