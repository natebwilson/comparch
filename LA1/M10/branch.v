module branch(

  input  Branch,
  input [2:0] Funct3,
  input [3:0] flags,
  output taken

);


  wire z = flags[0];

  assign taken = (Branch & (Funct3 == 3'b00) & z);

endmodule
