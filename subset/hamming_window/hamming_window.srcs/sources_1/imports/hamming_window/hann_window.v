`timescale	1ns/1ns
module hann_window # (
    parameter I_BW = 14,
    parameter O_BW = 14,
    parameter FRAME_LEN = 1024,
    parameter TOTAL_DATA = 91136
)(
    input clk,
    input rst,
    input signed [I_BW - 1 : 0] data_i,
    input [($clog2(TOTAL_DATA)-1):0] in_num,
    input di_en,
    output reg do_en,
    output reg [($clog2(FRAME_LEN)-1):0] out_group_idx,
    output reg [$clog2(TOTAL_DATA/FRAME_LEN):0] out_group_num,
    output reg signed [O_BW-1:0] data_o
);
    wire [($clog2(FRAME_LEN)-1):0] window_num;
    wire signed [13:0] window_coef;
    wire signed [13+O_BW-1:0] windowed;
    wire signed [O_BW-1:0] scaled_windowed;

    wire [$clog2(TOTAL_DATA/FRAME_LEN):0] group_num;

    assign window_num = in_num % 1024;
    assign group_num = in_num / 1024;

    hann_window_rom h0(
    .window_num(window_num),
    .window_coef(window_coef)
    );

    assign windowed = window_coef * data_i;
    assign scaled_windowed = windowed >>> 13;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_en <= 0;   
            data_o <= 0;
            out_group_idx <= 0;
            out_group_num <= 0;        
        end
        else if (di_en) begin
            do_en <= di_en;
            data_o <= scaled_windowed;
            out_group_idx <= window_num;
            out_group_num <= group_num;
        end
        else begin
            do_en <= 0;
            data_o <= scaled_windowed;
            out_group_idx <= window_num;
            out_group_num <= group_num;
        end
    end

endmodule