module address_decoder
(
  input MemWrite,
  input [31:0] Addr,
  output RAM_CS,
  output RAM_WE,
  output ROM_CS
);


wire isROM;
assign isROM = (Addr <=32'h00001fff);

wire isRAM;
assign isRAM = ((Addr >= 32'h00002000) && (Addr <=32'h00002fff));


assign ROM_CS = isROM & ~MemWrite;
assign RAM_CS = isRAM;
assign RAM_WE = isRAM & MemWrite;


endmodule
