`timescale 1ns/1ps

module dmem_tb;

    logic clk;
    logic rst;
    logic WE;
    logic [31:0] A;
    logic [31:0] WD;
    logic [31:0] RD;

    dmem dut (
        .clk(clk),
        .rst(rst),
        .WE(WE),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        rst = 1;
        WE = 0;
        A = 0;
        WD = 0;

        #10 rst = 0;

        // Lectura de las posiciones precargadas
        A = 1000; #10;
        $display("Lectura @1000: Esperado=0x21212121, Leido=%h", RD);

        A = 1004; #10;
        $display("Lectura @1004: Esperado=0x23232323, Leido=%h", RD);

        // Escritura en una nueva dirección
        WE = 1;
        A = 1010;
        WD = 32'hA5A5A5A5; #10;
        WE = 0;

        // Lectura de la dirección escrita
        A = 1010; #10;
        $display("Lectura @1010: Esperado=0xA5A5A5A5, Leido=%h", RD);

        // Lectura de una dirección no inicializada
        A = 1020; #10;
        $display("Lectura @1020: Esperado=0x00000000, Leido=%h", RD);

        // Escritura en una dirección existente
        WE = 1;
        A = 1000;
        WD = 32'hDEADBEEF; #10;
        WE = 0;

        // Verificar la sobrescritura
        A = 1000; #10;
        $display("Lectura sobrescrita @1000: Esperado=0xDEADBEEF, Leido=%h", RD);

        // Fin de la simulación
        #20;
        $stop;
    end

endmodule
