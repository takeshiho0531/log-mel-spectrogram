`timescale	1ns/1ns
module t_log;
    localparam I_BW = 30;
    localparam O_BW = 14;
    localparam TOTAL_DATA = 64;

    reg clk;
    reg rst;
    reg signed [I_BW*64-1:0] in;
    wire signed [O_BW*64-1:0] out;
    wire signed [I_BW-1:0] show_i [0:63];
    wire signed [O_BW-1:0] show_o [0:63];

    //----------------------------------------------------------------------
    //	clk and rst
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
    end


    //----------------------------------------------------------------------
    //	Tasks
    //----------------------------------------------------------------------

    task GenerateInputWave;
        begin
            in[I_BW*1-1:I_BW*0] <= 100;
            in[I_BW*2-1:I_BW*1] <= 200;
            in[I_BW*3-1:I_BW*2] <= 300;
            in[I_BW*4-1:I_BW*3] <= 400;
            in[I_BW*5-1:I_BW*4] <= 500;
            in[I_BW*6-1:I_BW*5] <= 600;
            in[I_BW*7-1:I_BW*6] <= 700;
            in[I_BW*8-1:I_BW*7] <= 800;
            in[I_BW*9-1:I_BW*8] <= 900;
            in[I_BW*10-1:I_BW*9] <= 1000;
            in[I_BW*11-1:I_BW*10] <= 1100;
            in[I_BW*12-1:I_BW*11] <= 1200;
            in[I_BW*13-1:I_BW*12] <= 1300;
            in[I_BW*14-1:I_BW*13] <= 1400;
            in[I_BW*15-1:I_BW*14] <= 1500;
            in[I_BW*16-1:I_BW*15] <= 1600;
            in[I_BW*17-1:I_BW*16] <= 1700;
            in[I_BW*18-1:I_BW*17] <= 1800;
            in[I_BW*19-1:I_BW*18] <= 1900;
            in[I_BW*20-1:I_BW*19] <= 2000;
            in[I_BW*21-1:I_BW*20] <= 2100;
            in[I_BW*22-1:I_BW*21] <= 2200;
            in[I_BW*23-1:I_BW*22] <= 2300;
            in[I_BW*24-1:I_BW*23] <= 2400;
            in[I_BW*25-1:I_BW*24] <= 2500;
            in[I_BW*26-1:I_BW*25] <= 2600;
            in[I_BW*27-1:I_BW*26] <= 2700;
            in[I_BW*28-1:I_BW*27] <= 2800;
            in[I_BW*29-1:I_BW*28] <= 2900;
            in[I_BW*30-1:I_BW*29] <= 3000;
            in[I_BW*31-1:I_BW*30] <= 3100;
            in[I_BW*32-1:I_BW*31] <= 3200;
            in[I_BW*33-1:I_BW*32] <= 3300;
            in[I_BW*34-1:I_BW*33] <= 3400;
            in[I_BW*35-1:I_BW*34] <= 3500;
            in[I_BW*36-1:I_BW*35] <= 3600;
            in[I_BW*37-1:I_BW*36] <= 3700;
            in[I_BW*38-1:I_BW*37] <= 3800;
            in[I_BW*39-1:I_BW*38] <= 3900;
            in[I_BW*40-1:I_BW*39] <= 4000;
            in[I_BW*41-1:I_BW*40] <= 4100;
            in[I_BW*42-1:I_BW*41] <= 4200;
            in[I_BW*43-1:I_BW*42] <= 4300;
            in[I_BW*44-1:I_BW*43] <= 4400;
            in[I_BW*45-1:I_BW*44] <= 4500;
            in[I_BW*46-1:I_BW*45] <= 4600;
            in[I_BW*47-1:I_BW*46] <= 4700;
            in[I_BW*48-1:I_BW*47] <= 4800;
            in[I_BW*49-1:I_BW*48] <= 4900;
            in[I_BW*50-1:I_BW*49] <= 5000;
            in[I_BW*51-1:I_BW*50] <= 5100;
            in[I_BW*52-1:I_BW*51] <= 5200;
            in[I_BW*53-1:I_BW*52] <= 5300;
            in[I_BW*54-1:I_BW*53] <= 5400;
            in[I_BW*55-1:I_BW*54] <= 5500;
            in[I_BW*56-1:I_BW*55] <= 5600;
            in[I_BW*57-1:I_BW*56] <= 5700;
            in[I_BW*58-1:I_BW*57] <= 5800;
            in[I_BW*59-1:I_BW*58] <= 5900;
            in[I_BW*60-1:I_BW*59] <= 6000;
            in[I_BW*61-1:I_BW*60] <= 6100;
            in[I_BW*62-1:I_BW*61] <= 6200;
            in[I_BW*63-1:I_BW*62] <= 6300;
            in[I_BW*64-1:I_BW*63] <= 6400;
        end
    endtask

    log #(
       .I_BW(I_BW),
       .O_BW(O_BW)
    ) log_inst(
        .data_i(in),
        .data_o(out)
    );

    assign show_i[0] = in[I_BW*1-1:I_BW*0];
    assign show_i[1] = in[I_BW*2-1:I_BW*1];
    assign show_i[2] = in[I_BW*3-1:I_BW*2];
    assign show_i[3] = in[I_BW*4-1:I_BW*3];
    assign show_i[4] = in[I_BW*5-1:I_BW*4];
    assign show_i[5] = in[I_BW*6-1:I_BW*5];
    assign show_i[6] = in[I_BW*7-1:I_BW*6];
    assign show_i[7] = in[I_BW*8-1:I_BW*7];
    assign show_i[8] = in[I_BW*9-1:I_BW*8];
    assign show_i[9] = in[I_BW*10-1:I_BW*9];
    assign show_i[10] = in[I_BW*11-1:I_BW*10];
    assign show_i[11] = in[I_BW*12-1:I_BW*11];
    assign show_i[12] = in[I_BW*13-1:I_BW*12];
    assign show_i[13] = in[I_BW*14-1:I_BW*13];
    assign show_i[14] = in[I_BW*15-1:I_BW*14];
    assign show_i[15] = in[I_BW*16-1:I_BW*15];
    assign show_i[16] = in[I_BW*17-1:I_BW*16];
    assign show_i[17] = in[I_BW*18-1:I_BW*17];
    assign show_i[18] = in[I_BW*19-1:I_BW*18];
    assign show_i[19] = in[I_BW*20-1:I_BW*19];
    assign show_i[20] = in[I_BW*21-1:I_BW*20];
    assign show_i[21] = in[I_BW*22-1:I_BW*21];
    assign show_i[22] = in[I_BW*23-1:I_BW*22];
    assign show_i[23] = in[I_BW*24-1:I_BW*23];
    assign show_i[24] = in[I_BW*25-1:I_BW*24];
    assign show_i[25] = in[I_BW*26-1:I_BW*25];
    assign show_i[26] = in[I_BW*27-1:I_BW*26];
    assign show_i[27] = in[I_BW*28-1:I_BW*27];
    assign show_i[28] = in[I_BW*29-1:I_BW*28];
    assign show_i[29] = in[I_BW*30-1:I_BW*29];
    assign show_i[30] = in[I_BW*31-1:I_BW*30];
    assign show_i[31] = in[I_BW*32-1:I_BW*31];
    assign show_i[32] = in[I_BW*33-1:I_BW*32];
    assign show_i[33] = in[I_BW*34-1:I_BW*33];
    assign show_i[34] = in[I_BW*35-1:I_BW*34];
    assign show_i[35] = in[I_BW*36-1:I_BW*35];
    assign show_i[36] = in[I_BW*37-1:I_BW*36];
    assign show_i[37] = in[I_BW*38-1:I_BW*37];
    assign show_i[38] = in[I_BW*39-1:I_BW*38];
    assign show_i[39] = in[I_BW*40-1:I_BW*39];
    assign show_i[40] = in[I_BW*41-1:I_BW*40];
    assign show_i[41] = in[I_BW*42-1:I_BW*41];
    assign show_i[42] = in[I_BW*43-1:I_BW*42];
    assign show_i[43] = in[I_BW*44-1:I_BW*43];
    assign show_i[44] = in[I_BW*45-1:I_BW*44];
    assign show_i[45] = in[I_BW*46-1:I_BW*45];
    assign show_i[46] = in[I_BW*47-1:I_BW*46];
    assign show_i[47] = in[I_BW*48-1:I_BW*47];
    assign show_i[48] = in[I_BW*49-1:I_BW*48];
    assign show_i[49] = in[I_BW*50-1:I_BW*49];
    assign show_i[50] = in[I_BW*51-1:I_BW*50];
    assign show_i[51] = in[I_BW*52-1:I_BW*51];
    assign show_i[52] = in[I_BW*53-1:I_BW*52];
    assign show_i[53] = in[I_BW*54-1:I_BW*53];
    assign show_i[54] = in[I_BW*55-1:I_BW*54];
    assign show_i[55] = in[I_BW*56-1:I_BW*55];
    assign show_i[56] = in[I_BW*57-1:I_BW*56];
    assign show_i[57] = in[I_BW*58-1:I_BW*57];
    assign show_i[58] = in[I_BW*59-1:I_BW*58];
    assign show_i[59] = in[I_BW*60-1:I_BW*59];
    assign show_i[60] = in[I_BW*61-1:I_BW*60];
    assign show_i[61] = in[I_BW*62-1:I_BW*61];
    assign show_i[62] = in[I_BW*63-1:I_BW*62];
    assign show_i[63] = in[I_BW*64-1:I_BW*63];

    assign show_o[0] = out[O_BW*1-1:O_BW*0];
    assign show_o[1] = out[O_BW*2-1:O_BW*1];
    assign show_o[2] = out[O_BW*3-1:O_BW*2];
    assign show_o[3] = out[O_BW*4-1:O_BW*3];
    assign show_o[4] = out[O_BW*5-1:O_BW*4];
    assign show_o[5] = out[O_BW*6-1:O_BW*5];
    assign show_o[6] = out[O_BW*7-1:O_BW*6];
    assign show_o[7] = out[O_BW*8-1:O_BW*7];
    assign show_o[8] = out[O_BW*9-1:O_BW*8];
    assign show_o[9] = out[O_BW*10-1:O_BW*9];
    assign show_o[10] = out[O_BW*11-1:O_BW*10];
    assign show_o[11] = out[O_BW*12-1:O_BW*11];
    assign show_o[12] = out[O_BW*13-1:O_BW*12];
    assign show_o[13] = out[O_BW*14-1:O_BW*13];
    assign show_o[14] = out[O_BW*15-1:O_BW*14];
    assign show_o[15] = out[O_BW*16-1:O_BW*15];
    assign show_o[16] = out[O_BW*17-1:O_BW*16];
    assign show_o[17] = out[O_BW*18-1:O_BW*17];
    assign show_o[18] = out[O_BW*19-1:O_BW*18];
    assign show_o[19] = out[O_BW*20-1:O_BW*19];
    assign show_o[20] = out[O_BW*21-1:O_BW*20];
    assign show_o[21] = out[O_BW*22-1:O_BW*21];
    assign show_o[22] = out[O_BW*23-1:O_BW*22];
    assign show_o[23] = out[O_BW*24-1:O_BW*23];
    assign show_o[24] = out[O_BW*25-1:O_BW*24];
    assign show_o[25] = out[O_BW*26-1:O_BW*25];
    assign show_o[26] = out[O_BW*27-1:O_BW*26];
    assign show_o[27] = out[O_BW*28-1:O_BW*27];
    assign show_o[28] = out[O_BW*29-1:O_BW*28];
    assign show_o[29] = out[O_BW*30-1:O_BW*29];
    assign show_o[30] = out[O_BW*31-1:O_BW*30];
    assign show_o[31] = out[O_BW*32-1:O_BW*31];
    assign show_o[32] = out[O_BW*33-1:O_BW*32];
    assign show_o[33] = out[O_BW*34-1:O_BW*33];
    assign show_o[34] = out[O_BW*35-1:O_BW*34];
    assign show_o[35] = out[O_BW*36-1:O_BW*35];
    assign show_o[36] = out[O_BW*37-1:O_BW*36];
    assign show_o[37] = out[O_BW*38-1:O_BW*37];
    assign show_o[38] = out[O_BW*39-1:O_BW*38];
    assign show_o[39] = out[O_BW*40-1:O_BW*39];
    assign show_o[40] = out[O_BW*41-1:O_BW*40];
    assign show_o[41] = out[O_BW*42-1:O_BW*41];
    assign show_o[42] = out[O_BW*43-1:O_BW*42];
    assign show_o[43] = out[O_BW*44-1:O_BW*43];
    assign show_o[44] = out[O_BW*45-1:O_BW*44];
    assign show_o[45] = out[O_BW*46-1:O_BW*45];
    assign show_o[46] = out[O_BW*47-1:O_BW*46];
    assign show_o[47] = out[O_BW*48-1:O_BW*47];
    assign show_o[48] = out[O_BW*49-1:O_BW*48];
    assign show_o[49] = out[O_BW*50-1:O_BW*49];
    assign show_o[50] = out[O_BW*51-1:O_BW*50];
    assign show_o[51] = out[O_BW*52-1:O_BW*51];
    assign show_o[52] = out[O_BW*53-1:O_BW*52];
    assign show_o[53] = out[O_BW*54-1:O_BW*53];
    assign show_o[54] = out[O_BW*55-1:O_BW*54];
    assign show_o[55] = out[O_BW*56-1:O_BW*55];
    assign show_o[56] = out[O_BW*57-1:O_BW*56];
    assign show_o[57] = out[O_BW*58-1:O_BW*57];
    assign show_o[58] = out[O_BW*59-1:O_BW*58];
    assign show_o[59] = out[O_BW*60-1:O_BW*59];
    assign show_o[60] = out[O_BW*61-1:O_BW*60];
    assign show_o[61] = out[O_BW*62-1:O_BW*61];
    assign show_o[62] = out[O_BW*63-1:O_BW*62];
    assign show_o[63] = out[O_BW*64-1:O_BW*63];


    always @(posedge clk) begin
        $display("show_i[0]=%d, show_i[30]=%d, show_i[63]=%d, show_o[0]=%d, show_o[30]=%d, show_o[63]=%d", show_i[0], show_i[30], show_i[63], show_o[0], show_o[30], show_o[63]);
    end

    //----------------------------------------------------------------------
    //	Test Stimuli
    //----------------------------------------------------------------------
    initial begin : STIM
        wait (rst == 0);
        wait (rst == 1);
        repeat(10) @(posedge clk);

        begin
            GenerateInputWave;
            @(posedge clk);
        end

        repeat(10) @(posedge clk);
        $finish;
    end

    initial begin : TIMEOUT
        // repeat(100000000) #20;	//  1000 clk Cycle Time
        repeat(100000) #20;	//  1000 clk Cycle Time
        $display("[FAILED] Simulation timed out.");
        $finish;
    end

endmodule