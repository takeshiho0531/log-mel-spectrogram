`timescale	1ns/1ns
module t_hann_window;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam TOTAL_DATA = 91136;
    localparam FRAME_LEN = 1024;

    reg clk;
    reg rst;
    reg signed [I_BW-1:0] in;
    reg di_en;
    wire signed [O_BW-1:0] out;
    wire do_en;

    wire [($clog2(TOTAL_DATA)-1):0] in_num;
    reg [($clog2(TOTAL_DATA)-1):0] in_num_tmp;
    wire [($clog2(FRAME_LEN)-1):0] out_group_idx;
    wire [$clog2(TOTAL_DATA/FRAME_LEN):0] out_group_num;

    //----------------------------------------------------------------------
    //	clk and rst
    //----------------------------------------------------------------------
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        rst = 0; #20;
        rst = 1; #1215752192;
        rst = 0;
    end

    //----------------------------------------------------------------------
    //	Functional Blocks
    //----------------------------------------------------------------------

    //	Input Control Initialize
    initial begin
        wait (rst == 1);
        di_en = 0;
    end

    //----------------------------------------------------------------------
    //	Tasks
    //----------------------------------------------------------------------

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            di_en <= 0;
            in_num_tmp <= 0;
        end
        else begin
            di_en <= 1;
            in_num_tmp <= in_num_tmp+1;
            in <= -8000;
        end
    end

    assign in_num = in_num_tmp -1;

    hann_window #(
        .I_BW(I_BW),
        .O_BW(O_BW),
        .FRAME_LEN(FRAME_LEN),
        .TOTAL_DATA(TOTAL_DATA)
    )
    window(
        .clk(clk),
        .rst(rst),
        .data_i(in),
        .in_num(in_num),
        .di_en(di_en),
        .data_o(out),
        .do_en(do_en),
        .out_group_idx(out_group_idx),
        .out_group_num(out_group_num)
    );

    //----------------------------------------------------------------------
    //	Test Stimuli
    //----------------------------------------------------------------------
    initial begin : STIM
        wait (rst == 1);
        // wait (rst == 0);
        repeat(10) @(posedge clk);
        repeat(TOTAL_DATA) @(posedge clk);
        $finish;
    end
    initial begin : TIMEOUT
        repeat(100000000) #20;	//  1000 clk Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end


    always @ (posedge clk)begin
        $display("di_en=%b, in_num=%d, in=%d, do_en=%b, out=%d, out_group_idx=%d, out_group_num=%d", di_en, in_num, in, do_en, out, out_group_idx, out_group_num);
      end
endmodule