//----------------------------------------------------------------------
//	TB: FftTop Testbench
//----------------------------------------------------------------------
`timescale	1ns/1ns
module TB #(
	parameter N = 1024
);

localparam NN=log2(N);

function integer log2;
	input integer x;
	integer value;
	begin
		value = x-1;
		for (log2=0; value>0; log2=log2+1)
			value = value>>1;
	end
endfunction

reg 		clock;
reg 		reset;
reg 		di_en;
reg [13:0]	di_re;
reg [13:0]	di_im;
wire		do_en;
wire[13:0]	do_re;
wire[13:0]	do_im;

reg [13:0]	imem[0:2*N-1];
reg [13:0]	omem[0:2*N-1];

//----------------------------------------------------------------------
//	Clock and Reset
//----------------------------------------------------------------------
always begin
	clock = 0; #10;
	clock = 1; #10;
end

initial begin
	reset = 1; #20;
	reset = 0; #100;
	reset = 1;
end

//----------------------------------------------------------------------
//	Functional Blocks
//----------------------------------------------------------------------

//	Input Control Initialize
initial begin
	wait (reset == 0);
	di_en = 0;
end

//	Output Data Capture
initial begin : OCAP
	integer 	n;
	forever begin
		n = 0;
		while (do_en !== 1) @(negedge clock);
		while ((do_en == 1) && (n < N)) begin
			omem[2*n  ] = do_re;
			omem[2*n+1] = do_im;
			n = n + 1;
			@(negedge clock);
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
	integer n;
begin
	di_en <= 1;
	for (n = 0; n < N; n = n + 1) begin
		di_re <= imem[2*n];
		di_im <= imem[2*n+1];
		@(posedge clock);
	end
	di_en <= 0;
	di_re <= 'bx;
	di_im <= 'bx;
end
endtask

task SaveOutputData;
	input[80*8:1]	filename;
	integer			fp, n, m, i;
begin
	fp = $fopen(filename);
	m = 0;
	for (n = 0; n < N; n = n + 1) begin
		for (i = 0; i < NN; i = i + 1) m[NN-1-i] = n[i];
		$fdisplay(fp, "%b  %b  // %d", omem[2*m], omem[2*m+1], n[NN-1:0]);
	end
	$fclose(fp);
end
endtask

//----------------------------------------------------------------------
//	Module Instances
//----------------------------------------------------------------------
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

//----------------------------------------------------------------------
//	Include Stimuli
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//	Test Stimuli
//----------------------------------------------------------------------
initial begin : STIM
	wait (reset == 0);
	wait (reset == 1);
	repeat(10) @(posedge clock);

	fork
		begin
			LoadInputData("input4.txt");
			GenerateInputWave;
			@(posedge clock);
			// LoadInputData("input5.txt");
			// GenerateInputWave;
		end
		begin
			wait (do_en == 1);
			repeat(1024) @(posedge clock);
			SaveOutputData("output4.txt");
			// @(negedge clock);
			// wait (do_en == 1);
			// repeat(64) @(posedge clock);
			// SaveOutputData("output5.txt");
		end
	join

	repeat(10) @(posedge clock);
	$finish;
end
initial begin : TIMEOUT
	repeat(10000) #20;	//  1000 Clock Cycle Time
	$display("[FAILED] Simulation timed out.");
	$finish;
end

endmodule