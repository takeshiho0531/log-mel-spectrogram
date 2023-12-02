module t_framing;
    reg clk, rst_n;
    reg valid_i;
    reg valid_o;
    wire [15:0] data_i;
    reg [15:0] data_i_mem[0:16000];
    reg [16:0] data_o;
    reg [31:0] counter;
    reg last_o;

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
    end

    always @(negedge rst_n or posedge clk) begin
        if (rst_n == 0) counter <= 0;// ???
        else if (clk == 1) begin
            counter <= counter + 1;
        end
    end

    assign data_i = data_i_mem[counter];

    initial
        $monitor($stime, "rst_n = %b, clk = %b, valid_i = %b, counter = %d, data_i = %b, valid_o = %b, data_o =%b, last_o =%b",
            rst_n, clk, valid_i, counter, data_i, valid_o, data_o, last_o);

    framing #(.I_BW(16), .O_BW(23), .FRAME_LEN(256), .CANDENCE_CYC(3), .SKIP_ELEMS(0))
    framing_test(.clk_i(clk), .rst_n_i(rst_n), .data_i(data_i), .valid_i(valid_i), .data_o(data_o), .valid_o(valid_o), .last_o(last_o));
endmodule