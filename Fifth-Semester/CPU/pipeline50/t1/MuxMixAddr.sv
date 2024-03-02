`timescale 1us/1us

`include "MyStructure.sv"

module MuxMixAddr(
    input [31:0] jump_addr,
    input [31:0] ins,
    input clock,
    input [31:0] pc_plus4,
    input [5:0] ID_opcode,
    input branch_sig,
    input branch_zero_sig,
    input jal_sig,
    input jalr_sig,
    input j_sig,
    input jr_sig,
    input bgtz_sig,
    input blez_sig,
    input bgez_sig,
    input bltz_sig,
    input [4:0] sp_mark,
    output reg [31:0] out_addr
);

    always @(*) begin
//        $display("ins = %x, branch_zero_sig = %d, ID_opcode = %x", ins, branch_zero_sig, ID_opcode);
        if ((branch_sig == 1'b1 && ((branch_zero_sig == 1'b1 && ID_opcode == 6'b000100)||(branch_zero_sig == 1'b0 && ID_opcode == 6'b000101))) || jal_sig == 1'b1 || jalr_sig  == 1'b1 || j_sig == 1'b1 || jr_sig == 1'b1) 
            begin
                out_addr <= jump_addr;
//                $display("0 MuxMixAddr ins = %x, addr = %x", ins, jump_addr);
            end
        else if (branch_sig == 1'b1 && ID_opcode == 6'b000111 && bgtz_sig == 1'b1 )
            begin
                out_addr <= jump_addr;
//                $display("MuxMixAddr BGTZ Success, Jump Addr = %x", jump_addr);
            end
        else if (branch_sig == 1'b1 && ID_opcode == 6'b000110 && blez_sig == 1'b1)
            begin
//                $display("MuxMixAddr BLEZ Success, Jump Addr = %x", jump_addr);
                out_addr <= jump_addr;
            end
        else if (branch_sig == 1'b1 && ID_opcode == 6'b000001  && sp_mark == 5'b00001 &&  bgez_sig == 1'b1)
            begin
                out_addr <= jump_addr;
            end
        else if (branch_sig == 1'b1 && ID_opcode == 6'b000001  && sp_mark == 5'b00000 && bltz_sig == 1'b1)
            begin
                out_addr <= jump_addr;
            end
        else 
            begin
                out_addr <= pc_plus4;
//                $display("1 MuxMixAddr ins = %x, addr = %x, branch_sig = %d, blez_sig = %d, bgtz_sig = %d", ins, pc_plus4, branch_sig, blez_sig, bgtz_sig);
            end
//        $display("MMS branch addr = %x, j addr = %x, jr adr = %x, ins = %x, out_addr = %x branch_sig = %d, jal_sig = %d, j_sig = %d, jr_sig = %d",  
//        branch_addr, jal_addr, jr_addr, ins, out_addr, branch_sig, jal_sig, j_sig, jr_sig);
    end

endmodule