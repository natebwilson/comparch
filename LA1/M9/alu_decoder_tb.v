`timescale 1 ns / 1 ns

module testbench;

  reg [1:0] ALUOp;
  reg [2:0] Funct3;
  reg Funct7b5;
  reg opb5;
  wire [2:0] ALUControl;



  alu_decoder dut (
    .ALUOp(ALUOp),
    .Funct3(Funct3),
    .Funct7b5(Funct7b5),
    .opb5(opb5),
    .ALUControl(ALUControl)
  );


  initial begin
    #40;
    $display("\n \nbegin sim");
    //initial reset

    $display("Set ALUOp 00");
    ALUOp = 2'b00;
    #10;
    $display("ALUControl=%b (expected 000)", ALUControl);

    $display("Set ALUOp 01");
    ALUOp = 2'b01;
    #10;
    $display("ALUControl=%b (expected 001)", ALUControl);

    $display("\n Remaining tests performed with ALUOp = 10\n");
    ALUOp = 2'b10;

    $display("Following tests performed with Funct3 = 000");
    Funct3 = 3'b000;

    $display("Test {Funct7b5, opb5} = 00, 01, 10, 11");

    Funct7b5 = 1'b0;
    opb5 = 1'b0;
    #10;
    $display("00: ALUControl=%b (expected 000)", ALUControl);

    Funct7b5 = 1'b0;
    opb5 = 1'b1;
    #10;
    $display("01: ALUControl=%b (expected 000)", ALUControl);

    Funct7b5 = 1'b1;
    opb5 = 1'b0;
    #10;
    $display("10: ALUControl=%b (expected 000)", ALUControl);

    Funct7b5 = 1'b1;
    opb5 = 1'b1;
    #10;
    $display("11: ALUControl=%b (expected 001)", ALUControl);

    $display("\n {Funct7b5, opb5} testing concluding, now iterating through remaining Funct3 values\n");

    $display("Set Funct3 = 111");
    Funct3 = 3'b111;
    #10;
    $display("ALUControl=%b (expected 010)", ALUControl);

    $display("Set Funct3 = 110");
    Funct3 = 3'b110;
    #10;
    $display("ALUControl=%b (expected 011)", ALUControl);

    $display("Set Funct3 = 010");
    Funct3 = 3'b010;
    #10;
    $display("ALUControl=%b (expected 101)", ALUControl);

    $display("Set Funct3 = 001");
    Funct3 = 3'b001;
    #10;
    $display("ALUControl=%b (expected 110)", ALUControl);

    $display("\n Testing Concluded");

  end
  initial begin
      #(200);
      $finish;
  end

  initial begin
      $dumpvars(0,testbench);
  end
endmodule
