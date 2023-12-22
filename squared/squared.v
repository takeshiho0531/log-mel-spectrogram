`timescale	1ns/1ns

module squared #(
    parameter I_BW=14,
    parameter O_BW=14
)(
    input clk,
    input rst,
    input di_en,
    input signed [I_BW-1:0] data_i,
    input [9:0] in_group_idx, // 0-512
    input [6:0] in_group_num, // 0-88
    input is_first_in,
    input is_last_in,
    output reg do_en,
    output reg signed [O_BW-1:0] data_o,
    output reg [9:0] out_group_idx,
    output reg [6:0] out_group_num,
    output reg is_first_out,
    output reg is_last_out
);
    wire signed [2*I_BW-1:0] tmp_multiplied;
    wire signed [I_BW-1:0] multiplied;
    
    assign tmp_multiplied = data_i * data_i;
    assign multiplied = tmp_multiplied >>> 5; // may overflow // because of signed 14bit fixed-point number

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_en <= 0;
            data_o <= 0;
            out_group_idx <= 0;
            out_group_num <= 0;
            is_first_out <= 0;
            is_last_out <= 0;
        end
        else if (di_en) begin
            do_en <= di_en;
            data_o <= multiplied;
            out_group_idx <= in_group_idx;
            out_group_num <= in_group_num;
            is_first_out <= is_first_in;
            is_last_out <= is_first_out;
        end else begin
            do_en <= 0;
        end
    end

    always @(posedge clk) begin
        $display("in_group_idx=%d, di_en=%b, is_first_in=%b, is_last_in=%b, data_i=%b, out_group_idx=%d, do_en=%b, is_first_out=%b, is_last_out=%b, data_o=%b", in_group_idx, di_en, is_first_in, is_last_in, data_i, out_group_idx, do_en, is_first_out, is_last_out, data_o);
    end
endmodule