module ps2_drv (
    input clk,
    input ps2_clk,
    input ps2_data,
    output reg [5:0] keys
);
    reg ps2c;
    reg ps2d;
    reg [3:0] cnt = 0;
    reg [7:0] ps2c_fliter, ps2d_fliter;
    reg [10:0] shift1, shift2;

    wire [7:0] scan1 = shift1[8:1];
    wire [7:0] scan2 = shift2[8:1];

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
        shift1 <= {ps2d, shift1[10:1]};
        shift2 <= {shift1[0], shift2[10:1]};
        cnt <= (cnt == 10) ? 0 : cnt + 1'b1;
    end

    always @(posedge clk) begin
        if (cnt == 0 && shift1[0] == 0 && shift1[10] == 1 && ^shift1[9:1]) begin
            if (scan1 == 8'h2D) begin   // R
                keys[5] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
            end
            if (scan1 == 8'h29) begin   // SPACE
                keys[4] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
            end
            if (scan1 == 8'h1D) begin   // W
                keys[3] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
            end
            if (scan1 == 8'h1B) begin   // S
                keys[2] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
            end
            if (scan1 == 8'h1C) begin   // A
                keys[1] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
            end
            if (scan1 == 8'h23) begin   // D
                keys[0] <= (scan2 == 8'hF0) ? 1'b0: 1'b1;
            end
        end
    end
endmodule
