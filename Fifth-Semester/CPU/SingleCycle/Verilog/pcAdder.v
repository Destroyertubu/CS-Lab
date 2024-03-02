`timescale 1ns/1ps

module pcAdder(
    input [31:0] pc,
    output reg [31:0] mod_pc
);

    always @(*) begin
        mod_pc = pc + 4;
    end
    

endmodule