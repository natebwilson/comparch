module ALU_decoder(

  input [1:0] ALUOp,
  input [2:0] funct3,
  input funct7b5,
  input opb5,
  output reg [3:0] ALUControl

);

  always @(*) begin
    case(ALUOp)
      2'b00: ALUControl = 4'b0000; //Add
      2'b01: ALUControl = 4'b0001; //Sub
      2'b10: begin
        case(funct3)
          3'b000: begin
            if({funct7b5, opb5} == 2'b11)
              ALUControl = 4'b0001; //sub
            else
              ALUControl = 4'b0000; //add
          end

          3'b001: ALUControl = 4'b0110; //SLL
          3'b010: ALUControl = 4'b0101; //SLT
          3'b011: ALUControl = 4'b1001; //SLTU
          3'b100: ALUControl = 4'b0100; //XOR

          3'b101: begin //logic block for right shift
            if(funct7b5)
              ALUControl = 4'b1000; //sra
            else
              ALUControl = 4'b0111; //srl
          end

          3'b110: ALUControl = 4'b0011; //OR
          3'b111: ALUControl = 4'b0010; //AND
          default: ALUControl = 4'bxxxx;
        endcase
      end
      default: ALUControl = 4'bxxxx;
    endcase
  end


endmodule
