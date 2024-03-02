`timescale 1us/1us

module GPR(
    input clk,
    input Reset,
    input WR,    // 鍐欎娇鑳斤�??1涓烘�???���????
    input [31:0] programCounter,
    input [4:0] rd_r1,
    input [4:0] rd_r2,
    input [4:0] mod_reg,
    input [31:0] in_data,
    output reg [31:0] out_data1,
    output reg [31:0] out_data2
    );
    initial
        begin
//            $display("GPR");
        end
    integer i;
    reg [31:0] register [0:31];
    
    always @(posedge Reset) begin
        
        if(Reset) begin
            for(i = 0; i <= 31; i=i+1) begin
                register[i] <= 0;
            end
        end
     end
     
     always @(posedge clk) begin
//        $display("%h: $%d", programCounter - 4, mod_reg);
        if(WR == 1 && mod_reg != 0)
            begin
                register[mod_reg] <= in_data;
                $display("@%h: $%d <= %h", programCounter - 4, mod_reg, in_data);
                
            end
//        else if (WR == 1 && mod_reg == 0)
//            begin
//                $display("@%h: $%d <= %h", programCounter - 8, mod_reg, in_data);
//            end
    end
    

    
    always @(*) begin
        out_data1 = (rd_r1 == 0) ? 0 : register[rd_r1];
        out_data2 = (rd_r2 == 0) ? 0 : register[rd_r2];

        // $display("regS = %d, regT = %d ", rd_r1, rd_r2);
        // $display("read_data_1 = %x, read_data_2 = %x", out_data1, out_data2);
        // $display("mod_reg = %d", mod_reg);
    end


    
endmodule