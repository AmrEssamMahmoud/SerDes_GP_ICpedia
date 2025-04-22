module buffer_memory #(
    parameter BUFFER_DEPTH = 16,
    parameter ADDRESS_WIDTH = 4
) (
    input recovered_clock, recovered_reset, local_clock, local_reset,
    input [ADDRESS_WIDTH-1:0] write_pointer, read_pointer,
    input [9:0] data_in,
    output reg [9:0] data_out
);
    
    integer i;
    reg [9:0] memory [0:BUFFER_DEPTH-1];

    always@ (posedge recovered_clock or negedge recovered_reset) begin
        if (!recovered_reset) begin
            for (i = 0; i < BUFFER_DEPTH; i = i + 1) begin        
                memory[i] <= 0;
            end
        end else begin
            memory[write_pointer] <= data_in;
        end
    end

    always @(posedge local_clock or negedge local_reset) begin
        if (!local_reset) begin
            data_out <= 0;
        end else begin
            data_out = memory[read_pointer];
        end
    end

endmodule