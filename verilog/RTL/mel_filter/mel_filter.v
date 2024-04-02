`timescale	1ns/1ns
module mel_filter # (
    parameter I_BW = 14, // 2乗は別のモジュール
    parameter O_BW = 14,
    parameter COEF_BW = 14
)(
    input clk,
    input rst,
    input [9:0] in_group_idx, // 0-512
    input signed [I_BW-1:0] data_i,
    input [6:0] in_group_num, // 0-88
    input di_en,
    input is_first_in,
    input is_last_in,
    output reg signed [O_BW*64-1:0] data_o,
    output reg do_en,
    output reg [6:0] out_group_num // 0-88
);
    wire [9:0] filter_v; // 0-512

    wire is_first_out;
    wire is_last_out;

    wire [9:0] out_filter_v;
    wire [6:0] coef_out_group_idx;
    wire coef_en;
    wire signed [O_BW*64-1:0] coef;
    wire signed [O_BW-1:0] coef_data_o;
    reg signed [COEF_BW-1:0] coef_i;
    reg signed [O_BW+COEF_BW-1:0] tmp;
    reg signed [O_BW-1:0] tmp_shifted;
    reg signed [O_BW-1:0] data_o_i;
    integer i;
    integer j;
    integer k;
    integer l;

    assign filter_v = in_group_idx;
    assign coef_out_group_idx = out_filter_v;

    mel_filter_coef mel(
        .clk(clk),
        .rst(rst),
        .filter_v(filter_v), // 0-512
        .data_i(data_i),
        .di_en(di_en),
        .is_first_in(is_first_in),
        .is_last_in(is_last_in),
        .coef(coef),
        .do_en(coef_en),
        .out_filter_v(out_filter_v),
        .data_o(coef_data_o),
        .is_first_out(is_first_out),
        .is_last_out(is_last_out)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_en <= 0;
            data_o <= 0;
        end
        else begin
            // $display("coef_en=%b", coef_en);
            if (coef_en) begin
                // $display("coef=%b", coef);
                if (is_first_out) begin
                    data_o <= 0;
                end
                for (i=0; i<64; i=i+1) begin
                    for (j=0; j<O_BW; j=j+1) begin
                        coef_i[j]=coef[(63-i)*O_BW+j];
                    end
                    
                    tmp = coef_i*coef_data_o;
                    tmp_shifted = tmp >>> 13;

                    for (k=0; k<O_BW; k=k+1) begin
                        data_o_i[k] = data_o[(63-i)*O_BW+k];
                    end

                    // $display("1: out_filter_v=%d, i=%d, coef_i=%d, data_o_i=%d, tmp_shifted=%d", out_filter_v, i, coef_i, data_o_i, tmp_shifted);

                    data_o_i = data_o_i + tmp_shifted; // may overflow
                    
                    $display("2: out_filter_v=%d, i=%d, coef_i=%d, data_o_i=%d, tmp_shifted=%d", out_filter_v, i, coef_i, data_o_i, tmp_shifted);

                    for (l=0; l<O_BW; l=l+1) begin
                        data_o[(63-i)*O_BW+l] = data_o_i[l];
                    end

                    data_o_i = 0;
                end

                if (is_last_out) begin // because of bit-reverse(FFT)
                    do_en <= 1;
                    out_group_num <= in_group_num;
                end else begin
                    do_en <= 0;
                end
            end
        end
    end


endmodule