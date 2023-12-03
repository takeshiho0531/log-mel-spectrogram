module t_FFT;
    reg clk, rst;
    wire [13:0] out_han;
    wire [13:0] di_im;
    reg valid_han;
    wire valid_fft;
    wire [13:0] re_out;
    wire [13:0] im_out;
    wire [9:0] out_num;
    reg [9:0] counter;
    reg [13:0] data_i_mem[0:9];

    assign di_im = 0;
    assign out_han = data_i_mem[counter];

    initial
        $readmemb("indata1.dat", data_i_mem);

    initial begin
        clk = 0; forever #50 clk = !clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0; valid_han = 0;
        #20 rst = 1; valid_han = 1;
    end

    always @(negedge rst or posedge clk)
        begin
            if (rst == 0) counter <= 0;
            else if (clk == 1) counter <= counter + 1;
        end


    initial
        $monitor($stime, "rst = %b, clk = %b, valid_han = %b, out_han = %d, di_im = %d, valid_fft = %b, re_out = %d, im_out = %d, out_num = %b, counter = %d",
            rst, clk, valid_han, out_han, di_im, valid_fft, re_out, im_out, out_num, counter);



    FFT #(
        .WIDTH(14)
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
    );
endmodule