`timescale	1ns/1ns
module squared #(
    parameter I_BW=14,
    parameter O_BW=27 // (14-1-1)*2+1+1, 1桁多かった
)(
    input signed [I_BW-1:0] di_re,
    input signed [I_BW-1:0] di_im,
    output signed [O_BW-1:0] data_o
);
    assign data_o = di_re * di_re + di_im * di_im;

endmodule