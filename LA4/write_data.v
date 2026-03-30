module write_data (
  input  wire [31:0] OldWord,
  input  wire [31:0] StoreValue,
  input  wire [1:0]  Addr,
  input  wire [1:0]  StoreType,
  output reg  [31:0] WriteWord
);

  always @(*) begin
    case (StoreType)
      2'b00: begin
        //sw
        WriteWord = StoreValue;
      end

      2'b01: begin
        //sb
        case (Addr)
          2'b00: WriteWord = {OldWord[31:8],  StoreValue[7:0]};
          2'b01: WriteWord = {OldWord[31:16], StoreValue[7:0], OldWord[7:0]};
          2'b10: WriteWord = {OldWord[31:24], StoreValue[7:0], OldWord[15:0]};
          2'b11: WriteWord = {StoreValue[7:0], OldWord[23:0]};
          default: WriteWord = OldWord;
        endcase
      end

      2'b10: begin
        // sh
        case (Addr[1])
          1'b0: WriteWord = {OldWord[31:16], StoreValue[15:0]};
          1'b1: WriteWord = {StoreValue[15:0], OldWord[15:0]};
          default: WriteWord = OldWord;
        endcase
      end

      default: begin
        WriteWord = StoreValue;
      end
    endcase
  end

endmodule
