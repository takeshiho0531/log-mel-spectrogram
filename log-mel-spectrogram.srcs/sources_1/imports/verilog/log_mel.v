`timescale	1ns/1ns
module log_mel_spectrogram #(
    parameter I_BW = 14,
    parameter O_BW = 14
)(
    input clk,
    input rst,
    input [1:0] di_en,
    input signed [I_BW-1:0] data_i,
    output reg do_en,
    output signed [O_BW-1:0] data_o
);
    localparam INPUT_COUNTER_O_BW = 14;
    localparam FRAMING_O_BW = 14;
    localparam TOTAL_DATA = 15104;
    localparam OUT_FRAMING_TOTAL_DATA = 91136;
    localparam HANN_WINDOW_O_BW = 14;
    localparam FRAME_LEN = 1024;


    wire signed [INPUT_COUNTER_O_BW-1:0] out_input_counter;
    wire [$clog2(TOTAL_DATA)-1:0] num;
    wire [1:0] input_counter_do_en;
    wire [($clog2(OUT_FRAMING_TOTAL_DATA)-1):0] framing_out_num;
    wire framing_do_en;
    wire signed [FRAMING_O_BW-1:0] out_framing;
    wire signed [HANN_WINDOW_O_BW-1:0] out_hann;
    wire hann_do_en;
    wire [($clog2(FRAME_LEN)-1):0] out_hann_group_idx;
    wire [$clog2(OUT_FRAMING_TOTAL_DATA/FRAME_LEN):0] out_hann_group_num;



    input_counter #(
        .I_BW(INPUT_COUNTER_O_BW),
        .O_BW(FRAMING_O_BW)
    )count(
        .clk(clk),
        .rst(rst),
        .di_en(di_en),
        .data_i(data_i),
        .do_en(input_counter_do_en),
        .data_o(out_input_counter),
        .num(num)
    );

    framing #(
        .TOTAL_DATA(TOTAL_DATA),
        .I_BW(INPUT_COUNTER_O_BW),
        .O_BW(FRAMING_O_BW)
    ) frame (
    .clk(clk),
    .rst(rst),
    .data_i(out_input_counter),
    .di_en(input_counter_do_en),
    .in_num(num),
    .data_o(out_framing),
    .do_en(framing_do_en),
    .out_num(framing_out_num)
    );

    hann_window #(
        .I_BW(FRAMING_O_BW),
        .O_BW(HANN_WINDOW_O_BW),
        .FRAME_LEN(FRAME_LEN),
        .TOTAL_DATA(OUT_FRAMING_TOTAL_DATA)
    )
    window(
        .clk(clk),
        .rst(rst),
        .data_i(out_framing),
        .in_num(framing_out_num),
        .di_en(framing_do_en),
        .data_o(out_hann),
        .do_en(hann_do_en),
        .out_group_idx(out_hann_group_idx),
        .out_group_num(out_hann_group_num)
    );

    localparam FFT_O_BW = 14;

    wire [1:0] fft_group;
    wire is_fft_group0;
    wire is_fft_group1;
    wire is_fft_group2;
    wire fft_group0_do_en;
    wire fft_group1_do_en;
    wire fft_group2_do_en;
    wire signed [HANN_WINDOW_O_BW-1:0] di_im;
    wire signed [FFT_O_BW-1:0] fft_group0_do_re;
    wire signed [FFT_O_BW-1:0] fft_group0_do_im;
    wire signed [FFT_O_BW-1:0] fft_group1_do_re;
    wire signed [FFT_O_BW-1:0] fft_group1_do_im;
    wire signed [FFT_O_BW-1:0] fft_group2_do_re;
    wire signed [FFT_O_BW-1:0] fft_group2_do_im;

    assign fft_group = out_hann_group_num%3;
    assign is_fft_group0 = hann_do_en & (fft_group==0);
    assign is_fft_group1 = hann_do_en & (fft_group==1);
    assign is_fft_group2 = hann_do_en & (fft_group==2);

    assign di_im = 0;

    FFT FFT0 (
        .clock	(clk),	//	i
        .reset	(rst),	//	i
        .di_en	(is_fft_group0),	//	i
        .di_re	(out_hann),	//	i
        .di_im	(di_im),	//	i
        .do_en	(fft_group0_do_en),	//	o
        .do_re	(fft_group0_do_re),	//	o
        .do_im	(fft_group0_do_im)	//	o
    );

    FFT FFT1 (
        .clock	(clk),	//	i
        .reset	(rst),	//	i
        .di_en	(is_fft_group1),	//	i
        .di_re	(out_hann),	//	i
        .di_im	(di_im),	//	i
        .do_en	(fft_group1_do_en),	//	o
        .do_re	(fft_group1_do_re),	//	o
        .do_im	(fft_group1_do_im)	//	o
    );

    FFT FFT2 (
        .clock	(clk),	//	i
        .reset	(rst),	//	i
        .di_en	(is_fft_group2),	//	i
        .di_re	(out_hann),	//	i
        .di_im	(di_im),	//	i
        .do_en	(fft_group2_do_en),	//	o
        .do_re	(fft_group2_do_re),	//	o
        .do_im	(fft_group2_do_im)	//	o
    );

    localparam COUNTER_O_BW = 14;
    wire counter0_do_en;
    wire counter1_do_en;
    wire counter2_do_en;
    wire signed [COUNTER_O_BW-1:0] counter0_do_re;
    wire signed [COUNTER_O_BW-1:0] counter0_do_im;
    wire signed [COUNTER_O_BW-1:0] counter1_do_re;
    wire signed [COUNTER_O_BW-1:0] counter1_do_im;
    wire signed [COUNTER_O_BW-1:0] counter2_do_re;
    wire signed [COUNTER_O_BW-1:0] counter2_do_im;
    wire [$clog2(OUT_FRAMING_TOTAL_DATA)-1:0] count0;
    wire [$clog2(OUT_FRAMING_TOTAL_DATA)-1:0] count1;
    wire [$clog2(OUT_FRAMING_TOTAL_DATA)-1:0] count2;

    counter #(
        .I_BW(FFT_O_BW),
        .O_BW(COUNTER_O_BW)
    ) counter0(
        .clk(clk),
        .rst(rst),
        .di_en(fft_group0_do_en),
        .di_re(fft_group0_do_re),
        .di_im(fft_group0_do_im),
        .do_en(counter0_do_en),
        .do_re(counter0_do_re),
        .do_im(counter0_do_im),
        .num(count0)
    );

    counter #(
        .I_BW(FFT_O_BW),
        .O_BW(COUNTER_O_BW)
    ) counter1(
        .clk(clk),
        .rst(rst),
        .di_en(fft_group1_do_en),
        .di_re(fft_group1_do_re),
        .di_im(fft_group1_do_im),
        .do_en(counter1_do_en),
        .do_re(counter1_do_re),
        .do_im(counter1_do_im),
        .num(count1)
    );

    counter #(
        .I_BW(FFT_O_BW),
        .O_BW(COUNTER_O_BW)
    ) counter2(
        .clk(clk),
        .rst(rst),
        .di_en(fft_group2_do_en),
        .di_re(fft_group2_do_re),
        .di_im(fft_group2_do_im),
        .do_en(counter2_do_en),
        .do_re(counter2_do_re),
        .do_im(counter2_do_im),
        .num(count2)
    );

    wire [6:0] bit_reversal_count0_group_num;
    wire [9:0] bit_reversal_count0_in_group_idx;
    wire [9:0] bit_reversal_count0_out_group_idx;
    wire [6:0] bit_reversal_count1_group_num;
    wire [9:0] bit_reversal_count1_in_group_idx;
    wire [9:0] bit_reversal_count1_out_group_idx;
    wire [6:0] bit_reversal_count2_group_num;
    wire [9:0] bit_reversal_count2_in_group_idx;
    wire [9:0] bit_reversal_count2_out_group_idx;


    assign bit_reversal_count0_group_num = count0 / 1024;
    assign bit_reversal_count0_in_group_idx = count0 % 1024;
    assign bit_reversal_count1_group_num = count1 / 1024;
    assign bit_reversal_count1_in_group_idx = count1 % 1024;
    assign bit_reversal_count2_group_num = count2 / 1024;
    assign bit_reversal_count2_in_group_idx = count2 % 1024;

    bit_reversal_count reverse0(
        .in_group_idx(bit_reversal_count0_in_group_idx),
        .out_group_idx(bit_reversal_count0_out_group_idx)
    );

    bit_reversal_count reverse1(
        .in_group_idx(bit_reversal_count1_in_group_idx),
        .out_group_idx(bit_reversal_count1_out_group_idx)
    );

    bit_reversal_count reverse2(
        .in_group_idx(bit_reversal_count2_in_group_idx),
        .out_group_idx(bit_reversal_count2_out_group_idx)
    );


    localparam SELECT_BUFFER_O_BW = 14;
    wire select_buffer0_do_en;
    wire select_buffer1_do_en;
    wire select_buffer2_do_en;
    wire [9:0] select_buffer0_out_group_idx;
    wire [6:0] select_buffer0_out_group_num;
    wire [9:0] select_buffer1_out_group_idx;
    wire [6:0] select_buffer1_out_group_num;
    wire [9:0] select_buffer2_out_group_idx;
    wire [6:0] select_buffer2_out_group_num;
    wire signed [SELECT_BUFFER_O_BW-1:0] select_buffer0_do_re;
    wire signed [SELECT_BUFFER_O_BW-1:0] select_buffer0_do_im;
    wire signed [SELECT_BUFFER_O_BW-1:0] select_buffer1_do_re;
    wire signed [SELECT_BUFFER_O_BW-1:0] select_buffer1_do_im;
    wire signed [SELECT_BUFFER_O_BW-1:0] select_buffer2_do_re;
    wire signed [SELECT_BUFFER_O_BW-1:0] select_buffer2_do_im;

    select_buffer #(
        .I_BW(FFT_O_BW),
        .O_BW(SELECT_BUFFER_O_BW)
    ) select_buffer0(
        .clk(clk),
        .rst(rst),
        .di_en(counter0_do_en),
        .di_re(counter0_do_re),
        .di_im(counter0_do_im),
        .in_group_idx(bit_reversal_count0_in_group_idx),
        .in_group_num(bit_reversal_count0_group_num),
        .do_en(select_buffer0_do_en),
        .do_re(select_buffer0_do_re),
        .do_im(select_buffer0_do_im),
        .out_group_idx(select_buffer0_out_group_idx),
        .out_group_num(select_buffer0_out_group_num)
    );

    select_buffer #(
        .I_BW(FFT_O_BW),
        .O_BW(SELECT_BUFFER_O_BW)
    ) select_buffer1(
        .clk(clk),
        .rst(rst),
        .di_en(counter1_do_en),
        .di_re(counter1_do_re),
        .di_im(counter1_do_re),
        .in_group_idx(bit_reversal_count1_in_group_idx),
        .in_group_num(bit_reversal_count1_group_num),
        .do_en(select_buffer1_do_en),
        .do_re(select_buffer1_do_re),
        .do_im(select_buffer1_do_im),
        .out_group_idx(select_buffer1_out_group_idx),
        .out_group_num(select_buffer1_out_group_num)
    );

    select_buffer #(
        .I_BW(FFT_O_BW),
        .O_BW(SELECT_BUFFER_O_BW)
    ) select_buffer2(
        .clk(clk),
        .rst(rst),
        .di_en(counter2_do_en),
        .di_re(counter2_do_re),
        .di_im(counter2_do_re),
        .in_group_idx(bit_reversal_count2_in_group_idx),
        .in_group_num(bit_reversal_count2_group_num),
        .do_en(select_buffer2_do_en),
        .do_re(select_buffer2_do_re),
        .do_im(select_buffer2_do_im),
        .out_group_idx(select_buffer2_out_group_idx),
        .out_group_num(select_buffer2_out_group_num)
    );

    localparam SQUARED_O_BW = 27;
    wire signed [SQUARED_O_BW-1:0] out_squared0;
    wire signed [SQUARED_O_BW-1:0] out_squared1;
    wire signed [SQUARED_O_BW-1:0] out_squared2;

    squared #(
       .I_BW(FFT_O_BW),
       .O_BW(SQUARED_O_BW)
    ) power0(
        .di_re(select_buffer0_do_re),
        .di_im(select_buffer0_do_im),
        .data_o(out_squared0)
    );

    squared #(
       .I_BW(FFT_O_BW),
       .O_BW(SQUARED_O_BW)
    ) power1(
        .di_re(select_buffer1_do_re),
        .di_im(select_buffer1_do_im),
        .data_o(out_squared1)
    );

    squared #(
       .I_BW(FFT_O_BW),
       .O_BW(SQUARED_O_BW)
    ) power2(
        .di_re(select_buffer2_do_re),
        .di_im(select_buffer2_do_im),
        .data_o(out_squared2)
    );

    localparam MEL_O_BW = 30;

    wire signed [MEL_O_BW*64-1:0] out_mel0;
    wire signed [MEL_O_BW*64-1:0] out_mel1;
    wire signed [MEL_O_BW*64-1:0] out_mel2;
    wire [6:0] out_mel0_group_num;  // 0-88
    wire [6:0] out_mel1_group_num;  // 0-88
    wire [6:0] out_mel2_group_num;  // 0-88

    wire mel0_do_en;
    wire mel1_do_en;
    wire mel2_do_en;
    wire is_mel0_first_in;
    wire is_mel0_last_in;
    wire is_mel1_first_in;
    wire is_mel1_last_in;
    wire is_mel2_first_in;
    wire is_mel2_last_in;

    assign is_mel0_first_in = (select_buffer0_out_group_idx % 513 == 0);
    assign is_mel0_last_in = (select_buffer0_out_group_idx % 513 == 512);
    assign is_mel1_first_in = (select_buffer1_out_group_idx % 513 == 0);
    assign is_mel1_last_in = (select_buffer1_out_group_idx % 513 == 512);
    assign is_mel2_first_in = (select_buffer2_out_group_idx % 513 == 0);
    assign is_mel2_last_in = (select_buffer2_out_group_idx % 513 == 512);

    mel_filter #(
       .I_BW(SQUARED_O_BW),
       .O_BW(MEL_O_BW)
    ) mel0(
        .clk(clk),
        .rst(rst),
        .in_group_idx(select_buffer0_out_group_idx), // 0-512 // 
        .in_group_num(select_buffer0_out_group_num), // 0-88 //
        .data_i(out_squared0),
        .di_en(squared0_do_en),
        .is_first_in(is_mel0_first_in), // squared
        .is_last_in(is_mel0_last_in), // squared
        .data_o(out_mel0),
        .do_en(mel0_do_en),
        .out_group_num(out_mel0_group_num)
    );

    mel_filter #(
       .I_BW(SQUARED_O_BW),
       .O_BW(MEL_O_BW)
    ) mel1(
        .clk(clk),
        .rst(rst),
        .in_group_idx(select_buffer1_out_group_idx), // 0-512 // 
        .in_group_num(select_buffer1_out_group_num), // 0-88 //
        .data_i(out_squared1),
        .di_en(squared1_do_en),
        .is_first_in(is_mel1_first_in), // squared
        .is_last_in(is_mel1_last_in), // squared
        .data_o(out_mel1),
        .do_en(mel1_do_en),
        .out_group_num(out_mel1_group_num)
    );

    mel_filter #(
       .I_BW(SQUARED_O_BW),
       .O_BW(MEL_O_BW)
    ) mel2(
        .clk(clk),
        .rst(rst),
        .in_group_idx(select_buffer2_out_group_idx), // 0-512 //
        .in_group_num(select_buffer2_out_group_num), // 0-88 //
        .data_i(out_squared2),
        .di_en(squared2_do_en),
        .is_first_in(is_mel2_first_in),
        .is_last_in(is_mel2_first_in),
        .data_o(out_mel2),
        .do_en(mel2_do_en),
        .out_group_num(out_mel2_group_num)
    );

endmodule