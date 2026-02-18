module alu_decoder(

  input [1:0] ALUOp,
  input [2:0] Funct3,
  input Funct7b5,
  input opb5,
  output reg [2:0] ALUControl

);

  always @(*) begin
    case(ALUOp)
      2'b00: ALUControl = 3'b000;
      2'b01: ALUControl = 3'b001;
      2'b10: begin
        case(Funct3)
          3'b000: begin
            if({Funct7b5, opb5} == 2'b11)
              ALUControl = 3'b001;
            else
              ALUControl = 3'b000;
          end

          3'b111: ALUControl = 3'b010;
          3'b110: ALUControl = 3'b011;
          3'b010: ALUControl = 3'b101;
          3'b001: ALUControl = 3'b110;
          default: ALUControl = 3'bxxx;
        endcase
      end
      default: ALUControl = 3'bxxx;
    endcase
  end


endmodule
