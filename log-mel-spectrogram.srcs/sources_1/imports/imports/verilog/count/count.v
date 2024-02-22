`timescale	1ns/1ns
module counter# (
    parameter I_BW         = 14,
    parameter O_BW         = 14,
    parameter TOTAL_DATA   = 91136
)(
    input clk,
    input rst,
    input di_en,
    input [I_BW-1:0] di_re,
    input [I_BW-1:0] di_im,
    output reg do_en,
    output reg [O_BW-1:0] do_re,
    output reg [O_BW-1:0] do_im,
    output [$clog2(TOTAL_DATA)-1:0] num
);

    integer count;
    assign num = count -1; // zero start

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            do_en <= 0;
            do_re <= 0;
            do_im <= 0;
        end
        else if (di_en) begin
            do_re <= di_re;
            do_im <= di_im;
            count <= count+1;
            do_en <= 1;
        end
        else begin
            do_re <= di_re;
            do_im <= di_im;
            count <= count;
            do_en <= 0;
        end
    end
endmodule