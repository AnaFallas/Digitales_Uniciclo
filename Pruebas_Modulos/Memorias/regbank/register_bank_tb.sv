`timescale 1ns/1ps

module register_bank_tb;

    // Señales para el DUT
    logic clk;
    logic rst;
    logic [4:0] A1, A2, A3;
    logic WE3;
    logic [31:0] WD3;
    logic [31:0] RD1, RD2;

    // Instancia del módulo register_bank
    register_bank dut (
        .clk(clk),
        .rst(rst),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WE3(WE3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de 10 ns
    end

    // Proceso de prueba
    initial begin
        // Inicialización
        rst = 1;
        WE3 = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        // Ciclo de reinicio
        #10 rst = 0;

        // Escritura en registro 5
        WE3 = 1;
        A3 = 5;
        WD3 = 32'hA5A5A5A5; #10;
        WE3 = 0;

        // Escritura en registro 10
        WE3 = 1;
        A3 = 10;
        WD3 = 32'h5A5A5A5A; #10;
        WE3 = 0;

        // Lectura desde registro 5 y 10
        A1 = 5;
        A2 = 10; #10;
        $display("Lectura RD1 (reg 5): Esperado=0xA5A5A5A5, Leido=%h", RD1);
        $display("Lectura RD2 (reg 10): Esperado=0x5A5A5A5A, Leido=%h", RD2);

        // Lectura desde un registro no inicializado (debe ser 0)
        A1 = 15;
        A2 = 20; #10;
        $display("Lectura RD1 (reg 15): Esperado=0x00000000, Leido=%h", RD1);
        $display("Lectura RD2 (reg 20): Esperado=0x00000000, Leido=%h", RD2);

        // Sobrescritura en registro 5
        WE3 = 1;
        A3 = 5;
        WD3 = 32'h12345678; #10;
        WE3 = 0;

        // Lectura después de sobrescribir
        A1 = 5; #10;
        $display("Lectura sobrescrita RD1 (reg 5): Esperado=0x12345678, Leido=%h", RD1);

        // Fin de la simulación
        #20;
        $stop;
    end

endmodule
