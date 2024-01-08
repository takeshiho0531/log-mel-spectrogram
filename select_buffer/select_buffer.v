`timescale	1ns/1ns
module select_buffer # (
    parameter I_BW = 14,
    parameter O_BW = 14
)(
    input clk,
    input rst,
    input di_en,
    input signed [I_BW-1:0] di_re,
    input signed [I_BW-1:0] di_im,
    input [9:0] in_group_idx, // 0-1023
    input [6:0] in_group_num, // 0-88
    output reg do_en,
    output reg signed [O_BW-1:0] do_re,
    output reg signed [O_BW-1:0] do_im,
    output reg [9:0] out_group_idx, // 0-512
    output reg [6:0] out_group_num
);
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_en <= 0;
            do_re <= 0;
            do_im <= 0;
            out_group_idx <= 0;
            out_group_num <= 0;
        end
        else if (di_en & in_group_num <+ 512) begin
            do_en <= di_en;
            do_re <= di_re;
            do_im <= di_im;
            out_group_idx <= in_group_idx;
            out_group_num <= out_group_num;
        end else begin
            do_en <= 0;
            do_re <= di_re;
            do_im <= di_im;
            out_group_idx <= in_group_idx;
            out_group_num <= in_group_num;
        end
    end
endmodule