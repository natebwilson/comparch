module t_counter
(
    input  reset,
    input  clock,
    output T0,
    output T1,
    output T2,
    output T3,
    output T4);
	  
	reg [2:0] t_count;
	reg [2:0] t_count_ns;

    //current_state
    always @(posedge reset, posedge clock)
        if (reset == 1)
            t_count <= 3'b000;
        else
            t_count <= t_count_ns;


    //next_state
    always @(t_count)
        if (t_count == 3'b100)
            t_count_ns <= 3'b000;
        else
            t_count_ns <= t_count + 3'b001;

    //output logic
		assign T0 = ~t_count[2] & ~t_count[1] & ~t_count[0]; // 000
		assign T1 = ~t_count[2] & ~t_count[1] &  t_count[0]; // 001
		assign T2 = ~t_count[2] &  t_count[1] & ~t_count[0]; // 010
		assign T3 = ~t_count[2] &  t_count[1] &  t_count[0]; // 011
		assign T4 =  t_count[2] & ~t_count[1] & ~t_count[0]; // 100

endmodule


