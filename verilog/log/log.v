`timescale	1ns/1ns
module log #(
    parameter I_BW = 14,
    parameter O_BW = 14
)(
    input clk,
    input rst,
    input signed [I_BW-1:0] data_i,
    input [5:0] in_group_idx, // 0-63
    input [6:0] in_group_num, // 0-88
    input di_en,
    input is_first_in,
    input is_last_in,
    output reg signed [O_BW-1:0] data_o,
    output reg [5:0] out_group_idx,
    output reg [6:0] out_group_num,
    output reg do_en,
    output reg is_first_out,
    output reg is_last_out
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
                    data_o = logb2 * 5/7;
                    do_en <= di_en;
                    out_group_idx <= in_group_idx;
                    out_group_num <= in_group_num;
                    $display("out_group_idx=%d, di_en=%b, data_i=%d, tmp_data_i=%d, logb2=%d, data_o=%d, do_en=%b", out_group_idx, di_en, data_i, tmp_data_i, logb2, data_o, do_en);
                end
                // $display("data_i=%d, tmp_data_i=%d, logb2=%d", data_i, tmp_data_i, logb2);
            end
            // $display("data_i=%d, tmp_data_i=%d, logb2=%d", data_i, tmp_data_i, logb2);
            // data_o <= logb2*2/3; // this may underestimate
            // data_o <= logb2 * 5/7;
            // do_en <= di_en;
            // out_group_idx <= in_group_idx;
            // out_group_num <= in_group_num;
            // $display("out_group_idx=%d, di_en=%b, data_i=%d, tmp_data_i=%d, logb2=%d, data_o=%d, do_en=%b", out_group_idx, di_en, data_i, tmp_data_i, logb2, data_o, do_en);
        end
    end
endmodule