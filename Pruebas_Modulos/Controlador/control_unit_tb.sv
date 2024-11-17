module control_unit_tb;

    // Entradas
    logic [6:0] op;
    logic [2:0] funct3;
    logic       funct7_bit5;
    logic       Zero;

    // Salidas
    logic PCSrc;
    logic ResultSrc;
    logic MemWrite;
    logic [2:0] ALUControl;
    logic ALUSrc;
    logic [1:0] ImmSrc;
    logic RegWrite;

    // Instancia del módulo `control_unit`
    control_unit dut (
        .op(op),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),
        .Zero(Zero),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );

    // Procedimiento inicial
    initial begin
        $display("Iniciando pruebas de la unidad de control...");

        // Intruccion lw x8, 1000(x0)
        op = 7'b0000011; // opcode de lw
        funct3 = 3'b010; // funct3 para lw
        funct7_bit5 = 1'b0;
        Zero = 1'b0; // irrelevant para lw
        #10;
        $display("LW: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion sw x9, 1004(x0)
        op = 7'b0100011; // opcode de sw
        funct3 = 3'b010; // funct3 para sw
        funct7_bit5 = 1'b0;
        Zero = 1'b0; // irrelevant para sw
        #10;
        $display("SW: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion add x10, x8, x9
        op = 7'b0110011; // opcode de R-Type
        funct3 = 3'b000; // funct3 para add
        funct7_bit5 = 1'b0; // funct7 para add
        Zero = 1'b0; // irrelevant para add
        #10;
        $display("ADD: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion sub x10, x8, x9
        funct3 = 3'b000; // funct3 para sub
        funct7_bit5 = 1'b1; // funct7 para sub
        #10;
        $display("SUB: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion and x10, x8, x9
        funct3 = 3'b111; // funct3 para and
        funct7_bit5 = 1'b0;
        #10;
        $display("AND: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion or x10, x8, x9
        funct3 = 3'b110; // funct3 para or
        funct7_bit5 = 1'b0;
        #10;
        $display("OR: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion slt x10, x8, x9
        funct3 = 3'b010; // funct3 para slt
        funct7_bit5 = 1'b0;
        #10;
        $display("SLT: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        // Intruccion beq x0, x0, L1
        op = 7'b1100011; // opcode de beq
        funct3 = 3'b000; // funct3 para beq
        Zero = 1'b1; // Zero activo para el salto
        #10;
        $display("BEQ: PCSrc=%b, ResultSrc=%b, MemWrite=%b, ALUControl=%b, ALUSrc=%b, ImmSrc=%b, RegWrite=%b",
                 PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite);

        $display("Pruebas completadas.");
        $stop;
    end

endmodule
