`timescale	1ns/1ns
module flow_control # (
    parameter I_BW =14,
    parameter O_BW = 14,
    parameter TOTAL_DATA = 5696 // 89*64
)(
    input clk,
    input rst,
    input di_en,
    input signed [I_BW*64-1:0] data_i,
    input [6:0] in_group_num, // 0-88
    output reg do_en,
    output reg signed [O_BW-1:0] data_o,
    output reg [9:0] out_group_idx, // 0-512
    output reg [6:0] out_group_num // 0-88
);

    reg [31:0] clk_counter; // for debug
    reg [I_BW*64*2-1:0] ctrl_buffer;
    reg [6:0] enque_addr; // 0-127
    integer i;

    reg [3:0] wait_time; // 0-8
    reg [6:0] initial_wait; // 0-90 & 100

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            wait_time <= 8;
            initial_wait <= 100;          
        end begin
            if (initial_wait>0 & initial_wait<=90) begin
                initial_wait=initial_wait-1;
            end     
            else if (initial_wait==0) begin
                wait_time <= wait_time-1;
            end     
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            do_en <= 0;
            enque_addr <= 0;
        end
        else begin
            if (di_en) begin
                if (initial_wait>0) begin
                    initial_wait <= 90;
                end
                if (in_group_num%2==0) begin
                    ctrl_buffer[I_BW*64*2-1:I_BW*64] <= data_i;
                end else begin
                    ctrl_buffer[I_BW*64-1:0] <= data_i;
                end
            end
            if (wait_time==0) begin
                for (i=0; i<I_BW; i=i+1) begin
                    data_o_tmp[i] = ctrl_buffer[(127-enque_addr)*18+i];
                end
                data_o <= data_o_tmp;
                do_en <= 1;
                out_group_num <= in_group_num;
                out_group_idx <= enque_addr;
                wait_time <= 8;
                enque_addr <= (enque_addr+1)%128;
            end
            else begin
                do_en <= 0;
            end
            
        end
    end

endmodule