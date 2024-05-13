`timescale	1ns/1ns
module log #(
    parameter I_BW = 30,
    parameter O_BW = 14,
    parameter SHIFT = 10
)(
    input signed [I_BW*64-1:0] data_i,
    output signed [O_BW*64-1:0] data_o
);

    function signed [O_BW-2:0] logE;
        input [I_BW-1:0] antilogarithm;
        integer value;
        integer i;
        integer j;
        integer logb2;
        begin
            logb2 = 0;
            value = antilogarithm;
            j = 0;
            for (i=0; i<I_BW; i= i+1) begin
                if (value>0) begin
                    value = value >>> 1;
                    j = j+1;
                end
                else begin
                    j = j;
                    // logb2 = j;
                    // logE = (logb2+SHIFT) * 5/7;
                end
                // $display("value=%d, logb2=%d, logE=%d", value, logb2, logE);
            end
            logb2 = j;
            logE = (logb2+SHIFT) * 5/7;
        end
        // $monitor("value=%d", value);
    endfunction

    function signed [O_BW*64-1:0] total_log;
        input signed [I_BW*64-1:0] total_input;
        integer i;
        integer j;
        integer k;
        reg signed [I_BW-1:0] tmp_i;
        reg signed [O_BW-1:0] tmp_o;

        for (i=0; i<64; i=i+1) begin
            for (j=0; j<I_BW; j=j+1) begin
                tmp_i[j] = total_input[i*I_BW+j];
            end
            tmp_o = logE(tmp_i);
            for (k=0; k<O_BW; k=k+1) begin
                total_log[i*O_BW+k] = tmp_o[k];
            end
        end
    endfunction

    assign data_o = total_log(data_i);

endmodule