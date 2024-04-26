`timescale 1ns / 1ns
module framing #(
    parameter I_BW              = 14,     // input
    parameter O_BW              = 14,     // output to FFT
    parameter FRAME_LEN         = 1024,
    parameter HOP_LEN           = 160,
    parameter TOTAL_DATA        = 15104,
    parameter OUTPUT_TOTAL_DATA = 91136
) (
    input clk_i,
    input rst_i,
    input [1:0] en_i,  // 0:invalid, 1:ok, 2:input wait time
    input signed [I_BW - 1 : 0] data_i,
    input [$clog2(OUTPUT_TOTAL_DATA)-1:0] num_i,
    output reg en_o,
    output reg signed [O_BW - 1 : 0] data_o,
    output [($clog2(OUTPUT_TOTAL_DATA)-1):0] num_o
);

  localparam FIFO_DEPTH = FRAME_LEN - HOP_LEN;

  reg [I_BW - 1 : 0] shift_reg[0:(FIFO_DEPTH -1)];

  integer enque_addr;
  integer deque_addr;
  reg [($clog2(OUTPUT_TOTAL_DATA)-1):0] out_num_tmp;
  integer i;

  assign num_o = out_num_tmp - 1;

  always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
      enque_addr <= 0;
      deque_addr <= 0;
      en_o <= 0;
      out_num_tmp <= 0;
      data_o <= 0;
      for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
        shift_reg[i] <= 0;
      end
    end else if (num_i < 160 & en_i == 1) begin
      en_o <= en_i;
      data_o <= data_i;
      enque_addr <= 0;
      deque_addr <= 0;
      out_num_tmp <= out_num_tmp + en_i;
      for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
        shift_reg[i] <= shift_reg[i];
      end
    end else if (num_i >= 160 & num_i < 1024 & en_i == 1) begin
      en_o   <= en_i;
      data_o <= data_i;
      for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
        shift_reg[i] <= shift_reg[i];
      end
      shift_reg[enque_addr] <= data_i;
      enque_addr <= enque_addr + 1;
      deque_addr <= 0;
      out_num_tmp <= out_num_tmp + en_i;
    end else if (num_i >= 1024 & num_i % 1024 < 160 & en_i == 1) begin
      en_o   <= en_i;
      data_o <= shift_reg[deque_addr%FIFO_DEPTH];
      for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
        shift_reg[i] <= shift_reg[i];
      end
      shift_reg[enque_addr%FIFO_DEPTH] <= data_i;
      enque_addr <= enque_addr + 1;
      deque_addr <= deque_addr + 1;
      out_num_tmp <= out_num_tmp + en_i;
    end else if (num_i >= 1024 & num_i % 1024 >= 160 & en_i == 2) begin
      en_o   <= 1;
      data_o <= shift_reg[deque_addr%FIFO_DEPTH];
      for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
        shift_reg[i] <= shift_reg[i];
      end
      enque_addr  <= enque_addr;
      deque_addr  <= deque_addr + 1;
      out_num_tmp <= out_num_tmp + 1;
    end else begin
      en_o <= 0;
      enque_addr <= enque_addr;
      deque_addr <= deque_addr;
      out_num_tmp <= out_num_tmp;
      for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
        shift_reg[i] <= shift_reg[i];
      end
    end
  end

endmodule
