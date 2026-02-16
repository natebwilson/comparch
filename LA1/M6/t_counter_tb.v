`timescale 1 ns / 1 ns

module testbench;

  reg reset;
  reg clock;
  wire T0, T1, T2, T3, T4;

  t_counter dut (
    .reset(reset),
    .clock(clock),
    .T0(T0),
    .T1(T1),
    .T2(T2),
    .T3(T3),
    .T4(T4)
  );

  //clock (10 ns period)
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  initial begin
    $display("begin sim");
    //initial reset
    reset = 1;
    #10;
    reset = 0;

    //10 ns per period, 5 states, so 50ns necessary for full cycle + 5ns for clock to hit rising edge @ start
    #55;

	//wait 2 cycles (to be in middle of operation)
	#20;

    //apply second reset during operation
    reset = 1;
    #15;
    reset = 0;

    //continue running 5 more cycles
    #50;
  end
  initial begin
      #(300);
      $finish;
  end

  initial begin
      $dumpvars(0,testbench);
  end
endmodule
