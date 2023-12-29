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
    reg [10:0] shift1;
    reg [10:0] shift2;

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
    end

    always @(negedge clk) begin
        if (scan1 == 8'h1C) begin
            if (scan2 == 8'hF0)
                keys[0] <= 0;
            else
                keys[0] <= 1;
        end
        if (scan1 == 8'h23) begin
            if (scan2 == 8'hF0)
                keys[1] <= 0;
            else
                keys[1] <= 1;
        end
        if (scan1 == 8'h1D) begin
            if (scan2 == 8'hF0)
                keys[2] <= 0;
            else
                keys[2] <= 1;
        end
        if (scan1 == 8'h29) begin
            if (scan2 == 8'hF0)
                keys[3] <= 0;
            else
                keys[3] <= 1;
        end
    end
endmodule
