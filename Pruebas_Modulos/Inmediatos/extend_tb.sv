module extend_tb;
    logic [1:0] sel;
    logic [31:0] A;

    logic [31:0] Q;

    extend dut (
        .sel(sel),
        .A(A),
        .Q(Q)
    );

    initial begin
        $display("Iniciando pruebas");

        //  Tipo I
        A = 32'hF1234567; // A con valor random
        sel = 2'b00;
        #10;
        $display("Tipo I: A=0x%h, sel=%b, Q=0x%h", A, sel, Q);

        //  Tipo S
        A = 32'hF1234567; // A con valor random
        sel = 2'b01;
        #10;
        $display("Tipo S: A=0x%h, sel=%b, Q=0x%h", A, sel, Q);

        // Tipo B
        A = 32'hF1234567; // A con valor random
        sel = 2'b10;
        #10;
        $display("Tipo B: A=0x%h, sel=%b, Q=0x%h", A, sel, Q);

        // Valor por defecto (sel = 2'b11)
        sel = 2'b11;
        #10;
        $display("Por defecto: A=0x%h, sel=%b, Q=0x%h", A, sel, Q);

        $display("Pruebas completadas.");
        $stop;
    end

endmodule
