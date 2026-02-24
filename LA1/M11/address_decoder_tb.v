`timescale 1 ns / 1 ns

module testbench;

/*
  input MemWrite,
  input [31:0] Addr,
  output RAM_CS,
  output RAM_WE,
  output ROM_CS
*/
  reg  MemWrite;
  reg [31:0] Addr;
  wire RAM_CS;
  wire RAM_WE;
  wire ROM_CS;


  address_decoder dut (
    .MemWrite(MemWrite),
    .Addr(Addr),
    .RAM_CS(RAM_CS),
    .ROM_CS(ROM_CS),
    .RAM_WE(RAM_WE)
  );


  initial begin

  //init inputs
  MemWrite = 1'b0;
  Addr = 32'h00000000;
  #1;

  $display("\nBegin Testing\n");

  //ROM_CS should be high with MemWrite low and addr in range
  #1;
  $display("EXPECTED: ROM_CS should be high with MemWrite low and addr in ROM address range");
  $display("EXPECTED: RAM_CS and RAM_WE should be low");
  $display("MemWrite = %b | Addr = %h ", MemWrite, Addr);
  $display("ROM_CS = %b | RAM_CS = %b | RAM_WE = %b \n", ROM_CS, RAM_CS, RAM_WE);

  //ROM_CS should be low with MemWrite high and addr in range
  MemWrite = 1'b1;
  #1;
  $display("EXPECTED: ROM_CS should be low with MemWrite high and addr in ROM address range");
  $display("EXPECTED: RAM_CS and RAM_WE should be low");
  $display("MemWrite = %b | Addr = %h ", MemWrite, Addr);
  $display("ROM_CS = %b | RAM_CS = %b | RAM_WE = %b \n", ROM_CS, RAM_CS, RAM_WE);

  MemWrite = 1'b0;
  Addr = 32'h00002000;
  #1;
  $display("EXPECTED: RAM_CS should be high and RAM_WE low with MemWrite low and addr in RAM address range");
  $display("EXPECTED: ROM_CS should be low");
  $display("MemWrite = %b | Addr = %h ", MemWrite, Addr);
  $display("ROM_CS = %b | RAM_CS = %b | RAM_WE = %b \n", ROM_CS, RAM_CS, RAM_WE);

  MemWrite = 1'b1;
  #1;
  $display("EXPECTED: RAM_CS should be high and RAM_WE high with MemWrite high and addr in RAM address range");
  $display("EXPECTED: ROM_CS should be low");
  $display("MemWrite = %b | Addr = %h ", MemWrite, Addr);
  $display("ROM_CS = %b | RAM_CS = %b | RAM_WE = %b \n", ROM_CS, RAM_CS, RAM_WE);

  MemWrite = 1'b0;
  Addr = 32'h00003000;
  #1;
  $display("EXPECTED: All outputs should be low with MemWrite out of RAM/ROM range and MemWrite low");
  $display("MemWrite = %b | Addr = %h ", MemWrite, Addr);
  $display("ROM_CS = %b | RAM_CS = %b | RAM_WE = %b \n", ROM_CS, RAM_CS, RAM_WE);

  MemWrite = 1'b1;
  Addr = 32'h00003000;
  #1;
  $display("EXPECTED: All outputs should be low with MemWrite out of RAM/ROM range and MemWrite high");
  $display("MemWrite = %b | Addr = %h ", MemWrite, Addr);
  $display("ROM_CS = %b | RAM_CS = %b | RAM_WE = %b \n", ROM_CS, RAM_CS, RAM_WE);

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
