module counter# (
    parameter I_BW         = 14,
    parameter O_BW         = 14,  
    parameter MEMBER_NUM    = 1024, // number of elements composing a group
)(
    input clk,
    input rst,
    input di_en,
    input [I-BW-1:0] data_i,
    output reg do_en,
    output data_o,
    output [9:0] group_idx, // 0-1023
    output [6:0] group_num // 0-88 
);
    assign group_idx = count % 1024;
    assign group_num = count / 1024;

    integer count;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;
            do_en <= 0;
            group_num <= 0;
            group_idx <= 0;
        end
        else if (di_en) begin
            data_o <= data_i;
            count <= count+1;
            do_en <= 1;
        end 
    end
endmodule