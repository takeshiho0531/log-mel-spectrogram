`timescale	1ns/1ns
module TB_SPI;
    localparam I_BW = 14;
    localparam O_BW = 14;
    localparam N = 1024;
    localparam IN_N = 15104; // 88*160+1023*1=15104
    localparam OUT_N = 5696; // 64*89
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
                $display("data_o=%b", data_o);
                for (i=0; i<64; i=i+1) begin
                    for (j=0; j<O_BW; j=j+1) begin
                        data_o_partial[j] = data_o[i*O_BW+j];
                    end
                    omem[n*64+i] = data_o_partial;
                    // $display("n=%d, i=%d, data_o_partial=%b", n, i, data_o_partial);
                end
                n <= n+1;
                // $display("-----");
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
        // di_en <= 1;
        // 0個目
        // data_i <= imem[n+1];
        data_i <= imem[n];
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 1個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 2個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 3個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 4個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 5個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 6個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 7個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 8個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 9個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 10個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 11個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 12個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 13個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 14個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 15個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 16個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 17個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 18個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 19個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 20個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 21個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 22個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 23個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 24個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 25個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 26個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 27個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 28個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 29個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 30個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 31個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 32個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 33個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 34個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 35個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 36個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 37個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 38個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 39個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 40個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 41個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 42個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 43個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 44個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 45個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 46個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 47個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 48個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 49個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 50個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 51個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 52個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 53個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 54個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 55個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 56個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 57個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 58個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 59個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 60個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 61個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 62個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 63個目
        data_i <= imem[n+1];
        n <= n + 1;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        // 64個目
        data_i <= imem[n+1];
        n <= n + 1;
        rst_log <= 1'b0;
        #100;
        send_spi_byte({1'b1, n[14:0], 1'b1, 9'b0, data_i[13:0]});
        rst_log <= 1'b1;
        // rst_log <= 1'b0;
        // #100;
        // rst_log <= 1'b1;

        // di_en <= 0;
        // data_i <= 'bx;
        // send_spi_byte(40'b1111111111111111100000000000000000000000); // 推論モードに。
        // #6500;
        // // send_spi_byte(40'b1111111111111111100000000000000000000000); // 推論モードに。
        // #608000;
        #158800;
        spi_cs = 1'b1; // チップセレクトを非アクティブに
        #500;
        spi_cs = 1'b0;
        send_spi_byte(40'b0000000000000000100000000000000000110100);
        send_spi_byte(40'b0000000000000001100000000000000000000000);
        spi_cs = 1'b1; // チップセレクトを非アクティブに
        #800;
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
                $display("tb_spi_logmel spi_mosi=%d", spi_mosi);
            end
        end
    endtask

endmodule