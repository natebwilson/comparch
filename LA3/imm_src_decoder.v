module imm_src_decoder
(
  input [6:0] op,
  output reg [2:0] ImmSrc

);

  always @(op)
    case(op)
      7'd3: ImmSrc = 3'b000;
      7'd19: ImmSrc = 3'b000;
      7'd35: ImmSrc = 3'b001;
      7'd99: ImmSrc = 3'b010;
      7'd111: ImmSrc = 3'b011;
      default: ImmSrc = 3'b000;
    endcase

endmodule


