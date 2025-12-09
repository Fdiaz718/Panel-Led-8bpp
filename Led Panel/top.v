module top(
    input  wire clk,
    input  wire rst,

    output wire r0, g0, b0,
    output wire r1, g1, b1,
    output wire [4:0] addr,
    output wire clk_out,
    output wire latch,
    output wire oe
);

    wire [5:0] col;
    wire [4:0] scan_row;
    wire [4:0] display_row;
    wire [5:0] row_top;
    wire [5:0] row_bottom;
    
    // 8bpp [7:0], 5bpp [4:0]
    wire [4:0] pwm_level; 

    scan_counters SC(
        .clk(clk),
        .rst(rst),
        .col(col),
        .scan_row(scan_row),
        .addr_out(display_row),
        .pwm_level(pwm_level),
        .row_top(row_top),
        .row_bottom(row_bottom)
    );

    assign addr = display_row;

    wire [11:0] addr_top    = {row_top,    col};
    wire [11:0] addr_bottom = {row_bottom, col};
    wire [23:0] pix_top;
    wire [23:0] pix_bottom;

    panel_memory MEM(
        .clk(clk),
        .addr_top(addr_top),
        .addr_bottom(addr_bottom),
        .pix_top(pix_top),
        .pix_bottom(pix_bottom)
    );

    panel_pwm PWM(
        .pix_top(pix_top),
        .pix_bottom(pix_bottom),
        .pwm_level(pwm_level),
        .r0(r0), .g0(g0), .b0(b0),
        .r1(r1), .g1(g1), .b1(b1)
    );

    delay_unit DU(
        .clk(clk),
        .rst(rst),
        .col(col),
        .clk_out(clk_out),
        .latch(latch),
        .oe(oe)
    );

endmodule
