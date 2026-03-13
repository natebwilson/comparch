module mux3
#(parameter WIDTH = 8)
 (
 input [WIDTH-1:0] d0,
 input [WIDTH-1:0] d1,
 input [WIDTH-1:0] d2,
 input [1:0]sel,
 output [WIDTH-1:0] y
 );
// Your implementation here


wire [WIDTH-1:0] w;

mux2 #(.WIDTH(WIDTH)) m0 (
	.d0 (d0),
	.d1 (d1),
	.sel(sel[0]),
	.y (w)
);

mux2 #(.WIDTH(WIDTH)) m1 (
	.d0 (w),
	.d1 (d2),
	.sel(sel[1]),
	.y (y)
);


endmodule