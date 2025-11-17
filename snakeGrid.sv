`default_nettype none
/////////////////////////////////////////////////////////////////
// HEADER 
//
// Module : snakeGrid
// Description : 20x20 Grid display with white lines and black background
// 
//
/////////////////////////////////////////////////////////////////
module snakeGrid(
    input logic [9:0] x, y,
    input logic [19:0][19:0] display_array,  // 20x20 game state (1 bit per cell)
    input logic gameover,
    output logic [2:0] shape_color
);

// Grid parameters
localparam BLOCK_SIZE = 15;

// Colors
localparam BLACK = 3'b000;
localparam WHITE = 3'b111;
localparam RED   = 3'b100;

logic in_grid;
logic [9:0] temp_x, temp_y;
logic [4:0] grid_x;  // Changed from 4 bits to 5 bits for 20 columns (0-19)
logic [4:0] grid_y;  // Already 5 bits for 20 rows
logic on_grid_line;

always_comb begin
    // Check if current pixel is within the grid area (245,90) to (545,390)
    // Width: 20 blocks * 15 pixels = 300 pixels (245 to 545)
    // Height: 20 blocks * 15 pixels = 300 pixels (90 to 390)
    in_grid = (x >= 10'd245) && (x < 10'd545) &&
              (y >= 10'd90) && (y < 10'd390);
    
    // Calculate grid position with proper bit handling
    temp_x = (x - 10'd245) / BLOCK_SIZE;
    temp_y = (y - 10'd90) / BLOCK_SIZE;
    grid_x = temp_x[4:0];  // Changed to 5 bits
    grid_y = temp_y[4:0];
    
    // Check if we're on a grid line (border of blocks)
    on_grid_line = ((x - 10'd245) % BLOCK_SIZE == 0) || 
                   ((y - 10'd90) % BLOCK_SIZE == 0) ||
                   (x == 10'd544) || (y == 10'd389);  // Right and bottom borders
    
    // Assign colors
    if (in_grid) begin
        if (on_grid_line && !gameover) begin
            shape_color = WHITE;  // White grid lines
        end else if (on_grid_line && gameover) begin
            shape_color = RED;    // Red grid lines on game over
        end else begin
            // Map array contents to grid
            if (grid_y < 5'd20 && grid_x < 5'd20) begin
                shape_color = display_array[grid_y][grid_x] ? WHITE : BLACK;
            end else begin
                shape_color = BLACK;  // Fallback color
            end
        end
    end else begin
        shape_color = BLACK;  // Black background outside grid
    end
end

endmodule