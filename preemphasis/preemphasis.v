module preemphasis #(
    parameter I_BW = 8,
    parameter O_BW = 9
)(
    input clk,
    input rst_n,
    input en_i, // what's this

    input signed [I_BW-1:0] data_i, // signed?
    input valid_i,

    oupput signed [O_BW-1:0] data_o,
    output valid_o
);
    localparam MUL = 31;
    localparam SHIFT = 5;

    reg signed [I_BW-1:0] data_q;
    always @(posedge clk) begin
        if (!rst_n | en_i) begin
            data_q <= 'd0;
        end else begin
            if (valid_i) begin
                data_q <= data_i;
            end else begin
                data_q <= data_q; // what's for?
            end
        end
    end
    wire signed [O_BW-1:0] data_scaled = (data_q * MUL) >>> SHIFT; // signed?

    assign valid_o = (en_i & valid_i);
    assign data_o = data_i - data_scaled;
endmodule