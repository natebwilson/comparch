`timescale 1 ns / 1 ns

module testbench;


  reg  Branch;
  reg [2:0] Funct3;
  reg [3:0] flags;
  wire taken;


  branch dut (
    .Branch(Branch),
    .Funct3(Funct3),
    .flags(flags),
    .taken(taken)
  );


  initial begin

  //init inputs
  Branch = 1'b0;
  Funct3 = 3'b000;
  flags = 4'b0000;
  #1;

  $display("\nBegin Testing\n");

  //Branch = 0 should not be taken even if z = 1 and Funct3 = 000;
  flags = 4'b0001;
  #1;
  $display("EXPECTED: taken should be zero with Branch = 0 z = 1 and Funct3 = 000");
  $display("taken = %b | Branch=%b | z = %b | Funct3 = %b \n", taken, Branch, flags[0], Funct3);

  //Branch should be taken
  Branch = 1'b1;
  #1;
  $display("EXPECTED: taken should be one with Branch = 1 z = 1 and Funct3 = 000");
  $display("taken = %b | Branch=%b | z = %b | Funct3 = %b \n", taken, Branch, flags[0], Funct3);

  //Branch should not be taken with z =0 
  flags = 4'b0000;
  #1;
  $display("EXPECTED: taken should be zero with Branch = 1 z = 0 and Funct3 = 000");
  $display("taken = %b | Branch=%b | z = %b | Funct3 = %b \n", taken, Branch, flags[0], Funct3);

  //Branch should not be taken with nonzero Funct3 
  flags = 4'b0001;
  Funct3 = 3'b111;
  #1;
  $display("EXPECTED: taken should be zero with Branch = 1 z = 1 and Funct3 = 111");
  $display("taken = %b | Branch=%b | z = %b | Funct3 = %b \n", taken, Branch, flags[0], Funct3);

  $display("Testing complete\n");

  end


  initial begin
      #(200);
      $finish;
  end

  initial begin
      $dumpvars(0,testbench);
  end
endmodule
