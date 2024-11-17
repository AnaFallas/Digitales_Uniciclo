module add32_tb;

    // Entradas y salida
    logic [31:0] A, B;
    logic [31:0] Q;

    
    add32 dut (
        .A(A),
        .B(B),
        .Q(Q)
    );

    initial begin
        $display("Iniciando pruebas para add32...");

        // Prueba 1: 0 + 0 = 0
        A = 32'h00000000; B = 32'h00000000;
        #10 $display("A=%h, B=%h, Q=%h", A, B, Q);

        // Prueba 2: 1 + 1 = 2
        A = 32'h00000001; B = 32'h00000001;
        #10 $display("A=%h, B=%h, Q=%h", A, B, Q);

        // Prueba 3: Máximos valores
        A = 32'hFFFFFFFF; B = 32'h00000001;
        #10 $display("A=%h, B=%h, Q=%h", A, B, Q);

        // Prueba 4: Valores aleatorios
        A = 32'h12345678; B = 32'h87654321;
        #10 $display("A=%h, B=%h, Q=%h", A, B, Q);

        $display("Pruebas completadas.");
        $stop;
    end

endmodule
