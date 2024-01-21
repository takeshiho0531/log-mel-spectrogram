`timescale	1ns/1ns
module counter# (
    parameter I_BW         = 14,
    parameter O_BW         = 14,
    parameter TOTAL_DATA   = 15104
)(
    input clk,
    input rst,
    input di_en,
    input [I_BW-1:0] data_i,
    output reg do_en,
    output reg [O_BW-1:0] data_o,
    output [$clog2(TOTAL_DATA)-1:0] num
);

    integer count;
    assign num = count -1; // zero start

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            do_en <= 0;
            data_o <= 0;
        end
        else if (di_en) begin
            data_o <= data_i;
            count <= count+1;
            do_en <= 1;
        end 
    end
endmodule