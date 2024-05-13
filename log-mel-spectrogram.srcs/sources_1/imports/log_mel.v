`timescale 1ns / 1ns
module log_mel_spectrogram #(
    parameter I_BW = 14,
    parameter O_BW = 14
) (
    input clk_i,
    input rst_i,
    input [1:0] en_i,
    input signed [I_BW-1:0] data_i,
    output en_o,
    output signed [O_BW*64-1:0] data_o
);
  localparam INPUT_COUNTER_O_BW = 14;
  localparam FRAMING_O_BW = 14;
  localparam TOTAL_DATA = 15104;
  localparam OUT_FRAMING_TOTAL_DATA = 91136;
  localparam HANN_WINDOW_O_BW = 14;
  localparam FRAME_LEN = 1024;
  localparam FFT_O_BW = 14;
  localparam POST_FFT_COUNT_O_BW = 14;
  localparam SQUARED_O_BW = 26;
  localparam MEL_O_BW = 21;
  localparam LOG_O_BW = 14;

  wire signed [INPUT_COUNTER_O_BW-1:0] input_counter_data_lo;
  wire [$clog2(OUT_FRAMING_TOTAL_DATA)-1:0] input_counter_num_lo;
  wire [1:0] input_counter_en_lo;

  wire [($clog2(OUT_FRAMING_TOTAL_DATA)-1):0] framing_num_lo;
  wire framing_en_lo;
  wire signed [FRAMING_O_BW-1:0] framing_data_lo;

  wire signed [HANN_WINDOW_O_BW-1:0] hann_data_lo;
  wire hann_en_lo;
  wire [($clog2(FRAME_LEN)-1):0] hann_group_idx_lo;
  wire [$clog2(OUT_FRAMING_TOTAL_DATA/FRAME_LEN):0] hann_group_num_lo;

  wire [1:0] fft_group;
  wire fft_group0_en_li;
  wire fft_group0_en_lo;
  wire signed [FFT_O_BW-1:0] fft_group0_re_lo;
  wire signed [FFT_O_BW-1:0] fft_group0_im_lo;


  wire post_fft_count_group0_en_lo;

  wire signed [POST_FFT_COUNT_O_BW-1:0] post_fft_count_group0_re_lo;
  wire signed [POST_FFT_COUNT_O_BW-1:0] post_fft_count_group0_im_lo;

  wire [9:0] post_fft_count_group0_lo;


  wire rfft_group0_en;
  wire rfft_group1_en;
  wire rfft_group2_en;

  wire signed [SQUARED_O_BW:0] power_fft_group0_signed;
  wire [SQUARED_O_BW-1:0] power_fft_group0;

  wire signed [MEL_O_BW*64-1:0] mel_filtered_group0_lo;

  wire mel_filter_group0_en_lo;

  wire is_mel_group0_first_li;
  wire is_mel_group0_last_li;


  wire signed [LOG_O_BW*64-1:0] logged_group0_lo;



  input_counter #(
      .I_BW(I_BW),
      .O_BW(INPUT_COUNTER_O_BW)
  ) count (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .en_i  (en_i),
      .data_i(data_i),
      .en_o  (input_counter_en_lo),
      .data_o(input_counter_data_lo),
      .num_o (input_counter_num_lo)
  );

  framing #(
      .TOTAL_DATA(TOTAL_DATA),
      .I_BW(INPUT_COUNTER_O_BW),
      .O_BW(FRAMING_O_BW)
  ) frame (
      .clk_i (clk_i),
      .rst_i (rst_i),
      .data_i(input_counter_data_lo),
      .en_i  (input_counter_en_lo),    // TODO
      .num_i (input_counter_num_lo),
      .data_o(framing_data_lo),
      .en_o  (framing_en_lo),
      .num_o (framing_num_lo)
  );

  hann_window #(
      .I_BW(FRAMING_O_BW),
      .O_BW(HANN_WINDOW_O_BW),
      .FRAME_LEN(FRAME_LEN),
      .TOTAL_DATA(OUT_FRAMING_TOTAL_DATA)
  ) window (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(framing_data_lo),
      .num_i(framing_num_lo),
      .en_i(framing_en_lo),
      .data_o(hann_data_lo),
      .en_o(hann_en_lo),
      .group_idx_o(hann_group_idx_lo),
      .group_num_o(hann_group_num_lo)
  );

  assign fft_group = hann_group_num_lo % 3;
  assign fft_group0_en_li = hann_en_lo & (fft_group == 0);
  assign fft_group1_en_li = hann_en_lo & (fft_group == 1);
  assign fft_group2_en_li = hann_en_lo & (fft_group == 2);

  FFT FFT0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (fft_group0_en_li),
      .re_i (hann_data_lo),
      .im_i (14'b0),
      .en_o (fft_group0_en_lo),
      .re_o (fft_group0_re_lo),
      .im_o (fft_group0_im_lo)
  );


  post_fft_count #(
      .I_BW(FFT_O_BW),
      .O_BW(POST_FFT_COUNT_O_BW)
  ) count0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i(fft_group0_en_lo),
      .re_i(fft_group0_re_lo),
      .im_i(fft_group0_im_lo),
      .en_o(post_fft_count_group0_en_lo),
      .re_o(post_fft_count_group0_re_lo),
      .im_o(post_fft_count_group0_im_lo),
      .post_fft_count_o(post_fft_count_group0_lo)
  );

  assign rfft_group0_en = post_fft_count_group0_en_lo & (post_fft_count_group0_lo <= 512);



  assign power_fft_group0_signed = post_fft_count_group0_re_lo * post_fft_count_group0_re_lo + post_fft_count_group0_im_lo * post_fft_count_group0_im_lo;
  assign power_fft_group0 = power_fft_group0_signed[SQUARED_O_BW-1:0];




  assign is_mel_group0_first_li = (post_fft_count_group0_lo % 513 == 0);
  assign is_mel_group0_last_li = (post_fft_count_group0_lo % 513 == 512);

  mel_filter #(
      .I_BW(SQUARED_O_BW),
      .O_BW(MEL_O_BW)
  ) mel0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .group_idx_i(post_fft_count_group0_lo),
      .data_i(power_fft_group0),
      .en_i(rfft_group0_en),
      .is_first_i(is_mel_group0_first_li),
      .is_last_i(is_mel_group0_last_li),
      .data_o(mel_filtered_group0_lo),
      .en_o(mel_filter_group0_en_lo)
  );


  log #(
      .I_BW(MEL_O_BW),
      .O_BW(LOG_O_BW)
  ) log0 (
      .data_i(mel_filtered_group0_lo),
      .data_o(logged_group0_lo)
  );

  assign en_o   = mel_filter_group0_en_lo;
  assign data_o = mel_filter_group0_en_lo ? logged_group0_lo : 0;


endmodule
