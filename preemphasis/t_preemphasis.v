module t_preemphasis;
    reg clk, rst_n;
    // reg en_i;
    reg valid_i;
    reg [31:0] counter = 0;
    reg [15:0] data_i_mem[0:16000];
    wire [15:0] data_i;
    wire [16:0] data_o;
    wire valid_o;

    initial
        $readmemb("indata1.dat", data_i_mem);

    initial begin
        clk = 0; forever #50 clk = !clk;
    end

    initial begin
        rst_n = 1; 
        #10 rst_n = 0; valid_i = 0;
        #20 rst_n = 1; valid_i = 0;
	#10 rst_n = 1; valid_i = 1;
        // #10 en_i = 1;
        // #30 en_i = 0;
    end

    always @(negedge rst_n or posedge clk) begin
        if (rst_n == 0) counter <= 0;// ???
        else if (clk == 1) begin
            counter <= counter + 1;
        end
    end

    initial
        $monitor($stime, "rst_n = %b, clk = %b, valid_i = %b, counter = %d, data_i = %b, valid_o = %b, data_o =%b",
            rst_n, clk, valid_i, counter, data_i, valid_o, data_o);

    assign data_i = data_i_mem[counter];

    preemphasis #(.I_BW(16), .O_BW(17)) preemphasis_test(.clk(clk), .rst_n(rst_n), .valid_i(valid_i), 
	.data_o(data_o), .valid_o(valid_o));
endmodule