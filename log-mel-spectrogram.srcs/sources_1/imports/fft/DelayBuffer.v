//----------------------------------------------------------------------
//  DelayBuffer: Generate Constant Delay
//----------------------------------------------------------------------
`timescale	1ns/1ns
module DelayBuffer #(
    parameter   DEPTH = 32,
    parameter   WIDTH = 14
)(
    input               clock,  //  Master Clock
    input   [WIDTH-1:0] di_re,  //  Data Input (Real)
    input   [WIDTH-1:0] di_im,  //  Data Input (Imag)
    output  [WIDTH-1:0] do_re,  //  Data Output (Real)
    output  [WIDTH-1:0] do_im   //  Data Output (Imag)
);

reg [WIDTH-1:0] buf_re[0:DEPTH-1];
reg [WIDTH-1:0] buf_im[0:DEPTH-1];
integer n;

//  Shift Buffer
always @(posedge clock) begin
    for (n = DEPTH-1; n > 0; n = n - 1) begin
        buf_re[n] <= buf_re[n-1];
        buf_im[n] <= buf_im[n-1];
    end
    buf_re[0] <= di_re;
    buf_im[0] <= di_im;
end

assign  do_re = buf_re[DEPTH-1];
assign  do_im = buf_im[DEPTH-1];

always @(posedge clock) begin
    // $display("DEPTH=%d, buf_re[0]=%d, buf_re[64]=%d, buf_re[128]=%d, buf_re[192]=%d, buf_re[256]=%d, buf_re[320]=%d, buf_re[384]=%d, buf_re[448]=%d, buf_re[511]=%d", DEPTH, buf_re[0], buf_re[64], buf_re[128], buf_re[192], buf_re[256], buf_re[320], buf_re[384], buf_re[448], buf_re[511]);
end

endmodule