//TestBench 
// Instituto Tecnológico de Costa Rica
// EL-3310 Diseño de sistemas digitales
// Autores:       David Leitón Flores
//                Ana Cristina Fallas Quiros
//                Tomas Campos Uribe
//                Jesús David Vargas Arias
// Fecha:       5.11.2024
// Descripción: CPU procesador Uniciclo

`timescale 1ns/1ps // Escala de tiempo

module cpu_tb();

    logic clk;
    logic rst;
    
    wire [31:0] ReadData;
    
    
    
    
    
    

    // Instancia del m�dulo CPU
    cpu cpu1(
        .clk(clk),
        .rst(rst),
        .result(ReadData)
        
    );

    initial begin
        rst = 1;
        #40;
        rst = 0;
        #400;
        $finish();
    end

    // Generaci�n del reloj
    initial begin
        clk = 0;
        forever #5 clk = !clk;
        
    end
    
    

    // Impresi�n del valor de ReadData en cada ciclo de reloj
    always @(posedge clk) begin
        $display("Tiempo: %0t ns, Resultado (Result): %h", $time, ReadData);
    end

endmodule