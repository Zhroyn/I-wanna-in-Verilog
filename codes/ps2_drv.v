module ps2_drv (
    input clk,
    input ps2_clk,
    input ps2_data,
    output reg [3:0] keys
);
    reg ps2c;
    reg ps2d;
    reg [7:0] ps2c_fliter;
    reg [7:0] ps2d_fliter;
    reg [21:0] shift;

    wire [7:0] scan1 = shift[8:1];
    wire [7:0] scan2 = shift[19:12];

    always @(posedge clk) begin
        ps2c_fliter <= {ps2_clk, ps2c_fliter[7:1]};
        ps2d_fliter <= {ps2_data, ps2d_fliter[7:1]};
        if(ps2c_fliter == 8'hFF)
            ps2c <= 1;
        else if(ps2c_fliter == 8'h00)
            ps2c <= 0;
        if(ps2d_fliter == 8'hFF)
            ps2d <= 1;
        else if(ps2d_fliter == 8'h00)
            ps2d <= 0; 
    end

    always @(negedge ps2c) begin
        shift <= {ps2d, shift[21:1]};
    end

    always @(posedge clk) begin
        if (scan1 == 8'h1C) begin
            keys[3] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
        end
        if (scan1 == 8'h23) begin
            keys[2] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
        end
        if (scan1 == 8'h1D) begin
            keys[1] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
        end
        if (scan1 == 8'h2D) begin
            keys[0] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
        end
    end
endmodule
