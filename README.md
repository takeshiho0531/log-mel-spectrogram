# log-mel-spectrogram<!-- omit in toc -->


** 簡単な説明[目次] **


- [log\_mel (log\_mel.v)](#log_mel-log_melv)
  - [input\_counter (input\_counter.v)](#input_counter-input_counterv)
  - [framing(framing.v)](#framingframingv)
  - [hann\_window (hann\_window.v)](#hann_window-hann_windowv)
  - [FFT](#fft)
  - [counter(counter.v)](#countercounterv)
  - [bit\_reversal\_count](#bit_reversal_count)
  - [select\_buffer(select\_buffer.v)](#select_bufferselect_bufferv)
  - [squared(squared.v)](#squaredsquaredv)
  - [mel\_filter(mel\_filter.v)](#mel_filtermel_filterv)
  - [log(log.v)](#loglogv)


## log_mel (log_mel.v)
log-melspectrogram全体のmodule
```verilog
module log_mel_spectrogram #(
    parameter I_BW = 14,
    parameter O_BW = 14
)(
    input clk,
    input rst,
    input [1:0] di_en,
    input signed [I_BW-1:0] data_i,
    output reg do_en,
    output reg signed [O_BW*64-1:0] data_o
);
```
- di_en: inputされるデータの状態(validか)のフラグ
    - 0: invalid
    - 1: valid
    - 2: invalid (ただしこの時はframingモジュールからの出力は有効)
- data_i: inputのデータ
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid)
- data_o: outputされるデータ

### input_counter (input_counter.v)
次のframingモジュールで拍を取るためのカウントをデータにつける役割
```verilog
module input_counter# (
    parameter I_BW         = 14,
    parameter O_BW         = 14,
    parameter TOTAL_COUNT   = 91136
)(
    input clk,
    input rst,
    input [1:0] di_en,  // 0:invalid, 1:ok, 2:input wait time
    input [I_BW-1:0] data_i,
    output reg [1:0] do_en,
    output reg [O_BW-1:0] data_o,
    output [$clog2(TOTAL_COUNT)-1:0] num
);
```
- TOTAL_COUNT: カウントは1024*89まで取られる
- di_en: inputされるデータの状態(validか)のフラグ
    - 0: invalid
    - 1: valid
    - 2: invalid (ただしこの時はframingモジュールからの出力は有効)
- data_i: inputのデータ
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid)
- data_o: outputされるデータ
- num: dataに付与されたカウント(拍)

### framing(framing.v)
```verilog
module framing # (
    parameter I_BW         = 14,   // input
    parameter O_BW         = 14,  // output to FFT
    parameter FRAME_LEN    = 1024,
    parameter HOP_LEN      = 160,
    parameter OUTPUT_TOTAL_DATA = 91136
)(
    input clk,
    input rst,
    input [1:0] di_en, // 0:invalid, 1:ok, 2:input wait time
    input signed [I_BW - 1 : 0] data_i,
    input [$clog2(OUTPUT_TOTAL_DATA)-1:0] in_num,
    output reg do_en,
    output reg signed [O_BW - 1 : 0] data_o,
    output [($clog2(OUTPUT_TOTAL_DATA)-1):0] out_num
);
```
- FRAME_LEN: 各まとまり(フレーム)内にあるデータ数
- HOP_LEN: フレームの先頭がHOP_LENずつ進んでいくということ
- OUTPUT_TOTAL_DATA: framingモジュールを出た後のデータ数が延べいくつになるかという数
- di_en: inputされるデータの状態(validか)のフラグ
    - 0: invalid
    - 1: valid
    - 2: invalid (ただしこの時はframingモジュールからの出力は有効)
- in_num: inputのデータに付与されてるカウント(拍)
- data_i: inputのデータ
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid)
- data_o: outputされるデータ
- out_num: outputのデータに付与されてるカウント(拍)、通し番号何番目のデータかというラベル

### hann_window (hann_window.v)
framingモジュールを出た後のデータにhann窓をかけるモジュール。hann窓の係数はhann_window_rom(hann_window_rom.v)を通して読み出す
```verilog
module hann_window # (
    parameter I_BW = 14,
    parameter O_BW = 14,
    parameter FRAME_LEN = 1024,
    parameter TOTAL_DATA = 91136
)(
    input clk,
    input rst,
    input signed [I_BW - 1 : 0] data_i,
    input [($clog2(TOTAL_DATA)-1):0] in_num,
    input di_en,
    output reg do_en,
    output reg [($clog2(FRAME_LEN)-1):0] out_group_idx,
    output reg [$clog2(TOTAL_DATA/FRAME_LEN):0] out_group_num,
    output reg signed [O_BW-1:0] data_o
);
```
- FRAME_LEN: hann窓がフレーム幾つに対応しているか(FRAME_LEN=1024に対応したhann_window_rom.vになっている)
- TOTAL_DATA: hann窓をかける対象となるデータ数
- FRAME_LEN: 各まとまり(フレーム)内にあるデータ数
- HOP_LEN: フレームの先頭がHOP_LENずつ進んでいくということ
- OUTPUT_TOTAL_DATA: framingモジュールを出た後のデータ数が延べいくつになるかという数
- di_en: inputされるデータの状態のフラグ(0: invalid, 1: valid)
- in_num: inputのデータが通し番号何番目のデータか
- data_i: inputのデータ
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid)
- out_group_idx: outputされるデータがグループ内の何番目のデータか
- out_group_num: outputされるデータが何番目のグループのデータか
- data_o: outputされるデータ

### FFT
FFTをするモジュール
```verilog
module FFT #(
    parameter   WIDTH = 14
)(
    input               clock,  //  Master Clock
    input               reset,  //  Active High Asynchronous Reset
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    output              do_en,  //  Output Data Enable
    output  [WIDTH-1:0] do_re,  //  Output Data (Real)
    output  [WIDTH-1:0] do_im   //  Output Data (Imag)
);
```
- 1024点FFT
- 初めの入力から最後の出力までは2060カウント、つまりFFTモジュールが空になるには2060カウント必要。これは1024個のグループが順にFFTに入ってくることを考えると2060>1024*2より、FFT入力前にバッファ等を置かないとすると最低3並列にしないといけない。3並列のFFTのうちどれを使うかはframingモジュールのout_group_numの値で決める。その後のモジュールも3並列である。

### counter(counter.v)
FFTから出てきたデータに番号をつけるモジュール(bit reverseの順番で出てくる)
```verilog
module counter# (
    parameter I_BW         = 14,
    parameter O_BW         = 14,
    parameter TOTAL_DATA   = 91136
)(
    input clk,
    input rst,
    input di_en,
    input [I_BW-1:0] di_re,
    input [I_BW-1:0] di_im,
    output reg do_en,
    output reg [O_BW-1:0] do_re,
    output reg [O_BW-1:0] do_im,
    output [$clog2(TOTAL_DATA)-1:0] num
);
```
- di_en: inputされるデータの状態のフラグ(0: invalid, 1: valid)
- di_re/di_im: FFTの出力のうち実部と虚部
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid)
- do_re/do_im: outputデータの実部と虚部
- num: outputされるデータが何番目のデータか

### bit_reversal_count
FFT(バタフライ演算)の出力がbit-reverseの順番で出てくるので実際の順番に直す。クロック的な遅れがない。
```verilog
module bit_reversal_count #(
    parameter GROUP_LEN = 1024
)(
    input [9:0] in_group_idx, // 0-1023
    output [9:0] out_group_idx // 0-1024
);
```
- GROUP_LEN: グループ内のデータ数
- in_group_idx: そのデータが何番目にFFTから出てきたか
- out_group_idx: 実際はFFTの何番目のデータか

### select_buffer(select_buffer.v)
rfftだと513番以降のデータは対象なので捨てて使わない。ここでは各グループ内で0-512のデータを残して513-のデータを捨てる。
```verilog
module select_buffer # (
    parameter I_BW = 14,
    parameter O_BW = 14
)(
    input clk,
    input rst,
    input di_en,
    input signed [I_BW-1:0] di_re,
    input signed [I_BW-1:0] di_im,
    input [9:0] in_group_idx, // 0-1023
    input [6:0] in_group_num, // 0-88
    output reg do_en,
    output reg signed [O_BW-1:0] do_re,
    output reg signed [O_BW-1:0] do_im,
    output reg [9:0] out_group_idx, // 0-512
    output reg [6:0] out_group_num
);
```
- di_en: inputされるデータの状態のフラグ(0: invalid, 1: valid)
- di_re/di_im: FFTの出力のうち実部と虚部
- in_group_idx: inputデータがグループ内でFFTの何番のデータか
- in_group_num: inputデータが何番目のグループに入ってるか
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid; 元々di_en=0のタイミングのデータと513番以降のデータの時に0になるということ)
- do_re/do_im: outputデータの実部と虚部
- out_group_idx: outputデータがグループ内でFFTの何番のデータか
- out_group_num: outputデータが何番目のグループに入ってるか

### squared(squared.v)
FFTの出力からきてるデータの絶対値の二乗を算出。クロック的な遅れがない。
```verilog
module squared #(
    parameter I_BW=14,
    parameter O_BW=27 // (14-1-1)*2+1+1, 1桁多かった
)(
    input signed [I_BW-1:0] di_re,
    input signed [I_BW-1:0] di_im,
    output signed [O_BW-1:0] data_o
);
```
- O_BW: 二乗してさらに足し算するので桁が大きくなる。inputはsignedの14bitなので、di_reとdi_imのmaxは2^12の桁、よって二乗のmaxは2^24の桁、それに符号分1bitと、足し合わせた際の繰り上がり用の1bit
- di_re/di_im: FFTの出力由来のうち実部と虚部
- data_o: inputで表される複素数の絶対値の二乗

### mel_filter(mel_filter.v)
メルフィルター(フィルター数64)をかける。行列積の計算。
```verilog
module mel_filter # (
    parameter I_BW = 27, // 2乗は別のモジュール
    parameter O_BW = 30,
    parameter COEF_BW = 27
)(
    input clk,
    input rst,
    input [9:0] in_group_idx, // 0-512
    input signed [I_BW-1:0] data_i,
    input [6:0] in_group_num, // 0-88
    input di_en,
    input is_first_in,
    input is_last_in,
    output signed [O_BW*64-1:0] data_o,
    output reg do_en,
    output reg [6:0] out_group_num // 0-88
);
```
- COEF_BW: mel filterの係数が何bitか(signedの掛け算になるのでI_BWに合わせている。COEF_BW = 27で係数をmel_filter_rom.vに格納。)
- in_group_idx: inputデータがFFT出力の何番目に対応するデータか
- in_group_num: inputデータが何番目のグループのデータか
- data_i: inputのデータ
- di_en: inputされるデータの状態のフラグ(0: invalid, 1: valid)
- is_first_in: inputのデータがグループ内最初のデータか
- is_last_in: inputのデータがグループ内最後のデータか
- data_o: outputデータ
- do_en: outputされるデータの状態のフラグ(0: invalid, 1: valid; 元々di_en=0のタイミングのデータと513番以降のデータの時に0になるということ)
- out_group_num: outputデータが何番目のグループのデータか

### log(log.v)
最後logとる。クロック的な遅れがない。
```verilog
module log #(
    parameter I_BW = 30,
    parameter O_BW = 14,
    parameter SHIFT = 10
)(
    input signed [I_BW*64-1:0] data_i,
    output signed [O_BW*64-1:0] data_o
);

```
- SHIFT: FFTでSHIFT/2の分だけ実は過小評価されていて(FFTのアルゴリズムのため。)、それをsquaredを通してSHIFT分過小評価したことになるので、それをlogで回復する。
- data_i: inputのデータ
- data_o: logを取られたoutputのデータ
