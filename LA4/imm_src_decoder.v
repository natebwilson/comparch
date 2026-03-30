module imm_src_decoder
(
  input [6:0] op,
  output reg [2:0] ImmSrc

);

  always @(op)
    case(op)
      7'd3: ImmSrc = 3'b000;    // Load
      7'd19: ImmSrc = 3'b000;   // ALU immediate
      7'd103: ImmSrc = 3'b000;  // JALR
      7'd35: ImmSrc = 3'b001;   // Store
      7'd99: ImmSrc = 3'b010;   // Branch
      7'd111: ImmSrc = 3'b011;  // JAL
      7'd23: ImmSrc = 3'b100;   // AUIPC
      7'd55: ImmSrc = 3'b100;   // LUI
      default: ImmSrc = 3'b000;
    endcase

endmodule


