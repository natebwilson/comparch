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

	// register_file
	reg        reset, clock;
	reg        we3;
	reg  [4:0] a1, a2, a3;
	reg  [31:0] wd3;
	wire [31:0] rd1, rd2;

	register_file rf (
		.reset(reset),
		.clock(clock),
		.we3(we3),
		.a1(a1),
		.a2(a2),
		.a3(a3),
		.wd3(wd3),
		.rd1(rd1),
		.rd2(rd2)
	);

	localparam SIMULATION_END = 2000;

	// clock
	always #50 clock = ~clock;

	// helper task: do a single write on next posedge
	task do_write;
		input [4:0] addr;
		input [31:0] data;
		begin
			@(negedge clock);
			we3 = 1;
			a3  = addr;
			wd3 = data;
			@(posedge clock); #1;
			we3 = 0;
		end
	endtask

	// helper task: set read addresses and let comb settle
	task set_reads;
		input [4:0] ra1;
		input [4:0] ra2;
		begin
			a1 = ra1;
			a2 = ra2;
			#1;
		end
	endtask

	initial begin
		// init
		clock = 0;
		reset = 0;

		we3 = 0;
		a1  = 5'd0;
		a2  = 5'd0;
		a3  = 5'd0;
		wd3 = 32'b0;

		`info("register_file tests")

		// check that write works and that reset clears
		do_write(5'd1, 32'h01010101);
		do_write(5'd2, 32'h02020202);

		set_reads(5'd1, 5'd2);
		`assert(rd1, 32'h01010101, "rd1", "a1=1", "pre-reset: reg1 has written value", "%h")
		`assert(rd2, 32'h02020202, "rd2", "a2=2", "pre-reset: reg2 has written value", "%h")

		reset = 1; #1;
		set_reads(5'd1, 5'd2);
		`assert(rd1, 32'h00000000, "rd1", "reset=1 a1=1", "reset clears reg1", "%h")
		`assert(rd2, 32'h00000000, "rd2", "reset=1 a2=2", "reset clears reg2", "%h")
		reset = 0;

		// check write doesn't work with enable off
		@(negedge clock);
		we3 = 0; a3 = 5'd3; wd3 = 32'h03030303;
		@(posedge clock); #1;

		//this should still be zero
		set_reads(5'd3, 5'd0);
		`assert(rd1, 32'h00000000, "rd1", "we3=0 a1=3", "no write when we3=0", "%h")

		// writes to register 0 are ignored
		do_write(5'd0, 32'h04040404);
		set_reads(5'd0, 5'd3);
		`assert(rd1, 32'h00000000, "rd1", "a1=0 we3=1 a3=0", "writes to reg0 are ignored", "%h")

		// overwrite existing register
		do_write(5'd3, 32'h05050505);
		set_reads(5'd3, 5'd0);
		`assert(rd1, 32'h05050505, "rd1", "a1=3", "reg3 overwrites with new value", "%h")
		`assert(rd2, 32'h00000000, "rd2", "a2=0", "reg0 remains zero", "%h")


		$display("\n Testing Over");
	end

endmodule
