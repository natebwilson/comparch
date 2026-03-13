`timescale 1ns / 1ns

module testbench;

   wire	[31:0] Addr;
   wire        clock;
   wire        MemWrite;
   wire        RAM_CS;
   wire        RAM_WE;
   wire [31:0] ReadData;
   wire        reset;
   wire        ROM_CS;
   wire [31:0] WriteData;

   localparam SIMULATION_END = 5000;

   reset_clock	b2v_reset_clock_0(
	.reset(reset),
	.clock(clock));

   cpu	b2v_RISCV(
	.reset(reset),
	.clock(clock),
	.ReadData(ReadData),
	.MemWrite(MemWrite),
	.Addr(Addr),
	.WriteData(WriteData));

   address_decoder	b2v_address_decoder_0(
	.MemWrite(MemWrite),
	.Addr(Addr),
	.RAM_CS(RAM_CS),
	.RAM_WE(RAM_WE),
	.ROM_CS(ROM_CS));

   ROM_memory	b2v_ROM_0(
	.CS(ROM_CS),
	.Addr(Addr[12:0]),
	.RD(ReadData));
	defparam	b2v_ROM_0.filename = "riscv.txt";

   RAM_memory	b2v_RAM_0(
	.clock(clock),
	.CS(RAM_CS),
	.WE(RAM_WE),
	.Addr(Addr[11:0]),
	.WD(WriteData),
	.RD(ReadData));

   // This initial block waits for SIMULATION_END unit delays, and then the
   // system function, $finish, ends the simulation. Need if using APIO but
   // not if using Modelsim.
   initial begin
      #(SIMULATION_END);
        $display("x0 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[0], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[0]);
        $display("x1 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[1], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[1]);
        $display("x2 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[2], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[2]);
        $display("x3 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[3], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[3]);
        $display("x4 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[4], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[4]);
        $display("x5 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[5], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[5]);
        $display("x6 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[6], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[6]);
        $display("x7 = %0d (0x%h)", b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[7], b2v_RISCV.b2v_datapath_0.b2v_rf_0.Q[7]);
      $finish;
   end

   // This initial block will "dump" all of the simulation information so that
   // it can be viewed in a waveform viewer. Needed if using APIO but not needed
   // if using Modelsim.
   initial begin
      $dumpvars(0,testbench);
   end

endmodule
