module usb3_elastic_buffer (
    // Recovered Clock Domain signals
    input wire          rclk,        // Recovered clock
    input wire          rrst_n,      // Recovered clock domain reset, active low
    input wire [9:0]    data_in,     // Input data (10 bits)
    input wire          data_in_vld, // Input data valid
    output wire         full,        // Buffer full indicator
    
    // Local Clock Domain signals
    input wire          lclk,        // Local clock
    input wire          lrst_n,      // Local clock domain reset, active low
    output reg [9:0]    data_out,    // Output data (10 bits)
    output reg          data_out_vld,// Output data valid
    output wire         empty        // Buffer empty indicator
);

    // Define USB 3.0 SKP ordered-set symbols
    // In USB 3.0, a SKP ordered set is a COM symbol followed by one or more SKP symbols
    localparam [9:0] COM_SYM = 10'h1BC; // COM symbol (K28.5)  not accurate
    localparam [9:0] SKP_SYM = 10'h1A1; // SKP symbol (K28.1)  not accurate
    
    // Buffer size parameters
    localparam FIFO_DEPTH = 16;         // Total buffer depth
    localparam ADDR_WIDTH = 4;          // Address width = log2(FIFO_DEPTH)
    
    // SKP handling thresholds - USB 3.0 uses the nominal half-full approach
    localparam HALF_FULL = 8;           // Half-full nominal position
    localparam ADD_THRESHOLD = 5;       // Add SKP below this level
    localparam DEL_THRESHOLD = 11;      // Delete SKP above this level
    
    // Memory element (dual-port RAM)
    reg [9:0] mem [0:FIFO_DEPTH-1];
    
    // Write pointer control (Recovered Clock Domain)
    reg [ADDR_WIDTH-1:0] wr_ptr_bin;       // Binary write pointer
    reg [ADDR_WIDTH-1:0] wr_ptr_gray;      // Gray-coded write pointer
    wire [ADDR_WIDTH-1:0] wr_ptr_bin_next;
    wire [ADDR_WIDTH-1:0] wr_ptr_gray_next;
    
    // Read pointer control (Local Clock Domain)
    reg [ADDR_WIDTH-1:0] rd_ptr_bin;       // Binary read pointer
    reg [ADDR_WIDTH-1:0] rd_ptr_gray;      // Gray-coded read pointer
    wire [ADDR_WIDTH-1:0] rd_ptr_bin_next;
    wire [ADDR_WIDTH-1:0] rd_ptr_gray_next;
    
    // Synchronization registers for crossing clock domains
    reg [ADDR_WIDTH-1:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2; // Sync to local clock
    reg [ADDR_WIDTH-1:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2; // Sync to recovered clock
    
    // Binary converted synchronized pointers
    wire [ADDR_WIDTH-1:0] wr_ptr_sync_bin; // Write pointer in local clock domain
    wire [ADDR_WIDTH-1:0] rd_ptr_sync_bin; // Read pointer in recovered clock domain
    
    // SKP ordered-set detection and handling 
    reg [1:0] skp_seq_state;             // State machine for SKP ordered-set detection
    localparam SKP_IDLE = 2'b00;         // Not in SKP ordered-set
    localparam SKP_FOUND = 2'b01;        // COM symbol detected, in a SKP ordered-set
    
    reg skp_ordered_set;                 // Currently in a SKP ordered-set
    reg skp_com_detected;                // COM symbol detected
    reg skp_delete;                      // Flag to delete current SKP
    reg skp_add;                         // Flag to add SKP symbols
    reg [1:0] skp_add_count;             // Counter for adding multiple SKP symbols
    
    // Control signals
    reg write_pause;                     // Pause write pointer for SKP removal
    reg read_pause;                      // Pause read pointer flag
    
    // Buffer fill level tracking
    reg [ADDR_WIDTH:0] fill_level;       // Current buffer fill level
    
    // Convert from Gray code to binary
    function [ADDR_WIDTH-1:0] gray2bin;
        input [ADDR_WIDTH-1:0] gray;
        reg [ADDR_WIDTH-1:0] bin;
        integer i;
        begin
            bin = 0;
            for (i = 0; i < ADDR_WIDTH; i = i + 1)
                bin[i] = ^(gray >> i);
            gray2bin = bin;
        end
    endfunction
    
    // Convert from binary to Gray code
    function [ADDR_WIDTH-1:0] bin2gray;
        input [ADDR_WIDTH-1:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    // Calculate fill level based on synchronized pointers
    always @* begin
        if (wr_ptr_sync_bin >= rd_ptr_bin)
            fill_level = wr_ptr_sync_bin - rd_ptr_bin;
        else
            fill_level = FIFO_DEPTH + wr_ptr_sync_bin - rd_ptr_bin;
    end
    
    // SKP ordered-set detection (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            skp_seq_state <= SKP_IDLE;
            skp_ordered_set <= 1'b0;
            skp_com_detected <= 1'b0;
        end else if (data_in_vld) begin
            case (skp_seq_state)
                SKP_IDLE: begin
                    if (data_in == COM_SYM) begin
                        skp_seq_state <= SKP_FOUND;
                        skp_com_detected <= 1'b1;
                        skp_ordered_set <= 1'b1;
                    end else begin
                        skp_com_detected <= 1'b0;
                        skp_ordered_set <= 1'b0;
                    end
                end
                
                SKP_FOUND: begin
                    skp_com_detected <= 1'b0;
                    if (data_in == SKP_SYM) begin
                        // Continue in SKP ordered-set
                        skp_ordered_set <= 1'b1;
                    end else if (data_in == COM_SYM) begin
                        // New COM detected - start new ordered set
                        skp_com_detected <= 1'b1;
                        skp_ordered_set <= 1'b1;
                    end else begin
                        // End of SKP ordered-set
                        skp_seq_state <= SKP_IDLE;
                        skp_ordered_set <= 1'b0;
                    end
                end
                
                default: begin
                    skp_seq_state <= SKP_IDLE;
                    skp_ordered_set <= 1'b0;
                    skp_com_detected <= 1'b0;
                end
            endcase
        end
    end
    
    // SKP symbol removal control logic (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            skp_delete <= 1'b0;
        end else begin
            // Delete SKP symbols only if:
            // 1. We're in a SKP ordered-set
            // 2. Current symbol is a SKP (not the COM)
            // 3. Buffer fill level exceeds deletion threshold
            skp_delete <= skp_ordered_set && !skp_com_detected && 
                          (data_in == SKP_SYM) && (fill_level > DEL_THRESHOLD);
        end
    end
    
    // Write pointer and memory write control (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            wr_ptr_bin = {ADDR_WIDTH{HALF_FULL}};
            wr_ptr_gray = bin2gray(wr_ptr_bin);
            write_pause <= 1'b0;
        end else if (data_in_vld) begin
            if (skp_delete) begin
                // Skip this SKP symbol to delete it
                write_pause <= 1'b1;
            end else begin
                // Normal write operation
                write_pause <= 1'b0;
                wr_ptr_bin <= wr_ptr_bin_next;
                wr_ptr_gray <= wr_ptr_gray_next;
            end
        end else begin
            write_pause <= 1'b0;
        end
    end
    
    // Calculate next write pointer values
    assign wr_ptr_bin_next = (write_pause) ? wr_ptr_bin : ((wr_ptr_bin == FIFO_DEPTH-1) ? {ADDR_WIDTH{1'b0}} : wr_ptr_bin + 1'b1);
    assign wr_ptr_gray_next = bin2gray(wr_ptr_bin_next);
    
    // Write data to memory (Recovered Clock Domain)
    always @(posedge rclk) begin
        if (data_in_vld && !full && !write_pause) begin
            mem[wr_ptr_bin] <= data_in;
        end
    end
    
    // Synchronize write pointer to local clock domain
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            wr_ptr_gray_sync1 <= {ADDR_WIDTH{1'b0}};
            wr_ptr_gray_sync2 <= {ADDR_WIDTH{1'b0}};
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end
    
    // Convert synchronized Gray code write pointer to binary
    assign wr_ptr_sync_bin = gray2bin(wr_ptr_gray_sync2);
    
    // SKP addition control (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            skp_add <= 1'b0;
            skp_add_count <= 2'd0;
        end else begin
            if (fill_level < ADD_THRESHOLD && (skp_add_count == 2'd0)) begin
                // Buffer getting too empty, need to add SKP symbols
                if (fill_level < ADD_THRESHOLD - 2) begin
                    // Buffer very low, add 2 SKP symbols
                    skp_add <= 1'b1;
                    skp_add_count <= 2'd2;
                end else begin
                    // Buffer moderately low, add 1 SKP symbol
                    skp_add <= 1'b1;
                    skp_add_count <= 2'd1;
                end
            end else if (skp_add_count > 0) begin
                // Continue adding SKP symbols until count reaches zero
                skp_add <= 1'b1;
                skp_add_count <= skp_add_count - 1'b1;
            end else begin
                skp_add <= 1'b0;
            end
        end
    end
    
    // Read pointer logic (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            rd_ptr_bin <= {ADDR_WIDTH{1'b0}};
            rd_ptr_gray <= {ADDR_WIDTH{1'b0}};
            read_pause <= 1'b0;
        end else begin
            if (skp_add) begin
                // Don't increment read pointer when inserting SKP symbols
                read_pause <= 1'b1;
            end else if (!empty) begin
                // Normal read operation
                read_pause <= 1'b0;
                rd_ptr_bin <= rd_ptr_bin_next;
                rd_ptr_gray <= rd_ptr_gray_next;
            end else begin
                read_pause <= 1'b0;
            end
        end
    end
    
    // Calculate next read pointer values
    assign rd_ptr_bin_next = (read_pause) ? rd_ptr_bin : ((rd_ptr_bin == FIFO_DEPTH-1) ? {ADDR_WIDTH{1'b0}} : rd_ptr_bin + 1'b1);
    assign rd_ptr_gray_next = bin2gray(rd_ptr_bin_next);
    
    // Read data and control output (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            data_out <= 10'd0;
            data_out_vld <= 1'b0;
        end else begin
            if (skp_add) begin
                // Insert SKP symbols
                data_out_vld <= 1'b1;
                if (skp_add_count == 2'd2) begin
                    // First inserted SKP should be COM
                    data_out <= COM_SYM;
                end else begin
                    // Additional inserted symbols are SKP
                    data_out <= SKP_SYM;
                end
            end else if (!empty) begin
                // Normal read operation
                data_out <= mem[rd_ptr_bin];
                data_out_vld <= 1'b1;
            end else begin
                data_out_vld <= 1'b0;
            end
        end
    end
    
    // Synchronize read pointer to recovered clock domain
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rd_ptr_gray_sync1 <= {ADDR_WIDTH{1'b0}};
            rd_ptr_gray_sync2 <= {ADDR_WIDTH{1'b0}};
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end
    
    // Convert synchronized Gray code read pointer to binary
    assign rd_ptr_sync_bin = gray2bin(rd_ptr_gray_sync2);
    
    // Generate empty and full flags
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH-1:ADDR_WIDTH-2], rd_ptr_gray_sync2[ADDR_WIDTH-3:0]});


property write_ptr_increments;
  @(posedge rclk)
  disable iff (!rrst_n)
  data_in_vld |=> ((wr_ptr_bin == $past(wr_ptr_bin) + 1) || (wr_ptr_bin == 0 && $past(wr_ptr_bin) == FIFO_DEPTH-1));
endproperty

assert property (write_ptr_increments);
cover property (write_ptr_increments);

property read_ptr_increments;
  @(posedge lclk)
  disable iff (!lrst_n)
  data_out_vld |-> ((rd_ptr_bin == $past(rd_ptr_bin) + 1) || (rd_ptr_bin == 0 && $past(rd_ptr_bin) == FIFO_DEPTH-1));
endproperty

assert property (read_ptr_increments);
cover property (read_ptr_increments);

property fifo_empty_flag_check;
  @(posedge rclk)
  disable iff (rrst_n)
  (rd_ptr_sync_bin == wr_ptr_sync_bin) |-> empty;
endproperty

assert property (fifo_empty_flag_check);
cover property (fifo_empty_flag_check);

property fifo_full_flag_check;
  @(posedge lclk)
  disable iff (lrst_n)
  ((wr_ptr_sync_bin + 1) % FIFO_DEPTH == rd_ptr_sync_bin) |-> empty;
endproperty

assert property (fifo_full_flag_check);
cover property (fifo_full_flag_check);

endmodule