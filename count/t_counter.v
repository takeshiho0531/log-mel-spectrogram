`timescale	1ns/1ns
module t_counter;
    localparam INPUTLENGTH = 14;
    localparam TOTAL_DATA = 15104;
    localparam OUTPUTLENGTH = 14;

    reg clk;
    reg rst;
    reg di_en;
    reg [INPUTLENGTH-1:0] in;

    wire [OUTPUTLENGTH-1:0] out;
    wire do_en;
    wire [$clog2(TOTAL_DATA)-1:0] num;

    //----------------------------------------------------------------------
    //	clk and rst
    //----------------------------------------------------------------------
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        rst = 0; #2;
        rst = 1; #1215752192;
        // rst = 0;
        // forever rst = 1;
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
            in <= 0;
        end
        else begin
            di_en <= 1;
            in <= in + 1;
        end
    end


    counter count(
        .clk(clk),
        .rst(rst),
        .di_en(di_en),
        .data_i(in),
        .do_en(do_en),
        .data_o(out),
        .num(num)
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
        repeat(100100) #20;	//  1000 clk Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

    always @(posedge clk) begin
        $display("di_en=%b, in=%d, do_en=%b, out=%d, num=%d", di_en, in, do_en, out, num);
    end

endmodule