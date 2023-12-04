module t_FFT # ();
    localparam = 1024;
    localparam NN = 10; // log2(1024)

    reg clock;
    reg reset;
    reg di_en;
    reg [13:0] di_re;
    reg [13:0] di_re;
    wire do_en;
    wire [13:0] do_re;
    wire [15:0] do_im;

    reg [13:0] imem[0:19]
    reg [13:0] omem[0:19]

    // clock and reset
    always begin
        clock = 0; #10;
        clock = 1; #10;
    end

    initial begin
        reset = 0; #20;
        reset = 1; #100;
        reset = 0;
    end

    // FUnctional Block
    // Input control initialize
    initial begin
        wait (reset == 1);
        di_en = 0;
    end

    // output data capture
    initial begin
        integer n;
        forever begin
            n = 0;
            while (do_en !== 1) @(negedge clock);
            while ((do_en == 1) && (n < N)) begin
                omem[2*n] = do_en;
                omem[2*n+1] = do_im;
                n = n+1;
                @(negedge clock);
            end
        end
    end

    // task
    task LoadInputData;
        input [80*8:1] filename;
        begin
            $readmemh(filename, imem);
        end
    endtask

    task GenerateInputWave;
        integer n;
        begin
            di_en <= 1;
            for (n =0; n<N; n = n+1) begin
                di_re <= imem[2*n];
                di_im <= imem[2*n+1];
                @(posedge clock);
            end
            di_en <= 0;
            di_re <= 'bx;
            di_im <= 'bx;
        end
    endtask;

    task SaveOutputData;
        input [80*8:1] filename;
        integer fp, n, m, i;
        begin
            fp = $fopen(filename);
            m = 0;
            for (n =0;n<N;n=n+1) begin
                for (i=0; i < NN; i=i+1) m[NN-1-i] = n[i];
                $fdisplay(fp, "%h  %h  // %d", omem[2*m], omem[2*m+1], n[NN-1:0]);
            end
            $fclose(fp);
        end
    endtask;

    FFT FFT (
	.clock	(clock	),	//	i
	.reset	(reset	),	//	i
	.di_en	(di_en	),	//	i
	.di_re	(di_re	),	//	i
	.di_im	(di_im	),	//	i
	.do_en	(do_en	),	//	o
	.do_re	(do_re	),	//	o
	.do_im	(do_im	)	//	o
    );

    // include stimuli
    `include "stim.v"

endmodule