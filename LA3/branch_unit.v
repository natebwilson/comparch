module branch_unit(

  input  Branch,
  input [2:0] funct3,
  input [3:0] flags,
  output taken

);


  wire z = flags[0];

  assign taken = (Branch & (funct3 == 3'b00) & z);

endmodule
