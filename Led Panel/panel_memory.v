module panel_memory(
    input  wire        clk,
    input  wire [11:0] addr_top,
    input  wire [11:0] addr_bottom,
    output reg  [23:0] pix_top,
    output reg  [23:0] pix_bottom
);

    reg [23:0] MEM [0:4095];

    initial begin
        $readmemh("image(1).hex", MEM);
    end

    always @(posedge clk) begin
        pix_top    <= MEM[addr_top];
        pix_bottom <= MEM[addr_bottom];
    end

endmodule
