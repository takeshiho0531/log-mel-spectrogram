`timescale 1ns / 1ns
module log #(
    parameter I_BW = 21,
    parameter O_BW = 14,
    parameter SHIFT_BY_FFT = 10,
    parameter LSB_I = -24,
    parameter LSB_O = -5
) (
    input [I_BW*64-1:0] data_i,
    output signed [O_BW*64-1:0] data_o
);

  function integer logb2;
    input [I_BW-1:0] antilogarithm;
    integer tmp_logb2;
    begin
      tmp_logb2 = antilogarithm[I_BW-1]==1'b1 ? 20 :
                        antilogarithm[I_BW-2]==1'b1 ? 19 :
                        antilogarithm[I_BW-3]==1'b1 ? 18 :
                        antilogarithm[I_BW-4]==1'b1 ? 17 :
                        antilogarithm[I_BW-5]==1'b1 ? 16 :
                        antilogarithm[I_BW-6]==1'b1 ? 15 :
                        antilogarithm[I_BW-7]==1'b1 ? 14 :
                        antilogarithm[I_BW-8]==1'b1 ? 13 :
                        antilogarithm[I_BW-9]==1'b1 ? 12 :
                        antilogarithm[I_BW-10]==1'b1 ? 11 :
                        antilogarithm[I_BW-11]==1'b1 ? 10 :
                        antilogarithm[I_BW-12]==1'b1 ? 9 :
                        antilogarithm[I_BW-13]==1'b1 ? 8 :
                        antilogarithm[I_BW-14]==1'b1 ? 7 :
                        antilogarithm[I_BW-15]==1'b1 ? 6 :
                        antilogarithm[I_BW-16]==1'b1 ? 5 :
                        antilogarithm[I_BW-17]==1'b1 ? 4 :
                        antilogarithm[I_BW-18]==1'b1 ? 3 :
                        antilogarithm[I_BW-19]==1'b1 ? 2 :
                        antilogarithm[I_BW-20]==1'b1 ? 1 :0;

      logb2 = tmp_logb2 + SHIFT_BY_FFT + LSB_I;
      // $display("antilogarithm=%b, tmp_logb2=%d", antilogarithm, tmp_logb2);
    end

  endfunction

  function signed [O_BW-1:0] base_changed_to_E;
    input integer logb2;
    reg signed [O_BW-1:0] logb2_shifted;
    reg signed [O_BW-1:0] logb2E_shifted;
    begin
      logb2_shifted = logb2[O_BW-1:0] <<<((-1)*(LSB_O)); // logb2はintegerだけど、出力は2**7~2**(-5)にしたい
      base_changed_to_E = logb2_shifted * 5 / 7;
    end
  endfunction

  function signed [O_BW*64-1:0] total_log;
    input signed [I_BW*64-1:0] total_input;
    integer i;
    integer j;
    integer k;
    reg signed [I_BW-1:0] each_input;
    reg signed [O_BW-1:0] each_logb2;
    reg signed [O_BW-1:0] each_output;

    for (i = 0; i < 64; i = i + 1) begin
      for (j = 0; j < I_BW; j = j + 1) begin
        each_input[j] = total_input[i*I_BW+j];
      end

      each_logb2  = logb2(each_input);
      each_output = base_changed_to_E(each_logb2);
      for (k = 0; k < O_BW; k = k + 1) begin
        total_log[i*O_BW+k] = each_output[k];
      end
    end
  endfunction

  assign data_o = total_log(data_i);
endmodule
