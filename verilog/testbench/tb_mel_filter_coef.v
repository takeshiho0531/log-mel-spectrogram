`timescale	1ns/1ns
module tb_mel_filter_coef;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam TOTAL_DATA = 32832; // 513*64

    reg clk;
    reg rst;
    reg di_en;
    wire signed [I_BW-1:0] in;
    reg [$clog2(TOTAL_DATA)-1:0] filter_v_tmp;
    wire [9:0] filter_v;

    wire signed [O_BW-1:0] out;
    wire [O_BW*64-1:0] coef;
    reg signed [O_BW-1:0] section;
    wire do_en;
    wire [9:0] out_filter_v;

    assign in = 1000;

    assign filter_v = (filter_v_tmp -1)%513;
    
    integer i;
    integer j;

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

    mel_filter_coef mel(
        .clk(clk),
        .rst(rst),
        .filter_v(filter_v),
        .data_i(in),
        .di_en(di_en),
        .coef(coef),
        .data_o(out),
        .do_en(do_en),
        .out_filter_v(out_filter_v)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            di_en <= 0;
            filter_v_tmp <= 0;
        end
        else begin
            di_en <= 1;
            filter_v_tmp <= filter_v_tmp +1;
        end
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
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

    always @(posedge clk) begin
        // $display("di_en=%b, filter_v=%d, do_en=%b, out_filter_v=%d, coef=%b", di_en, filter_v, do_en, out_filter_v, coef);          
    end

    always @(posedge clk) begin
        for (i=0; i<64; i=i+1) begin
            for (j=0; j<O_BW; j=j+1) begin
                section[j]=coef[O_BW*(63-i)+j];
            end   
            if (section!=0) begin
                $display("out_filter_v=%d: ,i=%d: section=%d, section=%b",out_filter_v, i, section, section);
            end  
            section = 0;   
        end
    end
endmodule