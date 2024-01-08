`timescale	1ns/1ns
module bit_reversal_count #(
    parameter I_BW = 14,
    parameter O_BW = 14,
    parameter GROUP_LEN = 1024
)(
    input clk,
    input rst,
    input di_en,
    input signed [I_BW-1:0] data_i,
    input [6:0] in_group_num, // 0-88
    input [9:0] in_group_idx, // 0-1023
    output reg do_en,
    output reg signed [O_BW-1:0] data_o,
    output reg [6:0] out_group_num,
    output reg [9:0] out_group_idx // 0-1024
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


    always @(posedge clk or negedge rst) begin
        // $display("in_group_idx=%b, bit_reversal_count=%b", in_group_idx, bit_reversal_count);
        if (!rst) begin
            do_en <= 0;
        end
        else begin
            do_en <= di_en;
            data_o <= data_i;
            out_group_num <= in_group_num;
            out_group_idx <= bit_reversal_count;
        end
    end
endmodule