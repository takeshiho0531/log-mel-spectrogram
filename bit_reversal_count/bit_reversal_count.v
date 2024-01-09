`timescale	1ns/1ns
module bit_reversal_count #(
    parameter GROUP_LEN = 1024
)(
    input [9:0] in_group_idx, // 0-1023
    output [9:0] out_group_idx // 0-1024
);

    wire [9:0] bit_reversal_count;

    assign bit_reversal_count[0] = in_group_idx[9];
    assign bit_reversal_count[1] = in_group_idx[8];
    assign bit_reversal_count[2] = in_group_idx[7];
    assign bit_reversal_count[3] = in_group_idx[6];
    assign bit_reversal_count[4] = in_group_idx[5];
    assign bit_reversal_count[5] = in_group_idx[4];
    assign bit_reversal_count[6] = in_group_idx[3];
    assign bit_reversal_count[7] = in_group_idx[2];
    assign bit_reversal_count[8] = in_group_idx[1];
    assign bit_reversal_count[9] = in_group_idx[0];

    assign out_group_idx = bit_reversal_count;

endmodule