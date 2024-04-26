`timescale 1ns / 1ns
module input_counter #(
    parameter I_BW       = 14,
    parameter O_BW       = 14,
    // parameter TOTAL_DATA   = 15104
    parameter TOTAL_DATA = 91136
) (
    input clk_i,
    input rst_i,
    input [1:0] en_i,  // 0:invalid, 1:ok, 2:input wait time
    input [I_BW-1:0] data_i,
    output reg [1:0] en_o,
    output reg [O_BW-1:0] data_o,
    output [$clog2(TOTAL_DATA)-1:0] num_o
);

  integer count;
  assign num_o = count - 1;  // zero start

  always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
      count  <= 0;
      en_o   <= 0;
      data_o <= 0;
    end else if (en_i == 1) begin
      data_o <= data_i;
      count  <= count + 1;
      en_o   <= 1;
    end else if (en_i == 2) begin
      data_o <= data_i;
      count  <= count + 1;  //
      en_o   <= 2;
    end else begin
      en_o   <= 0;
      count  <= count;  //
      data_o <= 0;
    end
  end
endmodule
