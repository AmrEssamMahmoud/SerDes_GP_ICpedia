module buffer_read #(
    parameter ADDRESS_WIDTH = 4
) (
    input local_clock, local_reset,
    output [9:0] data_out,
    input [ADDRESS_WIDTH:0] write_pointer_sync,
    output reg [ADDRESS_WIDTH:0] read_pointer_async,
    output reg skip_added, underflow
);

    localparam COMMA_SYMBOL = 10'h1BC;
    localparam SKIP_SYMBOL = 10'h1A1;
    localparam ADD_THRESHOLD = 5;

    localparam WAITING_FOR_COMMA = 0;
    localparam COMMA_DETECTED = 1;
    localparam SKIP_AND_STALL = 2;
    localparam SKIP_AND_CONTINUE = 3;

    reg empty, prev_empty;
    reg [ADDRESS_WIDTH-1:0] fill_level;
    reg [1:0] current_state, next_state;
    reg [3:0] start_count;

    always @(posedge local_clock or negedge local_reset) begin
        if (!local_reset) begin
            current_state <= WAITING_FOR_COMMA;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        skip_added = 0;
        case (current_state)
            WAITING_FOR_COMMA:
                if (data_out == COMMA_SYMBOL)
                    next_state = COMMA_DETECTED;
                else
                    next_state = WAITING_FOR_COMMA;
            COMMA_DETECTED:
                if (data_out == SKIP_SYMBOL && fill_level <= ADD_THRESHOLD) begin
                    next_state = SKIP_AND_STALL;
                    skip_added = 1;
                end else
                    next_state = WAITING_FOR_COMMA;
            SKIP_AND_STALL: begin
                next_state = SKIP_AND_CONTINUE;
                skip_added = 1;
            end
            SKIP_AND_CONTINUE:
                next_state = WAITING_FOR_COMMA;
            default:
                next_state = WAITING_FOR_COMMA;
        endcase
    end

    always @(posedge local_clock or negedge local_reset) begin
        if (!local_reset) begin
            start_count <= 0;
        end else begin
            if (start_count < 7) begin
                start_count <= start_count + 1;
            end
        end
    end

    always @(posedge local_clock or negedge local_reset) begin
        if (!local_reset) begin
            read_pointer_async <= 0;
        end else begin
            if (start_count > 6 && !skip_added) begin
                read_pointer_async <= read_pointer_async + 1;
            end
        end
    end

    always @(posedge local_clock or negedge local_reset) begin
        if (!local_reset) begin
            fill_level <= 0;
        end else begin
            if (write_pointer_sync >= read_pointer_async) begin
                fill_level <= write_pointer_sync - read_pointer_async;
            end else begin
                fill_level <= 32 + write_pointer_sync - read_pointer_async;
            end
        end
    end

    always @(posedge local_clock or negedge local_reset) begin
        if (!local_reset) begin
            underflow <= 0;
        end else begin
            empty <= write_pointer_sync == read_pointer_async;
            prev_empty <= empty;
            if (prev_empty && fill_level == 15) begin
                underflow <= 1;
            end else begin
                underflow <= 0;
            end
        end
    end

endmodule