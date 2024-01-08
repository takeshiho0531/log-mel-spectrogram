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
    wire [$clog2(OUT_FRAMING_TOTAL_DATA/FRAME_LEN):0] out_hann__group_num;



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
        .di_en(fft_group0_do_en),
        .di_re(fft_group0_do_re),
        .di_im(fft_group0_do_im),
        .in_group_idx(), // FFT
        .in_group_num(), // FFT
        .do_en(select_buffer0_do_en),
        .do_re(select_buffer0_do_re),
        .do_im(select_buffer0_do_im),
        .out_group_idx(select_buffer0_out_group_idx),
        .out_group_num(select_buffer0_out_group_idx)
    );

    select_buffer #(
        .I_BW(FFT_O_BW),
        .O_BW(SELECT_BUFFER_O_BW)
    ) select_buffer1(
        .clk(clk),
        .rst(rst),
        .di_en(fft_group1_do_en),
        .di_re(fft_group1_do_re),
        .di_im(fft_group1_do_im),
        .in_group_idx(), // FFT
        .in_group_num(), // FFT
        .do_en(select_buffer1_do_en),
        .do_re(select_buffer1_do_re),
        .do_im(select_buffer1_do_im),
        .out_group_idx(select_buffer1_out_group_idx),
        .out_group_num(select_buffer1_out_group_idx)
    );

    select_buffer #(
        .I_BW(FFT_O_BW),
        .O_BW(SELECT_BUFFER_O_BW)
    ) select_buffer2(
        .clk(clk),
        .rst(rst),
        .di_en(fft_group2_do_en),
        .di_re(fft_group2_do_re),
        .di_im(fft_group2_do_im),
        .in_group_idx(), // FFT
        .in_group_num(), // FFT
        .do_en(select_buffer2_do_en),
        .do_re(select_buffer2_do_re),
        .do_im(select_buffer2_do_im),
        .out_group_idx(select_buffer2_out_group_idx),
        .out_group_num(select_buffer2_out_group_idx)
    );

    localparam SQUARED_O_BW = 27;
    wire signed [SQUARED_O_BW-1:0] out_squared0;
    wire signed [SQUARED_O_BW-1:0] out_squared1;
    wire signed [SQUARED_O_BW-1:0] out_squared2;
    wire [9:0] squared_out_group_idx;
    wire [6:0] squared_out_group_um;
    wire squared0_do_en;
    wire squared1_do_en;
    wire squared2_do_en;

    squared #(
       .I_BW(FFT_O_BW),
       .O_BW(SQUARED_O_BW)
    ) power0(
        .clk(clk),
        .rst(rst),
        .in_group_idx(select_buffer0_out_group_idx), // 0-512
        .in_group_num(select_buffer0_out_group_num), // 0-88
        .di_re(select_buffer0_do_re),
        .di_im(select_buffer0_do_im),
        .di_en(select_buffer0_do_en),
        .is_first_in(is_first_in), // ????
        .is_last_in(is_last_in), // ????
        .data_o(out_squared0),
        .do_en(squared0_do_en),
        .out_group_idx(squared_out_group_idx),
        .out_group_num(squared_out_group_num)
    );

    squared #(
       .I_BW(FFT_O_BW),
       .O_BW(SQUARED_O_BW)
    ) power1(
        .clk(clk),
        .rst(rst),
        .in_group_idx(select_buffer1_out_group_idx), // 0-512
        .in_group_num(select_buffer1_out_group_num), // 0-88
        .di_re(select_buffer1_do_re),
        .di_im(select_buffer1_do_im),
        .di_en(select_buffer1_do_en),
        .is_first_in(is_first_in), // ????
        .is_last_in(is_last_in), // ????
        .data_o(out_squared1),
        .do_en(squared1_do_en),
        .out_group_idx(squared_out_group_idx),
        .out_group_num(squared_out_group_num)
    );

    squared #(
       .I_BW(FFT_O_BW),
       .O_BW(SQUARED_O_BW)
    ) power2(
        .clk(clk),
        .rst(rst),
        .in_group_idx(select_buffer2_out_group_idx), // 0-512
        .in_group_num(select_buffer2_out_group_num), // 0-88
        .di_re(select_buffer2_do_re),
        .di_im(select_buffer2_do_im),
        .di_en(select_buffer2_do_en),
        .is_first_in(is_first_in), // ????
        .is_last_in(is_last_in), // ????
        .data_o(out_squared2),
        .do_en(squared2_do_en),
        .out_group_idx(squared_out_group_idx),
        .out_group_num(squared_out_group_num)
    );

    localparam MEL_O_BW = 30;

    wire signed [MEL_O_BW-1:0] out_mel0;
    wire signed [MEL_O_BW-1:0] out_mel1;
    wire signed [MEL_O_BW-1:0] out_mel2;
    wire [6:0] out_mel_group_num;  // 0-88

    wire mel0_do_en;
    wire mel1_do_en;
    wire mel2_do_en;

    mel_filter #(
       .I_BW(SQUARED_O_BW),
       .O_BW(MEL_O_BW)
    ) mel0(
        .clk(clk),
        .rst(rst),
        .in_group_idx(squared_out_group_idx), // 0-512 // 
        .in_group_num(squared_out_group_num), // 0-88 //
        .data_i(out_squared0),
        .di_en(squared0_do_en),
        .is_first_in(is_first_in), // squared
        .is_last_in(is_last_in), // squared
        .data_o(out_mel0),
        .do_en(mel0_do_en),
        .out_group_num(out_mel_group_num)
    );

    mel_filter #(
       .I_BW(SQUARED_O_BW),
       .O_BW(MEL_O_BW)
    ) mel1(
        .clk(clk),
        .rst(rst),
        .in_group_idx(squared_out_group_idx), // 0-512 // 
        .in_group_num(squared_out_group_num), // 0-88 //
        .data_i(out_squared1),
        .di_en(squared1_do_en),
        .is_first_in(is_first_in), // squared
        .is_last_in(is_last_in), // squared
        .data_o(out_mel1),
        .do_en(mel1_do_en),
        .out_group_num(out_mel_group_num)
    );

    mel_filter #(
       .I_BW(SQUARED_O_BW),
       .O_BW(MEL_O_BW)
    ) mel2(
        .clk(clk),
        .rst(rst),
        .in_group_idx(squared_out_group_idx), // 0-512 // 
        .in_group_num(squared_out_group_num), // 0-88 //
        .data_i(out_squared2),
        .di_en(squared2_do_en),
        .is_first_in(is_first_in), // squared
        .is_last_in(is_last_in), // squared
        .data_o(out_mel2),
        .do_en(mel2_do_en),
        .out_group_num(out_mel_group_num)
    );

endmodule