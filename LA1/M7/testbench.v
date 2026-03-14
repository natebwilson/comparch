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

// check_row: sets all inputs, waits 1ns, then asserts all 10 outputs match
`define check_row(label, iT0, iT1, iT2, iT3, iT4, iopb5, iMemAdr, iExecuteI, iExecuteR, iBR, iJAL, eALUSrcA, eALUSrcB, eResultSrc, eAdrSrc, eIRWrite, ePCUpdate, eRegWrite, eMemWrite, eALUOp, eBranch) \
	T0=iT0; T1=iT1; T2=iT2; T3=iT3; T4=iT4; opb5=iopb5; MemAdr=iMemAdr; ExecuteI=iExecuteI; ExecuteR=iExecuteR; BR=iBR; JAL=iJAL; #1;  \
	if (ALUSrcA !== eALUSrcA || ALUSrcB !== eALUSrcB || ResultSrc !== eResultSrc || AdrSrc !== eAdrSrc || IR_Write !== eIRWrite || PC_Update !== ePCUpdate || RegWrite !== eRegWrite || MemWrite !== eMemWrite || AluOp !== eALUOp || Branch !== eBranch) fail_count = fail_count + 1; \
	`assert(ALUSrcA,  eALUSrcA,  "ALUSrcA",  label, label, "%b") \
	`assert(ALUSrcB,  eALUSrcB,  "ALUSrcB",  label, label, "%b") \
	`assert(ResultSrc,eResultSrc,"ResultSrc",label, label, "%b") \
	`assert(AdrSrc,   eAdrSrc,   "AdrSrc",   label, label, "%b") \
	`assert(IR_Write, eIRWrite,  "IR_Write", label, label, "%b") \
	`assert(PC_Update,ePCUpdate, "PC_Update",label, label, "%b") \
	`assert(RegWrite, eRegWrite, "RegWrite", label, label, "%b") \
	`assert(MemWrite, eMemWrite, "MemWrite", label, label, "%b") \
	`assert(AluOp,    eALUOp,    "AluOp",    label, label, "%b") \
	`assert(Branch,   eBranch,   "Branch",   label, label, "%b")

`timescale 1 ns / 1 ns

module testbench;


	integer fail_count = 0;
	reg T0, T1, T2, T3, T4;
	reg MemAdr, ExecuteI, ExecuteR, BR, JAL;
	reg opb5;

	wire [1:0] ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [1:0] ResultSrc;
	wire AdrSrc;
	wire IR_Write;
	wire PC_Update;
	wire RegWrite;
	wire MemWrite;
	wire [1:0] AluOp;
	wire Branch;
	wire EndInstr;

	control_signals_logic mut(
		.T0(T0), .T1(T1), .T2(T2), .T3(T3), .T4(T4),
		.MemAdr(MemAdr), .ExecuteI(ExecuteI), .ExecuteR(ExecuteR),
		.BR(BR), .JAL(JAL), .opb5(opb5),
		.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ResultSrc(ResultSrc),
		.AdrSrc(AdrSrc), .IR_Write(IR_Write), .PC_Update(PC_Update),
		.RegWrite(RegWrite), .MemWrite(MemWrite), .AluOp(AluOp),
		.Branch(Branch), .EndInstr(EndInstr)
	);

	initial begin

		$display("\n BEGIN TESTS");

		//                                       T0 T1 T2 T3 T4 ob5 MA EI ER BR JAL  SrcA    SrcB    Res     Adr   IRW   PCU   RgW   MW    AOp     Br
		`check_row("S0,Fetch",                    1, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  2'b00, 2'b10, 2'b10, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00, 1'b0)
		`check_row("S1,Decod",                    0, 1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  2'b01, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0)
		`check_row("S2,lw",                       0, 0, 1, 0, 0, 0,  1, 0, 0, 0, 0,  2'b10, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0)
		`check_row("S3,Memory Read",              0, 0, 0, 1, 0, 0,  1, 0, 0, 0, 0,  2'b00, 2'b00, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0)
		`check_row("S4, lw writeback",            0, 0, 0, 0, 1, 0,  1, 0, 0, 0, 0,  2'b00, 2'b00, 2'b01, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0)
		`check_row("S2, sw addr calc",            0, 0, 1, 0, 0, 1,  1, 0, 0, 0, 0,  2'b10, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0)
		`check_row("S5, sw mem write",            0, 0, 0, 1, 0, 1,  1, 0, 0, 0, 0,  2'b00, 2'b00, 2'b00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 2'b00, 1'b0)
		`check_row("S6, add",                     0, 0, 1, 0, 0, 1,  0, 0, 1, 0, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S6, sub",                     0, 0, 1, 0, 0, 1,  0, 0, 1, 0, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S6, sll",                     0, 0, 1, 0, 0, 1,  0, 0, 1, 0, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S6, slt",                     0, 0, 1, 0, 0, 1,  0, 0, 1, 0, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S6, or",                      0, 0, 1, 0, 0, 1,  0, 0, 1, 0, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S6, and",                     0, 0, 1, 0, 0, 1,  0, 0, 1, 0, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S7, R-type ALU wb",           0, 0, 0, 1, 0, 1,  0, 0, 1, 0, 0,  2'b00, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0)
		`check_row("S8, addi",                    0, 0, 1, 0, 0, 0,  0, 1, 0, 0, 0,  2'b10, 2'b01, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0)
		`check_row("S7, I-type ALU wb",           0, 0, 0, 1, 0, 0,  0, 1, 0, 0, 0,  2'b00, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0)
		`check_row("S9, jal execute",             0, 0, 1, 0, 0, 1,  0, 0, 0, 0, 1,  2'b01, 2'b10, 2'b00, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00, 1'b0)
		`check_row("S7, jal wb",                  0, 0, 0, 1, 0, 1,  0, 0, 0, 0, 1,  2'b00, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 1'b0)
		`check_row("S10, beq",                    0, 0, 1, 0, 0, 1,  0, 0, 0, 1, 0,  2'b10, 2'b00, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b01, 1'b1)

		if (fail_count == 0)
			$display("\nALL TESTS PASSED");
		else
			$display("\n%0d ROW(S) FAILED", fail_count);
		$display("\n Testing Over");
	end

endmodule
