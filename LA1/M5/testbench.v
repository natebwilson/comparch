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

	// instruction decoder
	reg [6:0] op;
	wire MemAdr;
	wire ExecuteI;
	wire ExecuteR;
	wire BR;
	wire JAL;

	instruction_decoder mut(
		.op(op),
		.MemAdr(MemAdr),
		.ExecuteI(ExecuteI),
		.ExecuteR(ExecuteR),
		.BR(BR),
		.JAL(JAL)
	);
	

	initial begin
		
		$display("\n BEGIN TESTS");
		
		// Test op = 7'h03 (lw - MemAdr should be high)
		op = 7'h03; #1;
		`assert(MemAdr, 1'b1, "MemAdr", "op = 7'h03", "MemAdr is high for op 7'h03", "%b")
		`assert(ExecuteI, 1'b0, "ExecuteI", "op = 7'h03", "ExecuteI is low for op 7'h03", "%b")
		`assert(ExecuteR, 1'b0, "ExecuteR", "op = 7'h03", "ExecuteR is low for op 7'h03", "%b")
		`assert(BR, 1'b0, "BR", "op = 7'h03", "BR is low for op 7'h03", "%b")
		`assert(JAL, 1'b0, "JAL", "op = 7'h03", "JAL is low for op 7'h03", "%b")
		
		// Test op = 7'h23 (sw - MemAdr should be high)
		op = 7'h23; #1;
		`assert(MemAdr, 1'b1, "MemAdr", "op = 7'h23", "MemAdr is high for op 7'h23", "%b")
		`assert(ExecuteI, 1'b0, "ExecuteI", "op = 7'h23", "ExecuteI is low for op 7'h23", "%b")
		`assert(ExecuteR, 1'b0, "ExecuteR", "op = 7'h23", "ExecuteR is low for op 7'h23", "%b")
		`assert(BR, 1'b0, "BR", "op = 7'h23", "BR is low for op 7'h23", "%b")
		`assert(JAL, 1'b0, "JAL", "op = 7'h23", "JAL is low for op 7'h23", "%b")
		
		// Test op = 7'h13 (I-type - ExecuteI should be high)
		op = 7'h13; #1;
		`assert(MemAdr, 1'b0, "MemAdr", "op = 7'h13", "MemAdr is low for op 7'h13", "%b")
		`assert(ExecuteI, 1'b1, "ExecuteI", "op = 7'h13", "ExecuteI is high for op 7'h13", "%b")
		`assert(ExecuteR, 1'b0, "ExecuteR", "op = 7'h13", "ExecuteR is low for op 7'h13", "%b")
		`assert(BR, 1'b0, "BR", "op = 7'h13", "BR is low for op 7'h13", "%b")
		`assert(JAL, 1'b0, "JAL", "op = 7'h13", "JAL is low for op 7'h13", "%b")
		
		// Test op = 7'h33 (R-type - ExecuteR should be high)
		op = 7'h33; #1;
		`assert(MemAdr, 1'b0, "MemAdr", "op = 7'h33", "MemAdr is low for op 7'h33", "%b")
		`assert(ExecuteI, 1'b0, "ExecuteI", "op = 7'h33", "ExecuteI is low for op 7'h33", "%b")
		`assert(ExecuteR, 1'b1, "ExecuteR", "op = 7'h33", "ExecuteR is high for op 7'h33", "%b")
		`assert(BR, 1'b0, "BR", "op = 7'h33", "BR is low for op 7'h33", "%b")
		`assert(JAL, 1'b0, "JAL", "op = 7'h33", "JAL is low for op 7'h33", "%b")
		
		// Test op = 7'h63 (Branch - BR should be high)
		op = 7'h63; #1;
		`assert(MemAdr, 1'b0, "MemAdr", "op = 7'h63", "MemAdr is low for op 7'h63", "%b")
		`assert(ExecuteI, 1'b0, "ExecuteI", "op = 7'h63", "ExecuteI is low for op 7'h63", "%b")
		`assert(ExecuteR, 1'b0, "ExecuteR", "op = 7'h63", "ExecuteR is low for op 7'h63", "%b")
		`assert(BR, 1'b1, "BR", "op = 7'h63", "BR is high for op 7'h63", "%b")
		`assert(JAL, 1'b0, "JAL", "op = 7'h63", "JAL is low for op 7'h63", "%b")
		
		// Test op = 7'h6f (JAL - JAL should be high)
		op = 7'h6f; #1;
		`assert(MemAdr, 1'b0, "MemAdr", "op = 7'h6f", "MemAdr is low for op 7'h6f", "%b")
		`assert(ExecuteI, 1'b0, "ExecuteI", "op = 7'h6f", "ExecuteI is low for op 7'h6f", "%b")
		`assert(ExecuteR, 1'b0, "ExecuteR", "op = 7'h6f", "ExecuteR is low for op 7'h6f", "%b")
		`assert(BR, 1'b0, "BR", "op = 7'h6f", "BR is low for op 7'h6f", "%b")
		`assert(JAL, 1'b1, "JAL", "op = 7'h6f", "JAL is high for op 7'h6f", "%b")

		//Test junk opcode
		op = 7'hFF; #1;
		`assert(MemAdr, 1'b0, "MemAdr", "op = 7'hff", "MemAdr is low for op 7'hff", "%b")
		`assert(ExecuteI, 1'b0, "ExecuteI", "op = 7'hff", "ExecuteI is low for op 7'hff", "%b")
		`assert(ExecuteR, 1'b0, "ExecuteR", "op = 7'hff", "ExecuteR is low for op 7'hff", "%b")
		`assert(BR, 1'b0, "BR", "op = 7'hff", "BR is low for op 7'hff", "%b")
		`assert(JAL, 1'b0, "JAL", "op = 7'hff", "JAL is low for op 7'hff", "%b")


		$display("\n Testing Over");
	end

endmodule
