`timescale 1us/1us

module Jump_Analyse(
    input [31:0] pc_plus_4,
    input [31:0] ins,
    input [31:0] sign_ext_imm,
    input [25:0] addr_26,
    input [31:0] jr_reg_addr,
    input branch_sig,
    input jal_sig,
    input j_sig,
    input jr_sig,
    output [31:0] Jump_Addr
    );

    assign Jump_Addr = (j_sig == 1'b1 || jal_sig == 1'b1) ? {pc_plus_4[31:28], addr_26, 2'b00} : 
                        branch_sig == 1'b1 ? pc_plus_4 + (sign_ext_imm << 2) : jr_reg_addr;

endmodule