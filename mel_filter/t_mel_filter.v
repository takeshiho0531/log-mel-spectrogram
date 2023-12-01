module t_mel_filter;
    reg clk, rst;
    reg [13:0] re_outs[1024];
    wire [13:0] re_out;
    reg [13:0] im_outs[1024];
    wire [13:0] im_out;
    wire valid_fft;
    reg [9:0] out_nums[1024];
    wire [9:0] out_num;
    wire [469:0] mel_out;
    wire valid_mel;
    reg [9:0] mel_out_num;
    reg [9:0] counter;

    initial begin
        $readmemb("indata_re.dat", re_outs);
        $readmemb("indata_im.dat", im_outs);
        $readmemb("indata_out_nums", out_nums);
    end

    initial begin
        rst = 1;
        #10 rst = 0; valid_fft = 0;
        #20 rst = 1; valid_fft = 0;
        #10 rst = 1; valid_fft = 1;
    end

    always @(negedge rst_n or posedge clk) begin
        if (rst_n == 0) counter <= 0;// ???
        else if (clk == 1) begin
            counter <= counter + 1;
        end
    end

    assign re_out = re_outs[counter];
    assign im_out = im_outs[counter];
    assign out_num = out_nums[counter];

    mel_filter mel_filter_test(
        .clk(clk),
        .rst_n(rst),
        .in_re(re_out),
        .in_im(im_out),
        .in_valid(valid_fft),
        .in_num(fft_out_num),
        .out(mel_out),
        .out_valid(valid_mel),
        .out_num(mel_out_num)
    )


endmodule