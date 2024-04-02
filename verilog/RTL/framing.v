`timescale	1ns/1ns
module framing # (
    parameter I_BW         = 14,   // input
    parameter O_BW         = 14,  // output to FFT
    parameter FRAME_LEN    = 1024,
    parameter HOP_LEN      = 160,
    parameter TOTAL_DATA = 15104,
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

    localparam FIFO_DEPTH = FRAME_LEN - HOP_LEN;

    reg [I_BW - 1 : 0] shift_reg [(FIFO_DEPTH -1):0];

    integer enque_addr;
    integer deque_addr;
    reg [($clog2(OUTPUT_TOTAL_DATA)-1):0] out_num_tmp;
    integer i;

    assign out_num = out_num_tmp -1;
    
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            enque_addr <= 0;
            deque_addr <= 0;
            do_en <= 0;
            out_num_tmp <= 0;
            data_o <= 0;
            for (i=0; i<FIFO_DEPTH; i=i+1) begin
                shift_reg[i] <= 0;
            end
        end
        else if (in_num<160 & di_en==1) begin
            do_en <= di_en;
            data_o <= data_i;
            enque_addr <= 0;
            deque_addr <= 0;
            out_num_tmp <= out_num_tmp+di_en;
            for (i=0; i<FIFO_DEPTH; i=i+1) begin
                shift_reg[i] <= shift_reg[i];
            end
        end
        else if (in_num>=160 & in_num<1024 & di_en==1) begin
            do_en <= di_en;
            data_o <= data_i;
            for (i=0; i<FIFO_DEPTH; i=i+1) begin
                shift_reg[i] <= shift_reg[i];
            end
            shift_reg[enque_addr] <= data_i;
            enque_addr <= enque_addr+1;
            deque_addr <= 0;
            out_num_tmp <= out_num_tmp+di_en;  
        end
        else if (in_num>=1024 & in_num%1024<160 & di_en==1) begin
            do_en <= di_en;
            data_o <= shift_reg[deque_addr%FIFO_DEPTH];
            for (i=0; i<FIFO_DEPTH; i=i+1) begin
                shift_reg[i] <= shift_reg[i];
            end
            shift_reg[enque_addr%FIFO_DEPTH] <= data_i;
            enque_addr <= enque_addr + 1;   
            deque_addr <= deque_addr + 1;
            out_num_tmp <= out_num_tmp+di_en;
        end
        else if (in_num>=1024 & in_num%1024>=160 & di_en==2) begin
            do_en <= 1;
            data_o <= shift_reg[deque_addr%FIFO_DEPTH];
            for (i=0; i<FIFO_DEPTH; i=i+1) begin
                shift_reg[i] <= shift_reg[i];
            end 
            enque_addr <= enque_addr; 
            deque_addr <= deque_addr+1;
            out_num_tmp <= out_num_tmp+1;
        end
        else begin
            do_en <= 0;
            enque_addr <= enque_addr;
            deque_addr <= deque_addr;
            out_num_tmp <= out_num_tmp;
            for (i=0; i<FIFO_DEPTH; i=i+1) begin
                shift_reg[i] <= shift_reg[i];
            end
        end
    end

endmodule