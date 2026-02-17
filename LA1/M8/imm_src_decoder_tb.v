`timescale 1 ns / 1 ns

module testbench;

  reg [6:0] opcode;
  wire [2:0] ImmSrc;

  imm_src_decoder dut (
    .opcode(opcode),
    .ImmSrc(ImmSrc)
  );


  initial begin
    #40;
    $display("\n \nbegin sim");
    //initial reset

    $display("set opcode = 3, expect ImmSrc = 000");
    opcode = 7'd3;
    #10;
    $display("ImmSrc=%b (expected 000)", ImmSrc);

    $display("set opcode = 19, expect ImmSrc = 000");
    opcode = 7'd19;
    #10;
    $display("ImmSrc=%b (expected 000)", ImmSrc);

    $display("set opcode = 35, expect ImmSrc = 001");
    opcode = 7'd35;
    #10;
    $display("ImmSrc=%b (expected 001)", ImmSrc);

    $display("set opcode = 99, expect ImmSrc = 010");
    opcode = 7'd99;
    #10;
    $display("ImmSrc=%b (expected 010)", ImmSrc);

    $display("set opcode = 99, expect ImmSrc = 010");
    opcode = 7'd99;
    #10;
    $display("ImmSrc=%b (expected 010)", ImmSrc);

    $display("set opcode = 111, expect ImmSrc = 011");
    opcode = 7'd111;
    #10;
    $display("ImmSrc=%b (expected 011)", ImmSrc);

    $display("set opcode = 20, expect ImmSrc = 000");
    opcode = 7'd20;
    #10;
    $display("ImmSrc=%b (expected 000)", ImmSrc);

    $display("\n \n");
  end
  initial begin
      #(200);
      $finish;
  end

  initial begin
      $dumpvars(0,testbench);
  end
endmodule
