module instruction_decoder(
	input [6:0] op,
	output MemAdr,  //lw or sw instr
	output ExecuteI, //I type instr
	output ExecuteR, //R type instr
	output BR, //Conditional branches
	output JAL //JAL
);


	assign MemAdr = ((op == 7'h03) || (op == 7'h23));
	assign ExecuteI = (op == 7'h13);
	assign ExecuteR = (op == 7'h33);
	assign BR = (op == 7'h63);
	assign JAL = (op == 7'h6f);

endmodule
