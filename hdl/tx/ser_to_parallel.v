module ser_to_parallel(
    input clk,
    input rst,
    output [9:0] op,
    input ip
);
    reg [9:0] TR; // 10-bit shift register
    reg [3:0] count; // 4-bit counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000; // Reset the counter
            TR <= 10'b0; // Reset the shift register
        end else begin
            case (count)
                4'b0000: TR[0] <= ip;
                4'b0001: TR[1] <= ip;
                4'b0010: TR[2] <= ip;
                4'b0011: TR[3] <= ip;
                4'b0100: TR[4] <= ip;
                4'b0101: TR[5] <= ip;
                4'b0110: TR[6] <= ip;
                4'b0111: TR[7] <= ip;
                4'b1000: TR[8] <= ip;
                4'b1001: TR[9] <= ip;
                default: ; // No operation for other cases
            endcase
            
            if (count == 4'b1001) begin
                count <= 4'b0000; // Reset the counter after reaching 9
            end else begin
                count <= count + 1; // Increment the counter
            end
        end
    end

    assign op = TR; // Output the 10-bit value
endmodule
