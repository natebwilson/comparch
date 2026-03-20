module ALU(
	input [31:0] A,
	input [31:0] B,
	input [3:0] ALUcontrol,
	output reg [31:0] result,
	output [3:0] flags);
	
	wire [31:0] condinvb, sum;
	wire v, c, n, z;
	wire cout;
	
	wire Condition1;
	assign Condition1 = (~ALUcontrol[3] & ~ALUcontrol[2] & ~ALUcontrol[1]) | (~ALUcontrol[3] & ~ALUcontrol[1] & ALUcontrol[0]);
	
	wire Condition2;
	assign Condition2 = (A[31] ^ sum[31]);
	
	wire Condition3;
	assign Condition3 = ~(A[31] ^ B[31] ^ ALUcontrol[0]);
	
	assign condinvb = B ^ {32{ALUcontrol[0]}};
	assign {cout, sum} = A + condinvb + {31'b0, ALUcontrol[0]};
	assign flags = {v, c, n ,z};
	assign z = (result == 32'b0);
	assign n = result[31];
	assign c = cout & Condition1;
	assign v = Condition1 & Condition2 & Condition3;
	
	always @(ALUcontrol, sum, A, B, v, c, cout)
		case (ALUcontrol)
			4'b0000: result <= sum;
			4'b0001: result <= sum;
			4'b0010: result <= A & B;
			4'b0011: result <= A | B;
			4'b0100: result <= A ^ B;
			4'b0101: result <= {31'b0, (sum[31] ^v)};
			4'b0110: result <= A << B[4:0];
			4'b0111: result <= A >> B[4:0];
			4'b1000: result <= $signed(A) >>> B[4:0];
			4'b1001: result <= {31'b0, ~cout}; //cout is passively calculated
			default: result <= 32'bx;
		endcase
endmodule
			
	
