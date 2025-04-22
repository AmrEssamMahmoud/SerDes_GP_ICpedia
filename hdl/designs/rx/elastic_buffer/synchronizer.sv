module synchronizer #(
    parameter ADDRESS_WIDTH = 4
) (
    input clock, reset,
    input wire [ADDRESS_WIDTH:0] pointer_async,
    output reg [ADDRESS_WIDTH:0] pointer_sync
);

int i;
reg [ADDRESS_WIDTH:0] pointer_chain [0:2];

// binary to gray: pointer_async -> pointer_chain[0]
always @(*) begin
    pointer_chain[0][ADDRESS_WIDTH] = pointer_async[ADDRESS_WIDTH];
    for (i = 0; i < ADDRESS_WIDTH; i = i + 1) begin
        pointer_chain[0][i] = pointer_async[i] ^ pointer_async[i+1];
    end
end

// synchronization flip-flops
always @(posedge clock or negedge reset) begin
    if (!reset) begin
        pointer_chain[0] <= 0;
        pointer_chain[1] <= 0;
        pointer_chain[2] <= 0;
    end else begin
        pointer_chain[1] <= pointer_chain[0];
        pointer_chain[2] <= pointer_chain[1];
    end
end

// gray to binary: pointer_chain[2] -> pointer_sync
always @(*) begin
    pointer_sync[ADDRESS_WIDTH] = pointer_chain[2][ADDRESS_WIDTH];
    for (i = ADDRESS_WIDTH-1; i >= 0; i = i - 1) begin
        pointer_sync[i] = pointer_chain[2][i] ^ pointer_sync[i+1];
    end
end


endmodule