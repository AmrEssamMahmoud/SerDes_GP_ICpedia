module SIPO(
    input BitCLK,
    input Reset,
    output reg [9:0] RxParallel_10,
    input Serial,
    input Comma
);
    reg [9:0] TR; // 10-bit shift register
    reg [3:0] count; // 4-bit counter

    always @(posedge BitCLK or negedge Reset) begin
        if (!Reset) begin
            count <= 4'b0000; // Reset the counter
            TR <= 10'b0; // Reset the shift register
        end else begin
            case (count)
                4'b0000: TR[0] <= Serial;
                4'b0001: TR[1] <= Serial;
                4'b0010: TR[2] <= Serial;
                4'b0011: TR[3] <= Serial;
                4'b0100: TR[4] <= Serial;
                4'b0101: TR[5] <= Serial;
                4'b0110: TR[6] <= Serial;
                4'b0111: TR[7] <= Serial;
                4'b1000: TR[8] <= Serial;
                4'b1001: TR[9] <= Serial;
                default: ; // No operation for other cases
            endcase
            
            if (count == 4'b1001 || Comma) begin
                count <= 4'b0000; // Reset the counter after reaching 9
            end else begin
                count <= count + 1; // Increment the counter
            end
        end
    end

    always @(posedge BitCLK, negedge Reset) begin
        if (!Reset) begin
            RxParallel_10 <= 0;
        end else begin
            if (count == 0) begin
                RxParallel_10 <= TR;
            end
        end
    end

endmodule
