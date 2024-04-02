`timescale	1ns/1ns
module tb_mel_filter;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam TOTAL_DATA = 32832;

    reg clk;
    reg rst;
    reg signed [I_BW-1:0] in;
    reg di_en;
    wire signed [O_BW*64-1:0] out;
    wire do_en;

    wire [($clog2(TOTAL_DATA)-1):0] in_num;
    reg [($clog2(TOTAL_DATA)-1):0] in_num_tmp;
    wire [9:0] in_group_idx; // 0-512
    wire [6:0] in_group_num; // 0-88
    wire [6:0] out_group_num;
    wire is_last_in;

    assign in_num = in_num_tmp -1;
    assign in_group_idx = in_num % 513;
    assign in_group_num = in_num / 513;
    assign is_first_in = ((in_num % 513) == 0);
    assign is_last_in = ((in_num % 513) == 512);

    //----------------------------------------------------------------------
    //	Clock and Reset
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

    mel_filter #(
       .I_BW(I_BW),
       .O_BW(O_BW)
    ) mel(
        .clk(clk),
        .rst(rst),
        .in_group_idx(in_group_idx), // 0-512
        .data_i(in),
        .in_group_num(in_group_num), // 0-88
        .di_en(di_en),
        .is_first_in(is_first_in),
        .is_last_in(is_last_in),
        .data_o(out),
        .do_en(do_en),
        .out_group_num(out_group_num)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            di_en <= 0;
            in_num_tmp <= 0;
        end
        else begin
            di_en <= 1;
            in_num_tmp <= in_num_tmp +1;
            in <= 1000;
        end
    end

    always @(posedge clk) begin
        $display("in_group_num=%d, in_group_idx=%d, di_en=%b, is_last_in=%b, do_en=%b, out[895:882]=%d, out[881:868]=%d, out[13:0]=%d", in_group_num, in_group_idx, di_en, is_last_in, do_en, out[895:882], out[881:868], out[13:0]);
    end

    //----------------------------------------------------------------------
    //	Test Stimuli
    //----------------------------------------------------------------------
    initial begin : STIM
        wait (rst == 1);
        // wait (reset == 0);
        repeat(10) @(posedge clk);
        repeat(TOTAL_DATA) @(posedge clk);
        repeat(10) @(posedge clk);
        $finish;
    end

    initial begin : TIMEOUT
        repeat(100000000) #20;	//  1000 Clock Cycle Time
        // repeat(1000) #20;	//  1000 Clock Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

endmodule