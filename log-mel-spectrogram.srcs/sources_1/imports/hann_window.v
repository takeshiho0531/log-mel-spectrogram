`timescale 1ns / 1ns
module hann_window #(
    parameter I_BW = 14,
    parameter O_BW = 14,
    parameter FRAME_LEN = 1024,
    parameter TOTAL_DATA = 91136
) (
    input clk_i,
    input rst_i,
    input signed [I_BW - 1 : 0] data_i,
    input [($clog2(TOTAL_DATA)-1):0] num_i,
    input en_i,
    output reg en_o,
    output reg [($clog2(FRAME_LEN)-1):0] group_idx_o,
    output reg [$clog2(TOTAL_DATA/FRAME_LEN):0] group_num_o,
    output reg signed [O_BW-1:0] data_o
);
  wire [($clog2(FRAME_LEN)-1):0] win_num;
  wire signed [13:0] win_coef;
  wire signed [13+O_BW:0] windowed;
  wire signed [O_BW:0] scaled_windowed;

  wire [$clog2(TOTAL_DATA/FRAME_LEN):0] group_num;

  assign win_num   = num_i % 1024;
  assign group_num = num_i / 1024;

  hann_window_rom h0 (
      .win_num_i (win_num),
      .win_coef_o(win_coef)
  );

  assign windowed = win_coef * data_i;
  assign scaled_windowed = windowed >>> 13;

  always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
      en_o <= 0;
      data_o <= 14'b00000000000000;
      group_idx_o <= 0;
      group_num_o <= 0;
    end else if (en_i) begin
      en_o <= en_i;
      data_o <= scaled_windowed;
      group_idx_o <= win_num;
      group_num_o <= group_num;
    end else begin
      en_o <= 0;
      data_o <= data_o;
      group_idx_o <= win_num;
      group_num_o <= group_num;
    end
  end

endmodule
