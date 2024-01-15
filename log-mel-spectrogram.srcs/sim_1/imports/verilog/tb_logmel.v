`timescale	1ns/1ns
module TB;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam N = 1024;
    localparam IN_N = 1024; // 
    localparam OUT_N = 1024; //

    reg clk;
    reg rst;
    reg [1:0] di_en;
    reg signed [I_BW-1:0] data_i;
    wire signed [O_BW-1:0] data_o;
    wire do_en;

    reg [I_BW-1:0]	imem[0:IN_N-1];
    reg [O_BW-1:0]	omem[0:OUT_N-1];

    //----------------------------------------------------------------------
    //	Clock and Reset
    //----------------------------------------------------------------------
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin
        rst = 1; #20;
        rst = 0; #100;
        rst = 1;
    end

    //----------------------------------------------------------------------
    //	Functional Blocks
    //----------------------------------------------------------------------

    //	Input Control Initialize
    initial begin
        wait (rst == 0);
        di_en = 0;
    end

    //	Output Data Capture
    initial begin : OCAP
        integer 	n;
        forever begin
            n = 0;
            while (do_en !== 1) @(negedge clk);
            while ((do_en == 1) && (n < OUT_N)) begin
                omem[n] = data_o;
                n = n+1;
                @(negedge clk);
            end
        end
    end

    //----------------------------------------------------------------------
    //	Tasks
    //----------------------------------------------------------------------
    task LoadInputData;
        input[80*8:1]	filename;
    begin
        $readmemb(filename, imem);
    end
    endtask

    task GenerateInputWave;
        reg [31:0] n;
        reg [31:0] t_clk;
    begin
        t_clk <= 0;
        di_en <= 0;
        // for (n = 0; n < IN_N; n = n + 1) begin
        //     data_i <= imem[n];
        //     @(posedge clk);
        // end

        n <= 0;
        while (n<IN_N) begin
            if (t_clk < 1024) begin
                di_en <= 1;
                t_clk <= t_clk+1;
                data_i <= imem[n];
                n <= n+1;
            end
            else if ((t_clk % 1024) < 160) begin
                di_en <= 1;
                t_clk <= t_clk +1;
                data_i <= imem[n];
                n <= n+1;
            end
            else if ((t_clk % 1024) >= 160) begin
                di_en <= 2;
                t_clk <= t_clk+1;
                data_i <= imem[n];
                n <= n;
            end
            else begin
                di_en <= 0;
                t_clk <= t_clk + 1;
                data_i <= imem[n];
                n <= n;
            end
        end
        di_en <= 0;
        data_i <= 'bx;
    end
    endtask

    task SaveOutputData;
        input[80*8:1]	filename;
        integer			fp, n, i;
    begin
        fp = $fopen(filename);
        for (n = 0; n < OUT_N; n = n + 1) begin
            $fdisplay(fp, "%b // %d", omem[n], n);
        end
        $fclose(fp);
    end
    endtask

    //----------------------------------------------------------------------
    //	Module Instances
    //----------------------------------------------------------------------
    log_mel_spectrogram logmel(
        .clk(clk),
        .rst(rst),
        .di_en(di_en),
        .data_i(data_i),
        .do_en(do_en),
        .data_o(data_o)
    );

    //----------------------------------------------------------------------
    //	Test Stimuli
    //----------------------------------------------------------------------
    initial begin : STIM
        wait (rst == 0);
        wait (rst == 1);
        repeat(10) @(posedge clk);

        fork
            begin
                LoadInputData("input.txt");
                GenerateInputWave;
                @(posedge clk);
            end
            begin
                wait (do_en == 1);
                repeat(1024) @(posedge clk);
                SaveOutputData("output.txt");
            end
        join

        repeat(10) @(posedge clk);
        $finish;
    end
    initial begin : TIMEOUT
        repeat(10000) #20;	//  1000 Clock Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

endmodule