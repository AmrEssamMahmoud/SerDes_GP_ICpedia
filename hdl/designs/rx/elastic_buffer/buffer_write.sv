module buffer_write #(
    parameter ADDRESS_WIDTH = 4
) (
    input recovered_clock, recovered_reset,
    input [9:0] data_in,
    input [ADDRESS_WIDTH:0] read_pointer_sync,
    output reg [ADDRESS_WIDTH:0] write_pointer_async,
    output reg skip_removed, overflow
);

    localparam COMMA_SYMBOL = 10'h1BC;
    localparam SKIP_SYMBOL = 10'h1A1;
    localparam REMOVE_THRESHOLD = 10;

    localparam WAITING_FOR_COMMA = 0;
    localparam COMMA_DETECTED = 1;
    localparam SKIP_AND_STALL = 2;

    reg full, prev_full;
    reg [ADDRESS_WIDTH-1:0] fill_level;
    reg [1:0] current_state, next_state;

    always @(posedge recovered_clock or negedge recovered_reset) begin
        if (!recovered_reset) begin
            current_state <= WAITING_FOR_COMMA;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        skip_removed = 0;
        case (current_state)
            WAITING_FOR_COMMA:
                if (data_in == COMMA_SYMBOL)
                    next_state = COMMA_DETECTED;
                else
                    next_state = WAITING_FOR_COMMA;
            COMMA_DETECTED:
                if (data_in == SKIP_SYMBOL && fill_level >= REMOVE_THRESHOLD) begin
                    next_state = SKIP_AND_STALL;
                    skip_removed = 1;
                end else
                    next_state = WAITING_FOR_COMMA;
            SKIP_AND_STALL: begin
                next_state = WAITING_FOR_COMMA;
                skip_removed = 1;
            end
            default:
                next_state = WAITING_FOR_COMMA;
        endcase
    end

    always @(posedge recovered_clock or negedge recovered_reset) begin
        if (!recovered_reset) begin
            write_pointer_async <= 0;
        end else begin
            if (!skip_removed) begin
                write_pointer_async <= write_pointer_async + 1;
            end
        end
    end

    always @(posedge recovered_clock or negedge recovered_reset) begin
        if (!recovered_reset) begin
            fill_level <= 0;
        end else begin
            if (write_pointer_async >= read_pointer_sync) begin
                fill_level <= write_pointer_async - read_pointer_sync;
            end else begin
                fill_level <= 32 + write_pointer_async - read_pointer_sync;
            end
        end
    end

    always @(posedge recovered_clock or negedge recovered_reset) begin
        if (!recovered_reset) begin
            overflow <= 0;
        end else begin
            full <= write_pointer_async[ADDRESS_WIDTH] != read_pointer_sync[ADDRESS_WIDTH] && write_pointer_async[ADDRESS_WIDTH-1:0] == read_pointer_sync[ADDRESS_WIDTH-1:0];
            prev_full <= full;
            if (prev_full && fill_level == 1) begin
                overflow <= 1;
            end else begin
                overflow <= 0;
            end
        end
    end

endmodule