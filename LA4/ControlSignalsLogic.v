module ControlSignalsLogic
(
    input  T0,
	input T1,
	input T2,
	input T3,
	input T4,
	input MemAdr,
	input ExecuteI,
	input ExecuteR,
	input BR,
	input JAL,
	input LUI,
	input AUIPC,
	input JALR,
	input opb5,
	output [1:0] ALUSrcA,
	output [1:0] ALUSrcB,
	output [1:0] ResultSrc,
	output AdrSrc,
	output IR_Write,
	output PC_Update,
	output RegWrite,
	output MemWrite,
	output [1:0] ALUOp,
	output Branch,
	output EndInstr
	);
	
	
	assign ALUSrcA[1] = (T2 & MemAdr) | (T2 & ExecuteR) | (T2 & ExecuteI) | (T2 & BR) | (T2 & LUI) | (T2 & JALR);
	assign ALUSrcA[0] = T1 | (T2 & JAL) | (T2 & AUIPC) | (T3 & JALR);

	assign EndInstr = ((MemAdr & opb5 & T4) | (T4 & ExecuteR) | (T4 & ExecuteI) | (T4 & JAL) | (T3 & BR) | (T4 & LUI) | (T4 & AUIPC) | (T4 & JALR));

	assign ALUSrcB[1] = T0 | (T2 & opb5 & JAL) | (T3 & JALR);
	assign ALUSrcB[0] = (T1 | (T2 & MemAdr) | (T2 & opb5 & MemAdr) | (T2 & ExecuteI) | (T2 & LUI) | (T2 & AUIPC) | (T2 & JALR));

	assign ResultSrc[1] = T0 | (T2 & JALR) | (T3 & JALR);
	assign ResultSrc[0] = (T4 & MemAdr);

	assign AdrSrc = (T3 & MemAdr) | (T3 & opb5 & MemAdr);

	assign IR_Write = T0;

	assign PC_Update = T0 | (T2 & opb5 & JAL) | (T2 & JALR);

	assign RegWrite = (T4 & MemAdr) | (T3 & opb5 & ExecuteR) | (T3 & ExecuteI) | (T3 & opb5 & JAL) | (T3 & LUI) | (T3 & AUIPC) | (T3 & JALR);

	assign MemWrite = T3 & opb5 & MemAdr;

	assign ALUOp[1] = (T2 & opb5 & ExecuteR) | (T2 & ExecuteI);
	assign ALUOp[0] = (T2 & opb5 & BR);

	assign Branch = (T2 & opb5 & BR);
	
endmodule
