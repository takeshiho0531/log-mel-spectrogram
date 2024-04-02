`timescale	1ns/1ns
module tb_framing;
    localparam INPUTLENGTH = 14;
    localparam OUTPUTLENGTH = 14;
    localparam TOTAL_DATA = 15104;
    localparam OUTPUT_TOTAL_DATA = 91136;

    reg clk;
    reg rst;
    wire signed [INPUTLENGTH-1:0] in;
    reg signed [INPUTLENGTH - 1 : 0] n;
    reg [1:0] di_en; // 0:invalid, 1:ok, 2:input wait time
    reg [$clog2(TOTAL_DATA)-1:0] in_num_tmp;
    wire [$clog2(TOTAL_DATA)-1:0] in_num;

    wire signed [OUTPUTLENGTH-1:0] out;
    wire do_en;
    wire [($clog2(OUTPUT_TOTAL_DATA)-1):0] out_num;

    integer t_clk;

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

    task GenerateInputWave;
        begin

            while (n < TOTAL_DATA) begin
                if (t_clk < 1024) begin
                    di_en <= 1;
                    n <= n+1;
                    in_num_tmp <= in_num_tmp + 1;
                    t_clk <= t_clk +1;
                end
                else if ((t_clk % 1024) < 160) begin
                    di_en <= 1;
                    n <= n+1;
                    in_num_tmp <= in_num_tmp + 1;
                    t_clk <= t_clk +1;
                end     
                else if ((t_clk % 1024) >= 160) begin
                    di_en <= 2;
                    n <= n;
                    in_num_tmp <= in_num_tmp;
                    t_clk <= t_clk +1;
                end       
                else begin
                    di_en <= 0;
                    n <= n;
                    t_clk <= t_clk +1;
                end
                @(posedge clk);
            end
        end
    endtask

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            di_en <= 0;
            n = 0;
            t_clk = 0;
            in_num_tmp = 0; 
        end
        else begin
            if (t_clk < 1024) begin
                di_en <= 1;
                n <= n+1;
                in_num_tmp <= in_num_tmp + 1;
                t_clk <= t_clk +1;
            end
            else if ((t_clk % 1024) < 160) begin
                di_en <= 1;
                n <= n+1;
                in_num_tmp <= in_num_tmp + 1;
                t_clk <= t_clk +1;
            end     
            else if ((t_clk % 1024) >= 160) begin
                di_en <= 2;
                n <= n;
                in_num_tmp <= in_num_tmp;
                t_clk <= t_clk +1;
            end       
            else begin
                di_en <= 0;
                n <= n;
                t_clk <= t_clk +1;
            end
        end
    end


    assign in = n-1;
    // assign in_num = in_num_tmp -1;
    assign in_num = t_clk -1;


    framing #(
        .TOTAL_DATA(TOTAL_DATA),
        .I_BW(INPUTLENGTH),
        .O_BW(OUTPUTLENGTH)
    ) frame (
    .clk(clk),
    .rst(rst),
    .data_i(in),
    .di_en(di_en),
    .in_num(in_num),
    .data_o(out),
    .do_en(do_en),
    .out_num(out_num)
    );
    
    // always @(posedge clk or negedge rst) begin
    //     $display("t_clk=%d, di_en=%d, in=%d, in_num=%d, do_en=%d, out=%d, out_num=%d",t_clk, di_en, in, in_num, do_en, out, out_num);
    // end

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


endmodule