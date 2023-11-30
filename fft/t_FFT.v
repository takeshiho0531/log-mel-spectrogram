module t_FFT;
    reg clk, rst;
    // reg [13:0] out_han;
    // reg [13:0] di_im;
    reg valid_han;
    reg valid_fft;
    reg [13:0] re_out;
    reg [13:0] im_out;
    reg [9:0] out_num;
    reg [9:0] counter;

    assign di_im = 0;

    initial begin
        clk = 0; forever #50 clk = !clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0;
        #20 rst = 1;
    end

    always @(negedge rst or posedge clk)
        begin
            if (rst == 0) counter <= 0;
            else if (clk == 1) counter <= counter + 1;
        end

    initial
        $monitor($stime, "rst = %b, clk = %b, valid_han = %b, out_han = %d, di_im = %d, valid_fft = %b, re_out = %d, im_out = %d, out_num = %b",
            rst, clk, valid_han, out_han, di_im, valid_fft, re_out, im_out, out_num)



    FFT # (
        WIDTH = 14
    )
    fft_r22sdf(
        .clock(clk),
        .reset(rst),
        .di_en(valid_han),
        .di_re(out_han),
        .di_im(di_im),
        .do_en(valid_fft),
        .do_re(re_out),
        .do_im(im_out),
        .out_num(out_num)
    )
endmodule