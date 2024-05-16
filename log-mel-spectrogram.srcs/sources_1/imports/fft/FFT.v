//----------------------------------------------------------------------
//  FFT: 1024-Point FFT Using Radix-2^2 Single-Path Delay Feedback
//----------------------------------------------------------------------
`timescale 1ns / 1ns
module FFT #(
    parameter WIDTH = 14
) (
    input              clk_i,  //  Master Clock
    input              rst_i,  //  Active High Asynchronous Reset
    input              en_i,   //  Input Data Enable
    input  [WIDTH-1:0] re_i,   //  Input Data (Real)
    input  [WIDTH-1:0] im_i,   //  Input Data (Imag)
    output             en_o,   //  Output Data Enable
    output [WIDTH-1:0] re_o,   //  Output Data (Real)
    output [WIDTH-1:0] im_o    //  Output Data (Imag)
);
  //----------------------------------------------------------------------
  //  Data must be input consecutively in natural order.
  //  The result is scaled to 1/N and output in bit-reversed order.
  //----------------------------------------------------------------------

  wire             su1_do_en;
  wire [WIDTH-1:0] su1_do_re;
  wire [WIDTH-1:0] su1_do_im;
  wire             su2_do_en;
  wire [WIDTH-1:0] su2_do_re;
  wire [WIDTH-1:0] su2_do_im;
  wire             su3_do_en;
  wire [WIDTH-1:0] su3_do_re;
  wire [WIDTH-1:0] su3_do_im;
  wire             su4_do_en;
  wire [WIDTH-1:0] su4_do_re;
  wire [WIDTH-1:0] su4_do_im;

  SdfUnit #(
      .N(1024),
      .M(1024),
      .WIDTH(WIDTH)
  ) SU1 (
      .clock(clk_i),      //  i
      .reset(rst_i),      //  i
      .di_en(en_i),       //  i
      .di_re(re_i),       //  i
      .di_im(im_i),       //  i
      .do_en(su1_do_en),  //  o
      .do_re(su1_do_re),  //  o
      .do_im(su1_do_im)   //  o
  );

  SdfUnit #(
      .N(1024),
      .M(256),
      .WIDTH(WIDTH)
  ) SU2 (
      .clock(clk_i),      //  i
      .reset(rst_i),      //  i
      .di_en(su1_do_en),  //  i
      .di_re(su1_do_re),  //  i
      .di_im(su1_do_im),  //  i
      .do_en(su2_do_en),  //  o
      .do_re(su2_do_re),  //  o
      .do_im(su2_do_im)   //  o
  );

  SdfUnit #(
      .N(1024),
      .M(64),
      .WIDTH(WIDTH)
  ) SU3 (
      .clock(clk_i),      //  i
      .reset(rst_i),      //  i
      .di_en(su2_do_en),  //  i
      .di_re(su2_do_re),  //  i
      .di_im(su2_do_im),  //  i
      .do_en(su3_do_en),  //  o
      .do_re(su3_do_re),  //  o
      .do_im(su3_do_im)   //  o
  );

  SdfUnit #(
      .N(1024),
      .M(16),
      .WIDTH(WIDTH)
  ) SU4 (
      .clock(clk_i),      //  i
      .reset(rst_i),      //  i
      .di_en(su3_do_en),  //  i
      .di_re(su3_do_re),  //  i
      .di_im(su3_do_im),  //  i
      .do_en(su4_do_en),  //  o
      .do_re(su4_do_re),  //  o
      .do_im(su4_do_im)   //  o
  );

  SdfUnit #(
      .N(1024),
      .M(4),
      .WIDTH(WIDTH)
  ) SU5 (
      .clock(clk_i),      //  i
      .reset(rst_i),      //  i
      .di_en(su4_do_en),  //  i
      .di_re(su4_do_re),  //  i
      .di_im(su4_do_im),  //  i
      .do_en(en_o),       //  o
      .do_re(re_o),       //  o
      .do_im(im_o)        //  o
  );

endmodule
