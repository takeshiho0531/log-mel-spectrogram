`timescale	1ns/1ns
module log #(
    parameter I_BW = 30;
    parameter O_BW = 14;
    parameter SHIFT = 10;
)(
    input clk,
    input rst,
    input signed [I_BW*64-1:0] data_i,
    input [6:0] in_group_num, // 0-88
    input di_en,
    output reg signed [O_BW-1:0] data_o,
    output reg [5:0] out_group_idx,
    output reg [6:0] out_group_num,
    output reg do_en
);
    reg signed [I_BW-1:0] buffer[64];

    assign buffer[0] = data_i[1*I_BW-1:0*I_BW]
    assign buffer[1] = data_i[2*I_BW-1:1*I_BW]
    assign buffer[2] = data_i[3*I_BW-1:2*I_BW]
    assign buffer[3] = data_i[4*I_BW-1:3*I_BW]
    assign buffer[4] = data_i[5*I_BW-1:4*I_BW]
    assign buffer[5] = data_i[6*I_BW-1:5*I_BW]
    assign buffer[6] = data_i[7*I_BW-1:6*I_BW]
    assign buffer[7] = data_i[8*I_BW-1:7*I_BW]
    assign buffer[8] = data_i[9*I_BW-1:8*I_BW]
    assign buffer[9] = data_i[10*I_BW-1:9*I_BW]
    assign buffer[10] = data_i[11*I_BW-1:10*I_BW]
    assign buffer[11] = data_i[12*I_BW-1:11*I_BW]
    assign buffer[12] = data_i[13*I_BW-1:12*I_BW]
    assign buffer[13] = data_i[14*I_BW-1:13*I_BW]
    assign buffer[14] = data_i[15*I_BW-1:14*I_BW]
    assign buffer[15] = data_i[16*I_BW-1:15*I_BW]
    assign buffer[16] = data_i[17*I_BW-1:16*I_BW]
    assign buffer[17] = data_i[18*I_BW-1:17*I_BW]
    assign buffer[18] = data_i[19*I_BW-1:18*I_BW]
    assign buffer[19] = data_i[20*I_BW-1:19*I_BW]
    assign buffer[20] = data_i[21*I_BW-1:20*I_BW]
    assign buffer[21] = data_i[22*I_BW-1:21*I_BW]
    assign buffer[22] = data_i[23*I_BW-1:22*I_BW]
    assign buffer[23] = data_i[24*I_BW-1:23*I_BW]
    assign buffer[24] = data_i[25*I_BW-1:24*I_BW]
    assign buffer[25] = data_i[26*I_BW-1:25*I_BW]
    assign buffer[26] = data_i[27*I_BW-1:26*I_BW]
    assign buffer[27] = data_i[28*I_BW-1:27*I_BW]
    assign buffer[28] = data_i[29*I_BW-1:28*I_BW]
    assign buffer[29] = data_i[30*I_BW-1:29*I_BW]
    assign buffer[30] = data_i[31*I_BW-1:30*I_BW]
    assign buffer[31] = data_i[32*I_BW-1:31*I_BW]
    assign buffer[32] = data_i[33*I_BW-1:32*I_BW]
    assign buffer[33] = data_i[34*I_BW-1:33*I_BW]
    assign buffer[34] = data_i[35*I_BW-1:34*I_BW]
    assign buffer[35] = data_i[36*I_BW-1:35*I_BW]
    assign buffer[36] = data_i[37*I_BW-1:36*I_BW]
    assign buffer[37] = data_i[38*I_BW-1:37*I_BW]
    assign buffer[38] = data_i[39*I_BW-1:38*I_BW]
    assign buffer[39] = data_i[40*I_BW-1:39*I_BW]
    assign buffer[40] = data_i[41*I_BW-1:40*I_BW]
    assign buffer[41] = data_i[42*I_BW-1:41*I_BW]
    assign buffer[42] = data_i[43*I_BW-1:42*I_BW]
    assign buffer[43] = data_i[44*I_BW-1:43*I_BW]
    assign buffer[44] = data_i[45*I_BW-1:44*I_BW]
    assign buffer[45] = data_i[46*I_BW-1:45*I_BW]
    assign buffer[46] = data_i[47*I_BW-1:46*I_BW]
    assign buffer[47] = data_i[48*I_BW-1:47*I_BW]
    assign buffer[48] = data_i[49*I_BW-1:48*I_BW]
    assign buffer[49] = data_i[50*I_BW-1:49*I_BW]
    assign buffer[50] = data_i[51*I_BW-1:50*I_BW]
    assign buffer[51] = data_i[52*I_BW-1:51*I_BW]
    assign buffer[52] = data_i[53*I_BW-1:52*I_BW]
    assign buffer[53] = data_i[54*I_BW-1:53*I_BW]
    assign buffer[54] = data_i[55*I_BW-1:54*I_BW]
    assign buffer[55] = data_i[56*I_BW-1:55*I_BW]
    assign buffer[56] = data_i[57*I_BW-1:56*I_BW]
    assign buffer[57] = data_i[58*I_BW-1:57*I_BW]
    assign buffer[58] = data_i[59*I_BW-1:58*I_BW]
    assign buffer[59] = data_i[60*I_BW-1:59*I_BW]
    assign buffer[60] = data_i[61*I_BW-1:60*I_BW]
    assign buffer[61] = data_i[62*I_BW-1:61*I_BW]
    assign buffer[62] = data_i[63*I_BW-1:62*I_BW]
    assign buffer[63] = data_i[64*I_BW-1:63*I_BW]

    function [O_BW-1:0] logE;
        input [I_BW-1:0] antilogarithm;
        integer logb2;
        integer value;
        begin
            value = antilogarithm-1;
            for (logb2=0; value>0; logb2= logb2+1)
                value = value >>> 1;
            logE = (logb2+SHIFT) * 5/7;
        end
    endfunction

endmodule






module log_partial #(
    parameter I_BW = 30,
    parameter O_BW = 14,
    parameter SHIFT = 10
)(
    input clk,
    input rst,
    input signed [I_BW-1:0] data_i,
    input [5:0] in_group_idx, // 0-63
    input [6:0] in_group_num, // 0-88
    input di_en,
    output reg signed [O_BW-1:0] data_o,
    output reg [5:0] out_group_idx,
    output reg [6:0] out_group_num,
    output reg do_en
);
    reg signed [O_BW-1:0] logb2;
    reg signed [I_BW-1:0] tmp_data_i;
    integer i;

    // assign data_o = logb2 * 5/7;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_en <= 0;
            tmp_data_i <= 0;
        end
        else begin
            logb2 <= 0;
            data_o <= 0;
            tmp_data_i <= data_i;
            for (i=0; i<$clog2(I_BW); i=i+1) begin
                if ((tmp_data_i/2) > 0) begin
                    logb2 = logb2+1;
                    tmp_data_i = tmp_data_i/2;
                end
                else begin
                    // logb2 = logb2;
                    data_o = (logb2 + SHIFT) * 5/7;
                    do_en <= di_en;
                    out_group_idx <= in_group_idx;
                    out_group_num <= in_group_num;
                end
            end

        end
    end
endmodule