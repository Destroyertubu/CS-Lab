

module InstructionMemory(
    input [31:0] ins_addr,
    output reg [31:0] ins
);

    reg [31:0] Instructions[30'h00000c00:30'h0001000];
        integer i;

    initial begin
        $readmemh("D:\\CPU\\mips\\new_tester\\pipeline-tester-py\\code.txt", Instructions);
    end

    always @(*) begin
        ins <= Instructions[ins_addr[31:2]];

        $display("ins_addr = %x, ins_code = %x", ins_addr, Instructions[ins_addr[31:2]]);
    end

endmodule