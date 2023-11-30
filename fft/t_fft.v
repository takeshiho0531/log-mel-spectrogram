module t_fft;
    reg clk, rst;
    reg [11:0] din_meta;
    reg [10:0] zero;
    reg [10:0] meta;
    reg [] out_ham; //
    reg [] d_im; //
    reg [] valid_ham; //
    reg [] re_out; //
    reg [] in_out; //
    reg [] valid_fft; //
    reg [] fft_out_num; //

    initial
        $readmemb("indata1.dat", data_i_mem); //

    initial begin
        clk = 0; forever #50 clk = !clk;
    end

    initial
        $monitor();

    fft # (
    .N_LOG2(10),
    .TF_WDTH(10),
    .DIN_WDTH(32),
    .META_WDTH(11),
    .DOUT_WDTH(40)
    )
    fft_r22sdf(
    .clk(clk),
    .rst_n(rst),
    .din_meta(zero),
    .dout_meta(meta),
    .din_re(out_ham),
    .din_im(im),
    .din_nd(valid_ham),
    .dout_re(re_out),
    .dout_im(im_out),
    .dout_nd(valid_fft),
    .out_num(fft_out_num)
    )

endmodule