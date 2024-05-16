`timescale 1ns / 1ns
module TB;
  localparam I_BW = 14;
  localparam O_BW = 14;
  localparam N = 1024;
  localparam IN_N = 1024;  // 88*160+1023*1
  localparam OUT_N = 64;  // 64*89
  localparam OUT_N_PAIR = OUT_N / 64;

  reg clk;
  reg rst;
  reg [1:0] di_en;
  reg signed [I_BW-1:0] data_i;
  wire signed [O_BW*64-1:0] data_o;
  wire do_en;

  reg [I_BW-1:0]	imem[0:IN_N]; // 0行目のデータが採用されない設計になってしまってる
  reg [O_BW-1:0] omem[0:OUT_N-1];

  //----------------------------------------------------------------------
  //	Clock and Reset
  //----------------------------------------------------------------------
  always begin
    clk = 0;
    #10;
    clk = 1;
    #10;
  end

  initial begin
    rst = 1;
    #20;
    rst = 0;
    #100;
    rst = 1;
  end

  //----------------------------------------------------------------------
  //	Functional Blocks
  //----------------------------------------------------------------------

  //	Input Control Initialize
  initial begin
    wait (rst == 0);
    di_en = 0;
  end

  //	Output Data Capture
  initial begin : OCAP
    integer n;
    integer i;
    integer j;
    reg signed [O_BW-1:0] data_o_partial;
    n <= 0;
    forever begin
      while (do_en !== 1) @(negedge clk);
      while ((do_en == 1) && (n < OUT_N_PAIR)) begin
        // $display("data_o=%b", data_o);
        for (i = 0; i < 64; i = i + 1) begin
          for (j = 0; j < O_BW; j = j + 1) begin
            data_o_partial[j] = data_o[i*O_BW+j];
          end
          omem[n*64+i] = data_o_partial;
          // $display("n=%d, i=%d, data_o_partial=%b", n, i, data_o_partial);
        end
        n <= n + 1;
        // $display("-----");
        @(negedge clk);
      end
    end
  end

  //----------------------------------------------------------------------
  //	Tasks
  //----------------------------------------------------------------------
  task LoadInputData;
    input [80*8:1] filename;
    begin
      $readmemb(filename, imem);
    end
  endtask

  task GenerateInputWave;
    integer n;
    integer t_clk;
    begin
      t_clk = 0;
      di_en <= 0;

      n = 0;
      while (n <= IN_N) begin  // 0行目のデータが採用されない設計になってしまってる
        // $display("t_clk=%d, n=%d", t_clk, n); 
        if (t_clk < 1024) begin
          di_en <= 1;
          data_i <= imem[n];
          // $display("t_clk=%d, n=%d, data_i=%d, di_en=%d", t_clk, n, data_i, di_en); 
          t_clk <= t_clk + 1;
          n <= n + 1;
        end else if ((t_clk % 1024) < 160) begin
          di_en  <= 1;
          data_i <= imem[n];
          // $display("t_clk=%d, n=%d, data_i=%d, di_en=%d", t_clk, n, data_i, di_en); 
          t_clk = t_clk + 1;
          n <= n + 1;
        end else if ((t_clk % 1024) >= 160) begin
          di_en  <= 2;
          data_i <= imem[n];
          // $display("t_clk=%d, n=%d, data_i=%d, di_en=%d", t_clk, n, data_i, di_en); 
          t_clk = t_clk + 1;
          n <= n;
        end else begin
          di_en  <= 0;
          data_i <= imem[n];
          // $display("t_clk=%d, n=%d, data_i=%d, di_en=%d", t_clk, n, data_i, di_en); 
          t_clk = t_clk + 1;
          n <= n;
        end
        @(posedge clk);
      end

      di_en  <= 0;
      data_i <= 'bx;
    end
  endtask

  task SaveOutputData;
    input [80*8:1] filename;
    integer fp, n, i;
    begin
      fp = $fopen(filename);
      for (n = 0; n < OUT_N; n = n + 1) begin
        $fdisplay(fp, "%b // %d", omem[n], n);
      end
      $fclose(fp);
    end
  endtask

  //----------------------------------------------------------------------
  //	Module Instances
  //----------------------------------------------------------------------

  wire input_counter_en_lo;
  wire framing_en_lo;
  wire hann_en_lo;
  wire fft_group0_en_lo;
  wire post_fft_count_group0_en_lo;
  wire rfft_group0_en;
  wire mel_filter_group0_en_lo;

  log_mel_spectrogram logmel (
      .clk_i (clk),
      .rst_i (rst),
      .en_i  (di_en),
      .data_i(data_i),
      .en_o  (do_en),
      .data_o(data_o),
      .input_counter_en_lo(input_counter_en_lo),
      .framing_en_lo(framing_en_lo),
      .hann_en_lo(hann_en_lo),
      .fft_group0_en_lo(fft_group0_en_lo),
      .post_fft_count_group0_en_lo(post_fft_count_group0_en_lo),
      .rfft_group0_en(rfft_group0_en),
      .mel_filter_group0_en_lo(mel_filter_group0_en_lo)

  );

  //----------------------------------------------------------------------
  //	Test Stimuli
  //----------------------------------------------------------------------
  initial begin : STIM
    integer k;

    wait (rst == 0);
    wait (rst == 1);
    repeat (10) @(posedge clk);

    fork
      begin
        LoadInputData("input.txt");
        GenerateInputWave;
        @(posedge clk);
      end
      begin
        wait (do_en == 1);
        // repeat(OUT_N) @(posedge clk); //
        k = 0;
        // while (k < OUT_N_PAIR) begin
        while (k < OUT_N_PAIR + 1) begin  // 初めのk=1が無効
          if (!rst) begin
            k = 0;
          end else if (do_en) begin
            k = k + 1;
            // $display("k=%d", k);
          end else begin
            k = k;
          end
          @(negedge clk);
        end
        $display("done");
        SaveOutputData("output.txt");
      end
    join

    repeat (10) @(posedge clk);
    $finish;
  end
  initial begin : TIMEOUT
    repeat (1000000000) #20;  //  1000 Clock Cycle Time
    $display("[FAILED] Simulation timed out.");
    $finish;
  end

  reg [31:0] cnt;

  always @(posedge clk or negedge rst) begin: latency_measurement
    integer a;
    if (!rst) begin
      a <= 0;
    end else begin
      $display("a=%d, di_en=%d, do_en=%d, input_counter_en_lo=%d,framing_en_lo=%d,hann_en_lo=%d,fft_group0_en_lo=%d,post_fft_count_group0_en_lo=%d,rfft_group0_en=%d,mel_filter_group0_en_lo=%d",
              a, di_en, do_en,
              input_counter_en_lo, framing_en_lo, hann_en_lo, fft_group0_en_lo, post_fft_count_group0_en_lo, rfft_group0_en, mel_filter_group0_en_lo);
      a <= a + 1;
    end
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
    end

  end

endmodule
