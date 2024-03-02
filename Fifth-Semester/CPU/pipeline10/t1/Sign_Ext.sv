`timescale 1us/1us

module Sign_Ext(
    input [15:0] imm_num,
    input [5:0] opcode,
    output reg [31:0] Sign_ext
);

    always @(*) begin
        if (imm_num[15] == 1 && opcode != 6'b001101) begin
            Sign_ext[31:16] <= 16'b1111111111111111;
        end
        else begin
            Sign_ext[31:16] <= 16'b0000000000000000;
        end
        Sign_ext[15:0] <= imm_num;
    end
    
//    always @(*) begin
//        $display("Sign_ext = %x", Sign_ext);
//    end

endmodule