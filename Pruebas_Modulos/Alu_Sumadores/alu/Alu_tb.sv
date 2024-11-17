`timescale 1ns/1ps

module Alu_tb;

    // Entradas del DUT (Device Under Test)
    logic [2:0]  ALUControl;
    logic [31:0] A, B;

    // Salidas del DUT
    logic [31:0] Result;
    logic        oVerflow, Carry, Negative, zero;

    // Instancia de la ALU
    Alu dut (
        .ALUControl(ALUControl),
        .A(A),
        .B(B),
        .Result(Result),
        .oVerflow(oVerflow),
        .Carry(Carry),
        .Negative(Negative),
        .zero(zero)
    );

    // Tarea para mostrar los resultados de las pruebas
    task display_results();
        $display("Time: %0t | ALUControl: %0b | A: %0h | B: %0h | Result: %0h | Overflow: %0b | Carry: %0b | Negative: %0b | Zero: %0b",
                 $time, ALUControl, A, B, Result, oVerflow, Carry, Negative, zero);
    endtask

    initial begin
        $display("Iniciando pruebas de la ALU...");
        
        // Prueba de suma
        A = 32'h00000005; B = 32'h00000003; ALUControl = 3'b000; // Suma
        #10 display_results();
        
        // Prueba de resta
        A = 32'h00000005; B = 32'h00000003; ALUControl = 3'b001; // Resta
        #10 display_results();

        // Prueba de operación AND
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 3'b010; // AND
        #10 display_results();

        // Prueba de operación OR
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 3'b011; // OR
        #10 display_results();

        // Prueba de operación SLT
        A = 32'h00000002; B = 32'h00000003; ALUControl = 3'b100; // SLT
        #10 display_results();

        // Prueba de overflow en suma
        A = 32'h7FFFFFFF; B = 32'h00000001; ALUControl = 3'b000; // Suma con overflow
        #10 display_results();

        // Prueba de acarreo
        A = 32'hFFFFFFFF; B = 32'h00000001; ALUControl = 3'b000; // Suma con acarreo
        #10 display_results();

        // Prueba de resultado en cero
        A = 32'h00000005; B = 32'h00000005; ALUControl = 3'b001; // Resta que da 0
        #10 display_results();

        $display("Pruebas completadas.");
        $stop;
    end

endmodule
