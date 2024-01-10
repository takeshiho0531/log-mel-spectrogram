`timescale	1ns/1ns
module mel_filter # (
    parameter I_BW = 27, // 2乗は別のモジュール
    parameter O_BW = 56,
    parameter COEF_BW = 27
)(
    input clk,
    input rst,
    input [9:0] in_group_idx, // 0-512
    input signed [I_BW-1:0] data_i,
    input [6:0] in_group_num, // 0-88
    input di_en,
    input is_first_in,
    input is_last_in,
    output signed [O_BW*64-1:0] data_o,
    output reg do_en,
    output reg [6:0] out_group_num // 0-88
);
    wire [9:0] filter_v; // 0-512
    wire [1:0] non_zero_num;
    wire [5:0] non_zero_idx1;
    wire [5:0] non_zero_idx2;
    wire signed [26:0] non_zero_data1;
    wire signed [26:0] non_zero_data2;
    wire signed [51:0] multiplied1;
    wire signed [51:0] multiplied2;
    wire signed [25:0] scaled1;
    wire signed [25:0] scaled2;
    reg signed [29:0] tmp[0:63];
    integer i;

    assign filter_v = in_group_idx;

    mel_filter_coef coef(
        .filter_v(filter_v), // 0-512 // i
        .non_zero_num(non_zero_num), // o
        .non_zero_idx1(non_zero_idx1), // o
        .non_zero_idx2(non_zero_idx2), // o
        .non_zero_data1(non_zero_data1),  // o
        .non_zero_data2(non_zero_data2)  // o
    );

    assign multiplied1 = data_i * non_zero_data1;
    assign multiplied2 = data_i * non_zero_data2;
    assign scaled1 = multiplied1 >>> 26;
    assign scaled2 = multiplied2 >>> 26;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i=0; i<64; i=i+1) begin
                tmp[i] <= 30'b000000000000000000000000000000;
            end
            do_en <= 0;
            out_group_num <= 0; // 
        end
        else begin
            if (di_en & is_first_in) begin
                if (non_zero_num==0) begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= 30'b000000000000000000000000000000;
                    end
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
                else if (non_zero_num==1) begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= 30'b000000000000000000000000000000;
                    end
                    tmp[non_zero_idx1] <= tmp[non_zero_idx1]+scaled1;
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
                else if (non_zero_num==2) begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= 30'b000000000000000000000000000000;
                    end
                    tmp[non_zero_idx1] <= tmp[non_zero_idx1]+scaled1;
                    tmp[non_zero_idx2] <= tmp[non_zero_idx2]+scaled2;
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
                else begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= 30'b000000000000000000000000000000;
                    end
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
            end
            else if (di_en & is_last_in) begin
                if (non_zero_num==0) begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= tmp[i];
                    end
                    do_en <= 1;
                    out_group_num <= in_group_num;
                end
                else if (non_zero_num==1) begin
                    tmp[non_zero_idx1] <= tmp[non_zero_idx1]+scaled1;
                    do_en <= 1;
                    out_group_num <= in_group_num;
                end
                else if (non_zero_num==2) begin
                    tmp[non_zero_idx1] <= tmp[non_zero_idx1]+scaled1;
                    tmp[non_zero_idx2] <= tmp[non_zero_idx2]+scaled2;
                    do_en <= 1;
                    out_group_num <= in_group_num;
                end
                else begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= tmp[i];
                    end
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
            end
            else if (di_en) begin
                if (non_zero_num==0) begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= tmp[i];
                    end
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
                else if (non_zero_num==1) begin
                    tmp[non_zero_idx1] <= tmp[non_zero_idx1]+scaled1;
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
                else if (non_zero_num==2) begin
                    tmp[non_zero_idx1] <= tmp[non_zero_idx1]+scaled1;
                    tmp[non_zero_idx2] <= tmp[non_zero_idx2]+scaled2;
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
                else begin
                    for (i=0; i<64; i=i+1) begin
                        tmp[i] <= tmp[i];
                    end
                    do_en <= 0;
                    out_group_num <= in_group_num;
                end
            end
            else begin
                for (i=0; i<64; i=i+1) begin
                    tmp[i] <= tmp[i];
                end
                do_en <= 0;
                out_group_num <= in_group_num;
            end
        end 
    end

    assign data_o[O_BW*64-1:O_BW*63]=tmp[0];
    assign data_o[O_BW*63-1:O_BW*62]=tmp[1];
    assign data_o[O_BW*62-1:O_BW*61]=tmp[2];
    assign data_o[O_BW*61-1:O_BW*60]=tmp[3];
    assign data_o[O_BW*60-1:O_BW*59]=tmp[4];
    assign data_o[O_BW*59-1:O_BW*58]=tmp[5];
    assign data_o[O_BW*58-1:O_BW*57]=tmp[6];
    assign data_o[O_BW*57-1:O_BW*56]=tmp[7];
    assign data_o[O_BW*56-1:O_BW*55]=tmp[8];
    assign data_o[O_BW*55-1:O_BW*54]=tmp[9];
    assign data_o[O_BW*54-1:O_BW*53]=tmp[10];
    assign data_o[O_BW*53-1:O_BW*52]=tmp[11];
    assign data_o[O_BW*52-1:O_BW*51]=tmp[12];
    assign data_o[O_BW*51-1:O_BW*50]=tmp[13];
    assign data_o[O_BW*50-1:O_BW*49]=tmp[14];
    assign data_o[O_BW*49-1:O_BW*48]=tmp[15];
    assign data_o[O_BW*48-1:O_BW*47]=tmp[16];
    assign data_o[O_BW*47-1:O_BW*46]=tmp[17];
    assign data_o[O_BW*46-1:O_BW*45]=tmp[18];
    assign data_o[O_BW*45-1:O_BW*44]=tmp[19];
    assign data_o[O_BW*44-1:O_BW*43]=tmp[20];
    assign data_o[O_BW*43-1:O_BW*42]=tmp[21];
    assign data_o[O_BW*42-1:O_BW*41]=tmp[22];
    assign data_o[O_BW*41-1:O_BW*40]=tmp[23];
    assign data_o[O_BW*40-1:O_BW*39]=tmp[24];
    assign data_o[O_BW*39-1:O_BW*38]=tmp[25];
    assign data_o[O_BW*38-1:O_BW*37]=tmp[26];
    assign data_o[O_BW*37-1:O_BW*36]=tmp[27];
    assign data_o[O_BW*36-1:O_BW*35]=tmp[28];
    assign data_o[O_BW*35-1:O_BW*34]=tmp[29];
    assign data_o[O_BW*34-1:O_BW*33]=tmp[30];
    assign data_o[O_BW*33-1:O_BW*32]=tmp[31];
    assign data_o[O_BW*32-1:O_BW*31]=tmp[32];
    assign data_o[O_BW*31-1:O_BW*30]=tmp[33];
    assign data_o[O_BW*30-1:O_BW*29]=tmp[34];
    assign data_o[O_BW*29-1:O_BW*28]=tmp[35];
    assign data_o[O_BW*28-1:O_BW*27]=tmp[36];
    assign data_o[O_BW*27-1:O_BW*26]=tmp[37];
    assign data_o[O_BW*26-1:O_BW*25]=tmp[38];
    assign data_o[O_BW*25-1:O_BW*24]=tmp[39];
    assign data_o[O_BW*24-1:O_BW*23]=tmp[40];
    assign data_o[O_BW*23-1:O_BW*22]=tmp[41];
    assign data_o[O_BW*22-1:O_BW*21]=tmp[42];
    assign data_o[O_BW*21-1:O_BW*20]=tmp[43];
    assign data_o[O_BW*20-1:O_BW*19]=tmp[44];
    assign data_o[O_BW*19-1:O_BW*18]=tmp[45];
    assign data_o[O_BW*18-1:O_BW*17]=tmp[46];
    assign data_o[O_BW*17-1:O_BW*16]=tmp[47];
    assign data_o[O_BW*16-1:O_BW*15]=tmp[48];
    assign data_o[O_BW*15-1:O_BW*14]=tmp[49];
    assign data_o[O_BW*14-1:O_BW*13]=tmp[50];
    assign data_o[O_BW*13-1:O_BW*12]=tmp[51];
    assign data_o[O_BW*12-1:O_BW*11]=tmp[52];
    assign data_o[O_BW*11-1:O_BW*10]=tmp[53];
    assign data_o[O_BW*10-1:O_BW*9]=tmp[54];
    assign data_o[O_BW*9-1:O_BW*8]=tmp[55];
    assign data_o[O_BW*8-1:O_BW*7]=tmp[56];
    assign data_o[O_BW*7-1:O_BW*6]=tmp[57];
    assign data_o[O_BW*6-1:O_BW*5]=tmp[58];
    assign data_o[O_BW*5-1:O_BW*4]=tmp[59];
    assign data_o[O_BW*4-1:O_BW*3]=tmp[60];
    assign data_o[O_BW*3-1:O_BW*2]=tmp[61];
    assign data_o[O_BW*2-1:O_BW*1]=tmp[62];
    assign data_o[O_BW*1-1:O_BW*0]=tmp[63];

endmodule