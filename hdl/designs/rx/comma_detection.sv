module comma_detection (
    input BitCLK,
    input Reset,
    input Serial,
    output reg Comma
);

    reg [4:0] last_5_bits;

    always @(posedge BitCLK, negedge Reset) begin
        if (!Reset) begin
            last_5_bits <= 5'b10101;
        end else begin
            last_5_bits = {last_5_bits, Serial};
        end
    end

    always @(posedge BitCLK, negedge Reset) begin
        if (!Reset) begin
            Comma <= 0;
        end else begin
            if (last_5_bits == 5'b00000 || last_5_bits == 5'b11111) begin
                Comma <= 1;
            end else begin
                Comma <= 0;
            end
        end
    end

endmodule