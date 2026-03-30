module branch_unit(

  input  Branch,
  input [2:0] funct3,
  input [3:0] flags,
  output taken

);

  wire z = flags[0];
  wire n = flags[1];
  wire c = flags[2];
  wire v = flags[3];

  reg condition_met;

  always @(*) begin
    case (funct3)
      3'b000: condition_met = z;           // beq
      3'b001: condition_met = ~z;          // bne
      3'b100: condition_met = (n != v);    // blt
      3'b101: condition_met = (n == v);    // bge
      3'b110: condition_met = ~c;          // bltu
      3'b111: condition_met = c;           // bgeu
      default: condition_met = 0;
    endcase
  end

  assign taken = Branch & condition_met;

endmodule
