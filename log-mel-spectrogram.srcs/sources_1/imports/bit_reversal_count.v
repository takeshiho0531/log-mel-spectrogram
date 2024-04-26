`timescale 1ns / 1ns
module bit_reversal_count #(
    parameter GROUP_LEN = 1024
) (
    input  [9:0] group_idx_i,  // 0-1023
    output [9:0] group_idx_o   // 0-1024
);

  wire [9:0] bit_reversal_count;

  assign bit_reversal_count[0] = group_idx_i[9];
  assign bit_reversal_count[1] = group_idx_i[8];
  assign bit_reversal_count[2] = group_idx_i[7];
  assign bit_reversal_count[3] = group_idx_i[6];
  assign bit_reversal_count[4] = group_idx_i[5];
  assign bit_reversal_count[5] = group_idx_i[4];
  assign bit_reversal_count[6] = group_idx_i[3];
  assign bit_reversal_count[7] = group_idx_i[2];
  assign bit_reversal_count[8] = group_idx_i[1];
  assign bit_reversal_count[9] = group_idx_i[0];

  assign group_idx_o = bit_reversal_count;

endmodule
