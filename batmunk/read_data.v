module read_data (
    input  wire [31:0] ReadData,
    input  wire [1:0]  Addr,
    input  wire [2:0]  LoadType,
    output reg  [31:0] DataOut
);

    reg [7:0]  selected_byte;
    reg [15:0] selected_half;

    always @(*) begin
        // byte select
        case (Addr)
            2'b00: selected_byte = ReadData[7:0];
            2'b01: selected_byte = ReadData[15:8];
            2'b10: selected_byte = ReadData[23:16];
            2'b11: selected_byte = ReadData[31:24];
            default: selected_byte = 8'b0;
        endcase

        // half-word select
        case (Addr[1])
            1'b0: selected_half = ReadData[15:0];
            1'b1: selected_half = ReadData[31:16];
            default: selected_half = 16'b0;
        endcase

        // load formatting
        case (LoadType)
            3'b000: DataOut = ReadData;                        // lw
            3'b001: DataOut = {24'b0, selected_byte};         // lbu
            3'b010: DataOut = {{24{selected_byte[7]}}, selected_byte};   // lb
            3'b100: DataOut = {16'b0, selected_half};         // lhu
            3'b101: DataOut = {{16{selected_half[15]}}, selected_half};  // lh
            default: DataOut = ReadData;
        endcase
    end

endmodule
