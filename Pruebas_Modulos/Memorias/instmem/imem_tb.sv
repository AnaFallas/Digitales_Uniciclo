module imem_tb;

    // Declaración de señales
    reg               rst;
    reg  [31:0]       A;  // Dirección de entrada
    wire [31:0]       RD; // Dato de salida

    // Instanciar el módulo imem
    imem uut (
        .rst(rst),
        .A(A),
        .RD(RD)
    );

    // Proceso de prueba
    initial begin
        // Inicialización
        rst = 1'b1;    // Reset activado
        A = 32'b0;     // Dirección inicial
        #5 rst = 1'b0; // Desactivar reset

        // Probar cada instrucción
        #10 A = 32'h00400000; // lw x8, 1000(x0)
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h00400004; // lw x9, 1004(x0)
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h00400008; // add x10, x8, x9
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h0040000C; // sub x10, x8, x9
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h00400010; // and x10, x8, x9
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h00400014; // or x10, x8, x9
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h00400018; // slt x10, x8, x9
        #10 $display("A = %h, RD = %h", A, RD);

        #10 A = 32'h0040001C; // beq x0, x0, -28
        #10 $display("A = %h, RD = %h", A, RD);

        // Probar dirección no válida
        #10 A = 32'hFFFFFFFF; // Dirección inválida
        #10 $display("A = %h, RD = %h", A, RD);

        // Terminar la simulación
        #10 $finish;
    end

endmodule
