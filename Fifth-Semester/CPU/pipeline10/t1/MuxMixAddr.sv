`timescale 1us/1us

`include "MyStructure.sv"

module MuxMixAddr(
    input [31:0] jump_addr,
    input [31:0] ins,
    input [31:0] pc_plus4,
    input branch_sig,
    input branch_zero_sig,
    input jal_sig,
    input j_sig,
    input jr_sig,
    output reg [31:0] out_addr
);

    always @(*) begin
        if ((branch_sig == 1'b1 && branch_zero_sig == 1'b1) || jal_sig == 1'b1 || j_sig == 1'b1 || jr_sig == 1'b1) begin
            out_addr <= jump_addr;
//            $display("0 MuxMixAddr ins = %x, addr = %x", ins, jump_addr);
        end
        else begin
            out_addr <= pc_plus4;
//            $display("1 MuxMixAddr ins = %x, addr = %x", ins, pc_plus4);
        end
//        $display("MMS branch addr = %x, j addr = %x, jr adr = %x, ins = %x, out_addr = %x branch_sig = %d, jal_sig = %d, j_sig = %d, jr_sig = %d",  
//        branch_addr, jal_addr, jr_addr, ins, out_addr, branch_sig, jal_sig, j_sig, jr_sig);
    end

endmodule