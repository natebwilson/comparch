`define assert(actual, expected, outputName, inputs, description, type) \
if (actual == expected) begin \
	$display("\nPASSED"); \
end \
else begin \
	$display("\nFAILED"); \
end \
$display("ACTUAL ", type, actual); \
$display("EXPECTED ", type, expected); \
$display("TESTED SIGNAL NAME %s", outputName); \
$display("INPUTS %s", inputs); \
if (description) begin \
	$display("DESCRIPTION %s", description); \
end \
$write("TIME "); \
$display($realtime);

`define info(message) \
$display("INFO %s", message); \
$write("TIME "); \
$display($realtime);

`timescale 1 ns / 1 ns

module testbench;

	// ---- mux2 ----
	reg  [7:0] d0_2, d1_2;
	reg        sel2;
	wire [7:0] y2;

	// ---- mux3 ----
	reg  [7:0] d0_3, d1_3, d2_3;
	reg  [1:0] sel3;
	wire [7:0] y3;

	// ---- register_n ----
	reg        reset, clock, enable;
	reg  [7:0] D;
	wire [7:0] Q;

	// DUTs (parameter left default WIDTH=8)
	mux2 m2 (
		.d0(d0_2),
		.d1(d1_2),
		.sel(sel2),
		.y(y2)
	);

	mux3 m3 (
		.d0(d0_3),
		.d1(d1_3),
		.d2(d2_3),
		.sel(sel3),
		.y(y3)
	);

	register_n rn (
		.reset(reset),
		.clock(clock),
		.enable(enable),
		.D(D),
		.Q(Q)
	);

	localparam SIMULATION_END = 2000;

	// clock for register_n
	always #50 clock = ~clock;

	initial begin

		// init

		clock  = 0;
		reset  = 0;
		enable = 0;
		D      = 8'h00;

		d0_2 = 8'h00; d1_2 = 8'h00; sel2 = 0;
		d0_3 = 8'h00; d1_3 = 8'h00; d2_3 = 8'h00; sel3 = 2'b00;

		// mux2 tests

		`info("mux2 tests")

		d0_2 = 8'hA5; d1_2 = 8'h5A; sel2 = 0; #1;
		`assert(y2, 8'hA5, "y2", "d0=8'hA5 d1=8'h5A sel=0", "mux2 selects d0", "%h")

		sel2 = 1; #1;
		`assert(y2, 8'h5A, "y2", "d0=8'hA5 d1=8'h5A sel=1", "mux2 selects d1", "%h")

		d0_2 = 8'h00; d1_2 = 8'hFF; sel2 = 0; #1;
		`assert(y2, 8'h00, "y2", "d0=8'h00 d1=8'hFF sel=0", "mux2 selects d0", "%h")

		sel2 = 1; #1;
		`assert(y2, 8'hFF, "y2", "d0=8'h00 d1=8'hFF sel=1", "mux2 selects d1", "%h")


		// mux3 tests
		// sel3 = 00 -> d0
		// sel3 = 01 -> d1
		// sel3 = 1x -> d2  (because second stage selects d2 whenever sel3[1]=1)

		`info("mux3 tests")

		d0_3 = 8'h11; d1_3 = 8'h22; d2_3 = 8'h33;

		sel3 = 2'b00; #1;
		`assert(y3, 8'h11, "y3", "d0=11 d1=22 d2=33 sel=00", "mux3 selects d0", "%h")

		sel3 = 2'b01; #1;
		`assert(y3, 8'h22, "y3", "d0=11 d1=22 d2=33 sel=01", "mux3 selects d1", "%h")

		sel3 = 2'b10; #1;
		`assert(y3, 8'h33, "y3", "d0=11 d1=22 d2=33 sel=10", "mux3 selects d2", "%h")

		sel3 = 2'b11; #1;
		`assert(y3, 8'h33, "y3", "d0=11 d1=22 d2=33 sel=11", "mux3 selects d2", "%h")


		`info("register_n tests")
		
		//register n tests

		//check reset clears
		enable = 1;
		D = 8'hAB;
		reset = 1; #1;
		`assert(Q, 8'h00, "Q", "reset=1", "reset clears Q", "%h")
		reset = 0;

		//check that Q is held
		@(negedge clock);
		D = 8'h12; enable = 1;
		@(posedge clock); #1;
		`assert(Q, 8'h12, "Q", "enable=1 D=12", "loads D", "%h")

		@(negedge clock);
		D = 8'h34; enable = 0;
		@(posedge clock); #1;
		`assert(Q, 8'h12, "Q", "enable=0 D=34", "holds previous Q", "%h")

		//check new D loads
		@(negedge clock);
		D = 8'hFE; enable = 1;
		@(posedge clock); #1;
		`assert(Q, 8'hFE, "Q", "enable=1 D=FE", "loads new D", "%h")

		#100;

		$display("\n Testing Over");
	

	end

endmodule
