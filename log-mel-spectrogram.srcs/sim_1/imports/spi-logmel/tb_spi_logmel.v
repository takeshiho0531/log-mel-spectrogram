`timescale	1ns/1ns
module TB_SPI;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam N = 1024;
    // localparam IN_N = 15104; // 88*160+1023*1=15104
    localparam IN_N = 1024;
    // localparam OUT_N = 5696; // 64*89
    localparam OUT_N = 64;
    localparam OUT_N_PAIR = OUT_N/64;

    // テストベンチで使用する変数定義
    reg sys_clk;
    reg spi_clk;
    reg spi_cs;
    reg spi_mosi;
    wire spi_miso;
    wire spi_miso_en;
    reg rst_log;

    reg clk;
    reg rst;
    reg signed [I_BW-1:0] data_i;
    wire signed [O_BW*64-1:0] data_o;
    wire do_en;

    reg [I_BW-1:0]	imem[0:IN_N]; // 0行目のデータが採用されない設計になってしまってる
    reg [O_BW-1:0] omem[0:OUT_N-1];


    // BASIC Registersのダミー変数
    wire [13:0] REG_IN_A_000;
    wire [13:0] REG_IN_A_001;
    wire [13:0] REG_IN_A_002;
    wire [13:0] REG_IN_A_003;
    wire [13:0] REG_IN_A_004;
    wire [13:0] REG_IN_A_005;
    wire [13:0] REG_IN_A_006;
    wire [13:0] REG_IN_A_007;
    wire [13:0] REG_IN_A_008;
    wire [13:0] REG_IN_A_009;
    wire [13:0] REG_IN_A_010;
    wire [13:0] REG_IN_A_011;
    wire [13:0] REG_IN_A_012;
    wire [13:0] REG_IN_A_013;
    wire [13:0] REG_IN_A_014;
    wire [13:0] REG_IN_A_015;
    wire [13:0] REG_IN_A_016;
    wire [13:0] REG_IN_A_017;
    wire [13:0] REG_IN_A_018;
    wire [13:0] REG_IN_A_019;
    wire [13:0] REG_IN_A_020;
    wire [13:0] REG_IN_A_021;
    wire [13:0] REG_IN_A_022;
    wire [13:0] REG_IN_A_023;
    wire [13:0] REG_IN_A_024;
    wire [13:0] REG_IN_A_025;
    wire [13:0] REG_IN_A_026;
    wire [13:0] REG_IN_A_027;
    wire [13:0] REG_IN_A_028;
    wire [13:0] REG_IN_A_029;
    wire [13:0] REG_IN_A_030;
    wire [13:0] REG_IN_A_031;
    wire [13:0] REG_IN_A_032;
    wire [13:0] REG_IN_A_033;
    wire [13:0] REG_IN_A_034;
    wire [13:0] REG_IN_A_035;
    wire [13:0] REG_IN_A_036;
    wire [13:0] REG_IN_A_037;
    wire [13:0] REG_IN_A_038;
    wire [13:0] REG_IN_A_039;
    wire [13:0] REG_IN_A_040;
    wire [13:0] REG_IN_A_041;
    wire [13:0] REG_IN_A_042;
    wire [13:0] REG_IN_A_043;
    wire [13:0] REG_IN_A_044;
    wire [13:0] REG_IN_A_045;
    wire [13:0] REG_IN_A_046;
    wire [13:0] REG_IN_A_047;
    wire [13:0] REG_IN_A_048;
    wire [13:0] REG_IN_A_049;
    wire [13:0] REG_IN_A_050;
    wire [13:0] REG_IN_A_051;
    wire [13:0] REG_IN_A_052;
    wire [13:0] REG_IN_A_053;
    wire [13:0] REG_IN_A_054;
    wire [13:0] REG_IN_A_055;
    wire [13:0] REG_IN_A_056;
    wire [13:0] REG_IN_A_057;
    wire [13:0] REG_IN_A_058;
    wire [13:0] REG_IN_A_059;
    wire [13:0] REG_IN_A_060;
    wire [13:0] REG_IN_A_061;
    wire [13:0] REG_IN_A_062;
    wire [13:0] REG_IN_A_063;
    wire [13:0] REG_IN_B_000;
    wire [(14*64)-1:0] REG_OUT_A_000;
    wire [13:0] REG_OUT_B_000;

    //----------------------------------------------------------------------
    //	Clock and Reset
    //----------------------------------------------------------------------
    parameter CYCLE = 100;
    always #(CYCLE/2) clk = ~clk; // generate clk.

    initial begin
        rst = 1; #100;
        rst = 0; #100;
        rst = 1;
    end

    //----------------------------------------------------------------------
    //	Functional Blocks
    //----------------------------------------------------------------------

    // //	Input Control Initialize
    // initial begin
    //     wait (rst == 0);
    //     di_en = 0;
    // end

    //	Output Data Capture
    initial begin : OCAP
        integer n;
        integer i;
        integer j;
        reg signed [O_BW-1:0] data_o_partial;
        n <= 0;
        forever begin
            while (do_en !== 1) @(negedge clk);
            while ((do_en == 1) && (n < OUT_N_PAIR)) begin
                for (i=0; i<64; i=i+1) begin
                    for (j=0; j<O_BW; j=j+1) begin
                        data_o_partial[j] = data_o[i*O_BW+j];
                    end
                    omem[n*64+i] = data_o_partial;
                end
                n <= n+1;
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

    // クロック信号の生成
    initial begin
        sys_clk = 0;
        forever #10 sys_clk = ~sys_clk; // 50MHzでシステムクロックを生成
    end

    initial begin
        spi_clk = 0;
        forever #50 spi_clk = ~spi_clk; // 10MHzでSPIクロックを生成
    end

    task GenerateInputWave;
        integer n;
        integer t_clk;
    begin
        t_clk = 0;
        // di_en <= 0;

        n = 0;
        // すべての信号をリセット
        spi_cs = 1;
        spi_mosi = 0;

        clk = 1'b0;

        // リセット解除
        #100;
        #100;
        rst_log <= 1'b1;

        // SPI通信のテストシーケンス
        spi_cs = 1'b0; // チップセレクトをアクティブに
        // send_spi_byte(40'b1111111111111111000000000000000000000001); // flagをB_000に。
        // Input data for one line;
        send_spi_byte(40'b1111111111111111100000000000000000000001); // 推論モードに。

        // 0個目
        data_i <= imem[0];
        send_spi_byte({1'b1, 15'd0, 1'b1, 9'b0, imem[0][13:0]});
        // 1個目
        data_i <= imem[1];
        send_spi_byte({1'b1, 15'd1, 1'b1, 9'b0, imem[1][13:0]});
        // 2個目
        data_i <= imem[2];
        send_spi_byte({1'b1, 15'd2, 1'b1, 9'b0, imem[2][13:0]});
        // 3個目
        data_i <= imem[3];
        send_spi_byte({1'b1, 15'd3, 1'b1, 9'b0, imem[3][13:0]});
        // 4個目
        data_i <= imem[4];
        send_spi_byte({1'b1, 15'd4, 1'b1, 9'b0, imem[4][13:0]});
        // 5個目
        data_i <= imem[5];
        send_spi_byte({1'b1, 15'd5, 1'b1, 9'b0, imem[5][13:0]});
        // 6個目
        data_i <= imem[6];
        send_spi_byte({1'b1, 15'd6, 1'b1, 9'b0, imem[6][13:0]});
        // 7個目
        data_i <= imem[7];
        send_spi_byte({1'b1, 15'd7, 1'b1, 9'b0, imem[7][13:0]});
        // 8個目
        data_i <= imem[8];
        send_spi_byte({1'b1, 15'd8, 1'b1, 9'b0, imem[8][13:0]});
        // 9個目
        data_i <= imem[9];
        send_spi_byte({1'b1, 15'd9, 1'b1, 9'b0, imem[9][13:0]});
        // 10個目
        data_i <= imem[10];
        send_spi_byte({1'b1, 15'd10, 1'b1, 9'b0, imem[10][13:0]});
        // 11個目
        data_i <= imem[11];
        send_spi_byte({1'b1, 15'd11, 1'b1, 9'b0, imem[11][13:0]});
        // 12個目
        data_i <= imem[12];
        send_spi_byte({1'b1, 15'd12, 1'b1, 9'b0, imem[12][13:0]});
        // 13個目
        data_i <= imem[13];
        send_spi_byte({1'b1, 15'd13, 1'b1, 9'b0, imem[13][13:0]});
        // 14個目
        data_i <= imem[14];
        send_spi_byte({1'b1, 15'd14, 1'b1, 9'b0, imem[14][13:0]});
        // 15個目
        data_i <= imem[15];
        send_spi_byte({1'b1, 15'd15, 1'b1, 9'b0, imem[15][13:0]});
        // 16個目
        data_i <= imem[16];
        send_spi_byte({1'b1, 15'd16, 1'b1, 9'b0, imem[16][13:0]});
        // 17個目
        data_i <= imem[17];
        send_spi_byte({1'b1, 15'd17, 1'b1, 9'b0, imem[17][13:0]});
        // 18個目
        data_i <= imem[18];
        send_spi_byte({1'b1, 15'd18, 1'b1, 9'b0, imem[18][13:0]});
        // 19個目
        data_i <= imem[19];
        send_spi_byte({1'b1, 15'd19, 1'b1, 9'b0, imem[19][13:0]});
        // 20個目
        data_i <= imem[20];
        send_spi_byte({1'b1, 15'd20, 1'b1, 9'b0, imem[20][13:0]});
        // 21個目
        data_i <= imem[21];
        send_spi_byte({1'b1, 15'd21, 1'b1, 9'b0, imem[21][13:0]});
        // 22個目
        data_i <= imem[22];
        send_spi_byte({1'b1, 15'd22, 1'b1, 9'b0, imem[22][13:0]});
        // 23個目
        data_i <= imem[23];
        send_spi_byte({1'b1, 15'd23, 1'b1, 9'b0, imem[23][13:0]});
        // 24個目
        data_i <= imem[24];
        send_spi_byte({1'b1, 15'd24, 1'b1, 9'b0, imem[24][13:0]});
        // 25個目
        data_i <= imem[25];
        send_spi_byte({1'b1, 15'd25, 1'b1, 9'b0, imem[25][13:0]});
        // 26個目
        data_i <= imem[26];
        send_spi_byte({1'b1, 15'd26, 1'b1, 9'b0, imem[26][13:0]});
        // 27個目
        data_i <= imem[27];
        send_spi_byte({1'b1, 15'd27, 1'b1, 9'b0, imem[27][13:0]});
        // 28個目
        data_i <= imem[28];
        send_spi_byte({1'b1, 15'd28, 1'b1, 9'b0, imem[28][13:0]});
        // 29個目
        data_i <= imem[29];
        send_spi_byte({1'b1, 15'd29, 1'b1, 9'b0, imem[29][13:0]});
        // 30個目
        data_i <= imem[30];
        send_spi_byte({1'b1, 15'd30, 1'b1, 9'b0, imem[30][13:0]});
        // 31個目
        data_i <= imem[31];
        send_spi_byte({1'b1, 15'd31, 1'b1, 9'b0, imem[31][13:0]});
        // 32個目
        data_i <= imem[32];
        send_spi_byte({1'b1, 15'd32, 1'b1, 9'b0, imem[32][13:0]});
        // 33個目
        data_i <= imem[33];
        send_spi_byte({1'b1, 15'd33, 1'b1, 9'b0, imem[33][13:0]});
        // 34個目
        data_i <= imem[34];
        send_spi_byte({1'b1, 15'd34, 1'b1, 9'b0, imem[34][13:0]});
        // 35個目
        data_i <= imem[35];
        send_spi_byte({1'b1, 15'd35, 1'b1, 9'b0, imem[35][13:0]});
        // 36個目
        data_i <= imem[36];
        send_spi_byte({1'b1, 15'd36, 1'b1, 9'b0, imem[36][13:0]});
        // 37個目
        data_i <= imem[37];
        send_spi_byte({1'b1, 15'd37, 1'b1, 9'b0, imem[37][13:0]});
        // 38個目
        data_i <= imem[38];
        send_spi_byte({1'b1, 15'd38, 1'b1, 9'b0, imem[38][13:0]});
        // 39個目
        data_i <= imem[39];
        send_spi_byte({1'b1, 15'd39, 1'b1, 9'b0, imem[39][13:0]});
        // 40個目
        data_i <= imem[40];
        send_spi_byte({1'b1, 15'd40, 1'b1, 9'b0, imem[40][13:0]});
        // 41個目
        data_i <= imem[41];
        send_spi_byte({1'b1, 15'd41, 1'b1, 9'b0, imem[41][13:0]});
        // 42個目
        data_i <= imem[42];
        send_spi_byte({1'b1, 15'd42, 1'b1, 9'b0, imem[42][13:0]});
        // 43個目
        data_i <= imem[43];
        send_spi_byte({1'b1, 15'd43, 1'b1, 9'b0, imem[43][13:0]});
        // 44個目
        data_i <= imem[44];
        send_spi_byte({1'b1, 15'd44, 1'b1, 9'b0, imem[44][13:0]});
        // 45個目
        data_i <= imem[45];
        send_spi_byte({1'b1, 15'd45, 1'b1, 9'b0, imem[45][13:0]});
        // 46個目
        data_i <= imem[46];
        send_spi_byte({1'b1, 15'd46, 1'b1, 9'b0, imem[46][13:0]});
        // 47個目
        data_i <= imem[47];
        send_spi_byte({1'b1, 15'd47, 1'b1, 9'b0, imem[47][13:0]});
        // 48個目
        data_i <= imem[48];
        send_spi_byte({1'b1, 15'd48, 1'b1, 9'b0, imem[48][13:0]});
        // 49個目
        data_i <= imem[49];
        send_spi_byte({1'b1, 15'd49, 1'b1, 9'b0, imem[49][13:0]});
        // 50個目
        data_i <= imem[50];
        send_spi_byte({1'b1, 15'd50, 1'b1, 9'b0, imem[50][13:0]});
        // 51個目
        data_i <= imem[51];
        send_spi_byte({1'b1, 15'd51, 1'b1, 9'b0, imem[51][13:0]});
        // 52個目
        data_i <= imem[52];
        send_spi_byte({1'b1, 15'd52, 1'b1, 9'b0, imem[52][13:0]});
        // 53個目
        data_i <= imem[53];
        send_spi_byte({1'b1, 15'd53, 1'b1, 9'b0, imem[53][13:0]});
        // 54個目
        data_i <= imem[54];
        send_spi_byte({1'b1, 15'd54, 1'b1, 9'b0, imem[54][13:0]});
        // 55個目
        data_i <= imem[55];
        send_spi_byte({1'b1, 15'd55, 1'b1, 9'b0, imem[55][13:0]});
        // 56個目
        data_i <= imem[56];
        send_spi_byte({1'b1, 15'd56, 1'b1, 9'b0, imem[56][13:0]});
        // 57個目
        data_i <= imem[57];
        send_spi_byte({1'b1, 15'd57, 1'b1, 9'b0, imem[57][13:0]});
        // 58個目
        data_i <= imem[58];
        send_spi_byte({1'b1, 15'd58, 1'b1, 9'b0, imem[58][13:0]});
        // 59個目
        data_i <= imem[59];
        send_spi_byte({1'b1, 15'd59, 1'b1, 9'b0, imem[59][13:0]});
        // 60個目
        data_i <= imem[60];
        send_spi_byte({1'b1, 15'd60, 1'b1, 9'b0, imem[60][13:0]});
        // 61個目
        data_i <= imem[61];
        send_spi_byte({1'b1, 15'd61, 1'b1, 9'b0, imem[61][13:0]});
        // 62個目
        data_i <= imem[62];
        send_spi_byte({1'b1, 15'd62, 1'b1, 9'b0, imem[62][13:0]});
        // 63個目
        data_i <= imem[63];
        send_spi_byte({1'b1, 15'd63, 1'b1, 9'b0, imem[63][13:0]});

        rst_log <= 1'b0;

        // #500; // 10*50
        repeat(5) @(posedge clk);
        rst_log <= 1;

        // di_en <= 0;
        // data_i <= 'bx;
        // send_spi_byte(40'b1111111111111111100000000000000000000000); // 推論モードに。
        // #6500;
        // // send_spi_byte(40'b1111111111111111100000000000000000000000); // 推論モードに。
        // #608000;
        // #158800;
        repeat(1500) @(posedge clk);
        $display("chipselect");
        // spi_cs = 1'b1; // チップセレクトを非アクティブに
        // #500;
        // spi_cs = 1'b0;
        // send_spi_byte(40'b0000000000000000100000000000000000110100);
        // send_spi_byte(40'b0000000000000001100000000000000000000000);
        // spi_cs = 1'b1; // チップセレクトを非アクティブに
        // #800;
        repeat(1500) @(posedge clk);
        spi_cs = 1'b0;
        $finish;
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
    // spi_logicモジュールのインスタンス化
    wire [(14*64)-1:0] logmel_data_o;
    spi_logic spi_inst (
        .clk_in(clk),
        .sys_clk_in(sys_clk),
        .rst_n(rst),
        .rst_for_logmel(rst_log),
        .spi_clk_in(spi_clk),
        .spi_cs(spi_cs),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_miso_en(spi_miso_en),
        .REG_IN_A_000(REG_IN_A_000),
        .REG_IN_A_001(REG_IN_A_001),
        .REG_IN_A_002(REG_IN_A_002),
        .REG_IN_A_003(REG_IN_A_003),
        .REG_IN_A_004(REG_IN_A_004),
        .REG_IN_A_005(REG_IN_A_005),
        .REG_IN_A_006(REG_IN_A_006),
        .REG_IN_A_007(REG_IN_A_007),
        .REG_IN_A_008(REG_IN_A_008),
        .REG_IN_A_009(REG_IN_A_009),
        .REG_IN_A_010(REG_IN_A_010),
        .REG_IN_A_011(REG_IN_A_011),
        .REG_IN_A_012(REG_IN_A_012),
        .REG_IN_A_013(REG_IN_A_013),
        .REG_IN_A_014(REG_IN_A_014),
        .REG_IN_A_015(REG_IN_A_015),
        .REG_IN_A_016(REG_IN_A_016),
        .REG_IN_A_017(REG_IN_A_017),
        .REG_IN_A_018(REG_IN_A_018),
        .REG_IN_A_019(REG_IN_A_019),
        .REG_IN_A_020(REG_IN_A_020),
        .REG_IN_A_021(REG_IN_A_021),
        .REG_IN_A_022(REG_IN_A_022),
        .REG_IN_A_023(REG_IN_A_023),
        .REG_IN_A_024(REG_IN_A_024),
        .REG_IN_A_025(REG_IN_A_025),
        .REG_IN_A_026(REG_IN_A_026),
        .REG_IN_A_027(REG_IN_A_027),
        .REG_IN_A_028(REG_IN_A_028),
        .REG_IN_A_029(REG_IN_A_029),
        .REG_IN_A_030(REG_IN_A_030),
        .REG_IN_A_031(REG_IN_A_031),
        .REG_IN_A_032(REG_IN_A_032),
        .REG_IN_A_033(REG_IN_A_033),
        .REG_IN_A_034(REG_IN_A_034),
        .REG_IN_A_035(REG_IN_A_035),
        .REG_IN_A_036(REG_IN_A_036),
        .REG_IN_A_037(REG_IN_A_037),
        .REG_IN_A_038(REG_IN_A_038),
        .REG_IN_A_039(REG_IN_A_039),
        .REG_IN_A_040(REG_IN_A_040),
        .REG_IN_A_041(REG_IN_A_041),
        .REG_IN_A_042(REG_IN_A_042),
        .REG_IN_A_043(REG_IN_A_043),
        .REG_IN_A_044(REG_IN_A_044),
        .REG_IN_A_045(REG_IN_A_045),
        .REG_IN_A_046(REG_IN_A_046),
        .REG_IN_A_047(REG_IN_A_047),
        .REG_IN_A_048(REG_IN_A_048),
        .REG_IN_A_049(REG_IN_A_049),
        .REG_IN_A_050(REG_IN_A_050),
        .REG_IN_A_051(REG_IN_A_051),
        .REG_IN_A_052(REG_IN_A_052),
        .REG_IN_A_053(REG_IN_A_053),
        .REG_IN_A_054(REG_IN_A_054),
        .REG_IN_A_055(REG_IN_A_055),
        .REG_IN_A_056(REG_IN_A_056),
        .REG_IN_A_057(REG_IN_A_057),
        .REG_IN_A_058(REG_IN_A_058),
        .REG_IN_A_059(REG_IN_A_059),
        .REG_IN_A_060(REG_IN_A_060),
        .REG_IN_A_061(REG_IN_A_061),
        .REG_IN_A_062(REG_IN_A_062),
        .REG_IN_A_063(REG_IN_A_063),
        .logmel_do_en(do_en),
        .logmel_data_o(logmel_data_o),


        .REG_IN_B_000(REG_IN_B_000),
        .REG_OUT_A_000(REG_OUT_A_000),
        .REG_OUT_B_000(REG_OUT_B_000)
    );



    //----------------------------------------------------------------------
    //	Test Stimuli
    //----------------------------------------------------------------------
    initial begin : STIM
        integer k;

        wait (rst == 0);
        wait (rst == 1);
        repeat(10) @(posedge spi_clk);

        fork
            begin
                LoadInputData("input.txt");
                GenerateInputWave;
            end
            begin
                wait (do_en == 1);
                // repeat(OUT_N) @(posedge clk); //
                k = 0;
                // while (k < OUT_N_PAIR) begin
                while (k < OUT_N_PAIR+1) begin // 初めのk=1が無効
                    if (!rst) begin
                        k = 0;
                    end
                    else if (do_en) begin
                        k = k+1;
                        $display("k=%d", k);
                    end
                    else begin
                        k = k;
                    end
                    @(negedge clk);
                end
                $display("done");
                SaveOutputData("output.txt");
            end
        join

        repeat(10) @(posedge clk);
        $finish;
    end
    initial begin : TIMEOUT
        repeat(1000000000) #20;	//  1000 Clock Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

    // SPIバイトデータ送信タスク
    task send_spi_byte;
        input [39:0] data;
        integer i;
        begin
            for (i = 39; i >= 0; i = i - 1) begin
                @(posedge spi_clk); // SPIクロックの立ち上がりエッジでデータを送信
                spi_mosi = data[i]; // MSBファーストでデータビットを送信
            end
        end
    endtask

endmodule