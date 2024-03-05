`timescale	1ns/1ns

module squared #(
    parameter I_BW=14,
    parameter O_BW=26
)(
    input clk,
    input rst,
    input signed [I_BW-1:0] data_i,
    output signed [O_BW-1:0] data_o,
);
    // wire signed [2*I_BW-1:0] multiplied;
    
    assign data_o = data_i * data_i; 
    // always @(posedge clk or negedge rst) begin
    //     if (!rst) begin
    //         do_en <= 0;
    //         data_o <= 0;
    //         out_group_idx <= 0;
    //         out_group_num <= 0;
    //         is_first_out <= 0;
    //         is_last_out <= 0;
    //     end
    //     else if (di_en) begin
    //         do_en <= di_en;
    //         data_o <= multiplied;
    //         out_group_idx <= in_group_idx;
    //         out_group_num <= in_group_num;
    //         is_first_out <= is_first_in;
    //         is_last_out <= is_first_out;
    //     end else begin
    //         do_en <= 0;
    //     end
    // end

    // always @(posedge clk) begin
    //     if (di_en==1 | do_en==1) begin
    //     //   $display("in_group_idx=%d, di_en=%b, data_i=%b, out_group_idx=%d, do_en=%b, data_o=%b", in_group_idx, di_en, data_i, out_group_idx, do_en, data_o);            
    //     end
    //     // $display("in_group_idx=%d, di_en=%b, data_i=%b, out_group_idx=%d, do_en=%b, data_o=%b", in_group_idx, di_en, data_i, out_group_idx, do_en, data_o);            
    // end
endmodule