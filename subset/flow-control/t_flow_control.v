`timescale	1ns/1ns
module t_flow_control;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam TOTAL_DATA = 32832;

    reg clk;
    reg rst;
    reg signed [I_BW*64-1:0] in;
    reg di_en;
    wire signed [O_BW-1:0] out;
    wire do_en;

    wire [($clog2(TOTAL_DATA)-1):0] in_num;
    reg [($clog2(TOTAL_DATA)-1):0] in_num_tmp;
    wire [6:0] in_group_num; // 0-88
    wire [6:0] out_group_num;
    wire [5:0] out_group_idx; // 0-64

    reg [31:0] clk_counter; // for debug

    assign in_num = in_num_tmp -1;
    assign in_group_idx = in_num % 513;
    assign in_group_num = in_num / 513;

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

    flow_control flow(
        .clk(clk),
        .rst(rst),
        .di_en(di_en),
        .data_i(in),
        .in_group_num(in_group_num),
        .do_en(do_en),
        .data_o(out),
        .out_group_idx(out_group_idx),
        .out_group_num(out_group_num)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            di_en <= 0;
            in_num_tmp <= 0;
            clk_counter <= 0;
        end
        else begin
            di_en <= (in_num%513==0);
            in_num_tmp <= in_num_tmp +1;
            in <= in_num;
        end
    end

    always @(posedge clk) begin
        clk_counter <= clk_counter+1;
        $display("clk_counter=%d, in_group_num=%d, di_en=%b, in=%d, do_en=%b, out=%d", clk_counter, in_group_num, di_en, in, do_en, out);
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