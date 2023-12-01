module mel_filter(  
    clk,
    rst_n,
    in_re,
    in_im,
    in_valid,
    in_num,
    out,
    out_valid,
    out_num
);
    // Definition of ports
    input  wire clk; 
    input  wire rst_n;
    input  wire signed [39:0] in_re ;
    input  wire signed [39:0] in_im ;
    input  wire in_valid;
    input wire [9:0]in_num;
    output wire out_valid;
    output wire [47*10-1:0] out;
    output wire [4:0]out_num;

    integer i;
    integer count=0;
    // Definition of wire/reg 
    reg signed[39:0] abs_r,abs_w;//40+40+1
    reg first_in_r,first_in_w;
    reg last_in_r,last_in_w;
    reg [46:0]acum_r[9:0];//7 bits more than ans
    reg [46:0]acum_w[9:0];//
    reg valid_r,valid_w;
    reg out_valid_r,out_valid_w;
    reg state_r,state_w;
    reg [4:0]counter_r,counter_w;
    wire [39:0]rom_out;
    wire [3:0]addr1,addr2;
    wire [15:0]mul1,mul2;
    wire [39:0]ans1,ans2;
    wire [55:0]pre_ans1;
    wire [55:0]pre_ans2;
    wire [39:0] sqrt_out;
    assign addr1=rom_out[39:36];
    assign addr2=rom_out[35:32];
    assign mul1=rom_out[31:16];
    assign mul2=rom_out[15:0];
    assign ans1=pre_ans1>>16;
    assign ans2=pre_ans2>>16;
    assign pre_ans1=abs_r*mul1;
    assign pre_ans2=abs_r*mul2;
    assign out_valid=out_valid_r;
    assign out={acum_r[9],acum_r[8],acum_r[7],acum_r[6],acum_r[5],acum_r[4],acum_r[3],acum_r[2],acum_r[1],acum_r[0]};
    assign out_num=counter_r;
    sqrt #(
       .DATA_IN_WIDTH(40)
      ) 
      s0
      (
        .clk(clk),
        .x1(in_re),
        .x2(in_im),
        .y(sqrt_out)
      );    

    mel_rom m0(
      .clk(clk),
      .rst_n(rst_n),
      .in_nd(in_valid),
      .addr(in_num),
      .w(rom_out)//41~37 filter1 36~32 filter2 31~16 filter1_mul 15~0 filter2_mul
    );
    //-------------------------------------------------------abs_w first_in_w last_in_w valid_w counter_w
    always @(*) begin
      
      if(out_valid_w)begin
        counter_w=counter_r+1;
      end
      else begin
        counter_w=counter_r;
      end
      case(state_r)
        0:state_w=(in_valid)?1:0;
        1:state_w=1;
      endcase
      if(state_r)begin
          abs_w=sqrt_out;
          first_in_w=((in_num==0)&&(in_valid))?1:0;
          last_in_w=((in_num==1023)&&(in_valid))?1:0;
          valid_w=in_valid;
          out_valid_w=last_in_r;
      end
      else begin
        if(in_valid)begin
          abs_w=sqrt_out;
          first_in_w=((in_num==0)&&(in_valid))?1:0;
          last_in_w=((in_num==1023)&&(in_valid))?1:0;
          valid_w=in_valid;
          out_valid_w=last_in_r;
        end
        else begin
          abs_w=0;
          first_in_w=0;
          last_in_w=0;
          valid_w=0;
          out_valid_w=0;
        end
        
      end
      
    end
    //--------------------------------------------------acum_w
    always @(*) begin
      for(i=0;i<=10;i=i+1)begin
        if(valid_r==0)begin
          acum_w[i]=0;
        end
        else begin
          if(first_in_r)begin
            if((i+1)==addr1)begin
              acum_w[i]=ans1;
            end
            else if((i+1)==addr2)begin
              acum_w[i]=ans2;
            end
            else begin
              acum_w[i]=0;
            end
          end
          else begin
            if((i+1)==addr1)begin
              acum_w[i]=ans1+acum_r[i];
            end
            else if((i+1)==addr2)begin
              acum_w[i]=ans2+acum_r[i];
            end
            else begin
              acum_w[i]=acum_r[i];
            end
          end
        end       
      end
    end
    
    always @ (posedge clk or negedge rst_n)begin
      count<=count+1;
      if(!rst_n) begin//
        abs_r<=0;
        first_in_r<=0;
        last_in_r<=0;
        valid_r<=0;
        out_valid_r<=0;
        for(i=0;i<=10;i=i+1)begin
          acum_r[i]<=0;
        end
        state_r<=0;
        counter_r<=0;
      end
      else begin      
        abs_r<=abs_w;
        first_in_r<=first_in_w;
        last_in_r<=last_in_w;
        valid_r<=valid_w;
        out_valid_r<=out_valid_w;
        for(i=0;i<=10;i=i+1)begin
          acum_r[i]<=acum_w[i];
        end
        state_r<=state_w;
        counter_r<=counter_w;
      end
    end
endmodule


module sqrt
    #(parameter DATA_IN_WIDTH = 16)
    (
    input   wire                                    clk,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x1,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x2,
    output  wire            [ DATA_IN_WIDTH-1:  0 ] y
    );

localparam DATA_WIDTH_SQUARING = (2*DATA_IN_WIDTH) - 1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x1_2 = x1*x1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x2_2 = x2*x2;

localparam DATA_WIDTH_SUM = DATA_WIDTH_SQUARING+1;
wire    [ DATA_WIDTH_SUM-1 :  0 ] x = x1_2 + x2_2;

assign y[DATA_IN_WIDTH-1] = x[(DATA_WIDTH_SUM-1)-:2] == 2'b00 ? 1'b0 : 1'b1;
genvar k;
generate
    for(k = DATA_IN_WIDTH-2; k >= 0; k = k - 1)
    begin: gen
        assign y[k] = x[(DATA_WIDTH_SUM-1)-:(2*(DATA_IN_WIDTH-k))] < 
        {y[DATA_IN_WIDTH-1:k+1],1'b1}*{y[DATA_IN_WIDTH-1:k+1],1'b1} ? 1'b0 : 1'b1;
    end
endgenerate

endmodule