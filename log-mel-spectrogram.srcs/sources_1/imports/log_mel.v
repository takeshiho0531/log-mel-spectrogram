`timescale 1ns / 1ns
module log_mel_spectrogram #(
    parameter I_BW = 14,
    parameter O_BW = 14
) (
    input clk_i,
    input rst_i,
    input [1:0] en_i,
    input signed [I_BW-1:0] data_i,
    output reg en_o,
    output reg signed [O_BW*64-1:0] data_o
);
  localparam INPUT_COUNTER_O_BW = 14;
  localparam FRAMING_O_BW = 14;
  localparam TOTAL_DATA = 15104;
  localparam OUT_FRAMING_TOTAL_DATA = 91136;
  localparam HANN_WINDOW_O_BW = 14;
  localparam FRAME_LEN = 1024;


  wire signed [INPUT_COUNTER_O_BW-1:0] input_counter_data_lo;
  wire [$clog2(OUT_FRAMING_TOTAL_DATA)-1:0] input_counter_num_lo;  // 
  wire [1:0] input_counter_en_lo;
  wire [($clog2(OUT_FRAMING_TOTAL_DATA)-1):0] framing_num_lo;
  wire framing_en_lo;
  wire signed [FRAMING_O_BW-1:0] framing_data_lo;
  wire signed [HANN_WINDOW_O_BW-1:0] hann_data_lo;
  wire hann_en_lo;
  wire [($clog2(FRAME_LEN)-1):0] hann_group_idx_lo;
  wire [$clog2(OUT_FRAMING_TOTAL_DATA/FRAME_LEN):0] hann_group_num_lo;



  input_counter #(
      .I_BW(INPUT_COUNTER_O_BW),
      .O_BW(FRAMING_O_BW)
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

  assign fft_group = hann_group_num_lo % 3;
  assign is_fft_group0 = hann_en_lo & (fft_group == 0);
  assign is_fft_group1 = hann_en_lo & (fft_group == 1);
  assign is_fft_group2 = hann_en_lo & (fft_group == 2);

  assign di_im = 0;

  FFT FFT0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (is_fft_group0),
      .re_i (hann_data_lo),
      .im_i (di_im),
      .en_o (fft_group0_do_en),
      .re_o (fft_group0_do_re),
      .im_o (fft_group0_do_im)
  );

  FFT FFT1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (is_fft_group1),
      .re_i (hann_data_lo),
      .im_i (di_im),
      .en_o (fft_group1_do_en),
      .re_o (fft_group1_do_re),
      .im_o (fft_group1_do_im)
  );

  FFT FFT2 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (is_fft_group2),
      .re_i (hann_data_lo),
      .im_i (di_im),
      .en_o (fft_group2_do_en),
      .re_o (fft_group2_do_re),
      .im_o (fft_group2_do_im)
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
  ) counter0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (fft_group0_do_en),
      .re_i (fft_group0_do_re),
      .im_i (fft_group0_do_im),
      .en_o (counter0_do_en),
      .re_o (counter0_do_re),
      .im_o (counter0_do_im),
      .num_o(count0)
  );

  counter #(
      .I_BW(FFT_O_BW),
      .O_BW(COUNTER_O_BW)
  ) counter1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (fft_group1_do_en),
      .re_i (fft_group1_do_re),
      .im_i (fft_group1_do_im),
      .en_o (counter1_do_en),
      .re_o (counter1_do_re),
      .im_o (counter1_do_im),
      .num_o(count1)
  );

  counter #(
      .I_BW(FFT_O_BW),
      .O_BW(COUNTER_O_BW)
  ) counter2 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i (fft_group2_do_en),
      .re_i (fft_group2_do_re),
      .im_i (fft_group2_do_im),
      .en_o (counter2_do_en),
      .re_o (counter2_do_re),
      .im_o (counter2_do_im),
      .num_o(count2)
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

  bit_reversal_count reverse0 (
      .group_idx_i(bit_reversal_count0_in_group_idx),
      .group_idx_o(bit_reversal_count0_out_group_idx)
  );

  bit_reversal_count reverse1 (
      .group_idx_i(bit_reversal_count1_in_group_idx),
      .group_idx_o(bit_reversal_count1_out_group_idx)
  );

  bit_reversal_count reverse2 (
      .group_idx_i(bit_reversal_count2_in_group_idx),
      .group_idx_o(bit_reversal_count2_out_group_idx)
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
  ) select_buffer0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i(counter0_do_en),
      .re_i(counter0_do_re),
      .im_i(counter0_do_im),
      .group_idx_i(bit_reversal_count0_in_group_idx),
      .group_num_i(bit_reversal_count0_group_num),
      .en_o(select_buffer0_do_en),
      .re_o(select_buffer0_do_re),
      .im_o(select_buffer0_do_im),
      .group_idx_o(select_buffer0_out_group_idx),
      .group_num_o(select_buffer0_out_group_num)
  );

  select_buffer #(
      .I_BW(FFT_O_BW),
      .O_BW(SELECT_BUFFER_O_BW)
  ) select_buffer1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i(counter1_do_en),
      .re_i(counter1_do_re),
      .im_i(counter1_do_re),
      .group_idx_i(bit_reversal_count1_in_group_idx),
      .group_num_i(bit_reversal_count1_group_num),
      .en_o(select_buffer1_do_en),
      .re_o(select_buffer1_do_re),
      .im_o(select_buffer1_do_im),
      .group_idx_o(select_buffer1_out_group_idx),
      .group_num_o(select_buffer1_out_group_num)
  );

  select_buffer #(
      .I_BW(FFT_O_BW),
      .O_BW(SELECT_BUFFER_O_BW)
  ) select_buffer2 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .en_i(counter2_do_en),
      .re_i(counter2_do_re),
      .im_i(counter2_do_re),
      .group_idx_i(bit_reversal_count2_in_group_idx),
      .group_num_i(bit_reversal_count2_group_num),
      .en_o(select_buffer2_do_en),
      .re_o(select_buffer2_do_re),
      .im_o(select_buffer2_do_im),
      .group_idx_o(select_buffer2_out_group_idx),
      .group_num_o(select_buffer2_out_group_num)
  );

  localparam SQUARED_O_BW = 27;
  wire signed [SQUARED_O_BW-1:0] out_squared0;
  wire signed [SQUARED_O_BW-1:0] out_squared1;
  wire signed [SQUARED_O_BW-1:0] out_squared2;

  assign out_squared0 = select_buffer0_do_re * select_buffer0_do_re + select_buffer0_do_im * select_buffer0_do_im;
  assign out_squared1 = select_buffer1_do_re * select_buffer1_do_re + select_buffer1_do_im * select_buffer1_do_im;
  assign out_squared2 = select_buffer2_do_re * select_buffer2_do_re + select_buffer2_do_im * select_buffer2_do_im;


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
  assign is_mel0_last_in  = (select_buffer0_out_group_idx % 513 == 512);
  assign is_mel1_first_in = (select_buffer1_out_group_idx % 513 == 0);
  assign is_mel1_last_in  = (select_buffer1_out_group_idx % 513 == 512);
  assign is_mel2_first_in = (select_buffer2_out_group_idx % 513 == 0);
  assign is_mel2_last_in  = (select_buffer2_out_group_idx % 513 == 512);

  mel_filter #(
      .I_BW(SQUARED_O_BW),
      .O_BW(MEL_O_BW)
  ) mel0 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .group_idx_i(select_buffer0_out_group_idx),  // 0-512 // 
      .group_num_i(select_buffer0_out_group_num),  // 0-88 //
      .data_i(out_squared0),
      .en_i(select_buffer0_do_en),
      .is_first_i(is_mel0_first_in),  // squared
      .is_last_i(is_mel0_last_in),  // squared
      .data_o(out_mel0),
      .en_o(mel0_do_en),
      .group_num_o(out_mel0_group_num)
  );

  mel_filter #(
      .I_BW(SQUARED_O_BW),
      .O_BW(MEL_O_BW)
  ) mel1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .group_idx_i(select_buffer1_out_group_idx),  // 0-512 // 
      .group_num_i(select_buffer1_out_group_num),  // 0-88 //
      .data_i(out_squared1),
      .en_i(select_buffer1_do_en),
      .is_first_i(is_mel1_first_in),  // squared
      .is_last_i(is_mel1_last_in),  // squared
      .data_o(out_mel1),
      .en_o(mel1_do_en),
      .group_num_o(out_mel1_group_num)
  );

  mel_filter #(
      .I_BW(SQUARED_O_BW),
      .O_BW(MEL_O_BW)
  ) mel2 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .group_idx_i(select_buffer2_out_group_idx),  // 0-512 //
      .group_num_i(select_buffer2_out_group_num),  // 0-88 //
      .data_i(out_squared2),
      .en_i(select_buffer2_do_en),
      .is_first_i(is_mel2_first_in),
      .is_last_i(is_mel2_last_in),
      .data_o(out_mel2),
      .en_o(mel2_do_en),
      .group_num_o(out_mel2_group_num)
  );

  localparam LOG_O_BW = 14;
  wire signed [LOG_O_BW*64-1:0] out_log0;
  wire signed [LOG_O_BW*64-1:0] out_log1;
  wire signed [LOG_O_BW*64-1:0] out_log2;

  log #(
      .I_BW(MEL_O_BW),
      .O_BW(LOG_O_BW)
  ) log0 (
      .data_i(out_mel0),
      .data_o(out_log0)
  );

  log #(
      .I_BW(MEL_O_BW),
      .O_BW(LOG_O_BW)
  ) log1 (
      .data_i(out_mel1),
      .data_o(out_log1)
  );

  log #(
      .I_BW(MEL_O_BW),
      .O_BW(LOG_O_BW)
  ) log2 (
      .data_i(out_mel2),
      .data_o(out_log2)
  );

  always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
      data_o <= 0;
    end else begin
      if (mel0_do_en) begin
        data_o <= out_log0;
        en_o   <= 1;
      end else if (mel1_do_en) begin
        data_o <= out_log1;
        en_o   <= 1;
      end else if (mel2_do_en) begin
        data_o <= out_log2;
        en_o   <= 1;
      end else begin
        en_o   <= 0;
        data_o <= 0;
      end
    end
  end

endmodule
