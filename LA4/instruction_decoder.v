module instruction_decoder(
	input [6:0] op,
	output MemAdr,  //lw or sw instr
	output ExecuteI, //I type instr
	output ExecuteR, //R type instr
	output BR, //Conditional branches
	output JAL, //JAL
	output LUI, //LUI
	output AUIPC, //AUIPC
	output JALR //JALR
);


	assign MemAdr = ((op == 7'h03) || (op == 7'h23));
	assign ExecuteI = (op == 7'h13);
	assign ExecuteR = (op == 7'h33);
	assign BR = (op == 7'h63);
	assign JAL = (op == 7'h6f);
	assign LUI = (op == 7'h37);
	assign AUIPC = (op == 7'h17);
	assign JALR = (op == 7'h67);

endmodule
