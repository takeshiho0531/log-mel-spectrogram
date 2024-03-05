`timescale	1ns/1ns
module t_squared;
    localparam I_BW = 14;
    localparam O_BW = 28;
    localparam TOTAL_DATA = 300;

    reg clk;
    reg rst;
    wire signed [I_BW-1:0] in;
    reg di_en;
    wire signed [O_BW-1:0] out;
    wire do_en;

    wire [($clog2(TOTAL_DATA)-1):0] in_num;
    reg [($clog2(TOTAL_DATA)-1):0] in_num_tmp;
    wire [9:0] in_group_idx; // 0-512
    reg [9:0] in_group_idx_tmp;
    wire [6:0] in_group_num; // 0-88
    wire [9:0] out_group_idx;
    wire [6:0] out_group_num;
    wire is_first_in;
    wire is_last_in;


    // wire [13:0] in_rom[0:2];

    // assign in_rom[0] = 14'b00000010010000;
    // assign in_rom[1] = 14'b00000000000010;
    // assign in_rom[2] = 14'b11111110111001;

    assign in_group_num = (in_num_tmp/513);
    assign in_group_idx = (in_num_tmp%513);
    assign is_first_in = (in_num_tmp==0);
    assign is_last_in = (in_num_tmp==TOTAL_DATA);
    assign in = in_num_tmp -(TOTAL_DATA/2);


    //----------------------------------------------------------------------
    //	Clock and Reset
    //----------------------------------------------------------------------
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

	initial begin
        rst = 0; #10;
        rst = 1;
	end

    //----------------------------------------------------------------------
    //	Functional Blocks
    //----------------------------------------------------------------------

    //	Input Control Initialize
    initial begin
        wait (rst == 1);
        di_en = 0;
        in_group_idx_tmp <= 0;
    end

    //----------------------------------------------------------------------
    //	Tasks
    //----------------------------------------------------------------------

    squared #(
       .I_BW(I_BW),
       .O_BW(O_BW)
    ) power(
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
        .out_group_idx(out_group_idx),
        .out_group_num(out_group_num)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            di_en <=0;
            in_num_tmp <= 0;
        end
        else begin
            di_en <= 1;
            in_num_tmp <= in_num_tmp+1;
        end
    end


    always @(posedge clk) begin
        $display("in_group_idx=%d, di_en=%b, in_num_tmp=%d, in=%d, out_group_idx=%d, do_en=%b, out=%d", in_group_idx, di_en, in_num_tmp, in, out_group_idx, do_en, out);
    end

    //----------------------------------------------------------------------
    //	Test Stimuli
    //----------------------------------------------------------------------
    initial begin : STIM
        integer i;
        wait (rst == 1);
        // wait (rst == 0);
        repeat(10) @(posedge clk);
        repeat(TOTAL_DATA) @(posedge clk);
        di_en <= 0;
        wait (do_en == 1);
        repeat(TOTAL_DATA) @(posedge clk);
        $finish;
    end

    initial begin : TIMEOUT
        repeat(10000) #20;	//  1000 clk Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

endmodule