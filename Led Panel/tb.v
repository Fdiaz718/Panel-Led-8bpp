`timescale 1ns / 1ps

module tb;

    reg clk;
    reg rst;

    wire r0, g0, b0;
    wire r1, g1, b1;
    wire [4:0] addr;
    wire clk_out;
    wire latch;
    wire oe;

    // 2. Instanciar el Módulo TOP
    top UUT (
        .clk(clk),
        .rst(rst),
        .r0(r0), .g0(g0), .b0(b0),
        .r1(r1), .g1(g1), .b1(b1),
        .addr(addr),
        .clk_out(clk_out),
        .latch(latch),
        .oe(oe)
    );

    // 3. Generador de Reloj (25 MHz)
    // Periodo = 40ns (20ns alto, 20ns bajo)
    initial begin
        clk = 0;
        forever #20 clk = ~clk; 
    end

    // 4. Secuencia de Prueba
    initial begin
        // Configurar archivo de salida para GTKWave
        $dumpfile("build/hub75_simulation.vcd");
        $dumpvars(0, tb);

        // Inicio: Reset activo
        rst = 1;
        #100; // Esperar 100ns
        
        // Soltar Reset
        rst = 0;
        
        #50000; 

        $display("Simulación terminada.");
        $finish;
    end

endmodule
