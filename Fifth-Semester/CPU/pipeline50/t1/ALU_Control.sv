`timescale  1ns/1ps

module ALU_Control(
    input [5:0] func,
    input [3:0] alu_opcode,
    output reg [3:0] ALU_Control_signal 
);

    always @(alu_opcode) begin
//        $display("alu_control_alu_opcode = %x", alu_opcode);
        if (alu_opcode) 
            begin
                case (alu_opcode)
                    4'b0001: ALU_Control_signal <= 4'b0001;   // +
                    4'b0010: ALU_Control_signal <= 4'b0010;   // -
                    4'b0100: ALU_Control_signal <= 4'b0100;   // |
                    4'b0011: ALU_Control_signal <= 4'b0011;   // lui
                endcase
                
            end
        else 
            begin
                case (func)
                    6'b100001: begin 
                        ALU_Control_signal <= 4'b0001; // addu
//                        $display("alu_control addu");
                        end
                    6'b100011: begin
                        ALU_Control_signal <= 4'b0010; // subu
//                        $display("subu");
                        end 
                    6'b001000: begin 
                        ALU_Control_signal <= 4'b0101; // jr
//                        $display("jr");
                    end
                endcase
            end
    end

endmodule