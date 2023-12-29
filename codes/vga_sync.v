module vga_sync(
    input vga_clk,
    input clrn,
    output reg hsync,
    output reg vsync,
    output reg [9:0] col,
    output reg [9:0] row,
    output in_screen
    );

    // 800x600 @ 72Hz
    parameter H_SYNC = 120;
    parameter H_BACK = 64;
    parameter H_DISPLAY = 800;
    parameter H_FRONT = 56;

    parameter V_SYNC = 6;
    parameter V_BACK = 23;
    parameter V_DISPLAY = 600;
    parameter V_FRONT = 37;

    reg [10:0] hcount = 0;
    reg [10:0] vcount = 0;

    wire h_sync = (hcount >= H_SYNC);
    wire v_sync = (vcount >= V_SYNC);
    wire [9:0] pixel_x = hcount - H_SYNC - H_BACK + 1;
    wire [9:0] pixel_y = vcount - V_SYNC - V_BACK;
    
    assign in_screen = (hcount > H_SYNC + H_BACK) && (hcount < H_SYNC + H_BACK + H_DISPLAY) &&
                       (vcount > V_SYNC + V_BACK - 1) && (vcount < V_SYNC + V_BACK + V_DISPLAY);

    always @(posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
            hcount <= 0;
        end else if (hcount == H_SYNC + H_BACK + H_DISPLAY + H_FRONT - 1) begin
            hcount <= 0;
        end else begin
            hcount <= hcount + 1'b1;
        end
    end

    always @(posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
            vcount <= 0;
        end else if (hcount == H_SYNC + H_BACK + H_DISPLAY + H_FRONT - 1) begin
            if (vcount == V_SYNC + V_BACK + V_DISPLAY + V_FRONT - 1) begin
                vcount <= 0;
            end else begin
                vcount <= vcount + 1'b1;
            end
        end
    end

    always @(posedge vga_clk) begin
        col <= pixel_x;
        row <= pixel_y;
        hsync <= h_sync;
        vsync <= v_sync;
    end

endmodule
