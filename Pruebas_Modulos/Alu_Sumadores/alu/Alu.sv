module Alu(
    input        [2:0]  ALUControl,
    input        [31:0] A,
    input        [31:0] B,
    output logic [31:0] Result,
    output logic        oVerflow,
    output logic        Carry,
    output logic        Negative,
    output logic        zero

);

    logic [31:0] Sum;           // Resultado del sumador/restador
    logic        C_out;         // Acarreo de salida del sumador
    logic [31:0] B_complement;  // Complemento a 2 de B para la resta 
    logic [31:0] B_selected;    // Valor seleccionado de B o su complemento a 2
    logic [31:0] AndResult;     // Resultado de la operación AND
    logic [31:0] OrResult;      // Resultado de la operación OR
    logic [31:0] SltResult;     // Resultado de la operación SLT
    logic        cin1;          // Acarreo de entrada

    // Complemento a 2 de B para la resta
    assign B_complement = ~B ;


    assign cin1 = ALUControl[0]; //Para resta, Cin debe ser 1

    adder_ripple_carry carryadd(
        .A(A),
        .B(B_selected),
        .Cin(cin1),
        .Cout(C_out),
        .S(Sum)
    );

// Operaciones lógicas
    assign AndResult = A & B;
    assign OrResult = A | B;
    assign SltResult = (A < B) ? 32'b1 : 32'b0;


    mux_a2 muxA2 (
        .sel(ALUControl[0]),           // Señal de selección
        .in0(B),          // Entrada 0
        .in1(B_complement),         // Entrada 1
        .out(B_selected)    // Salida
);

    mux_out mout(
        .in0(Sum),      
        .in1(Sum),      
        .in2(AndResult),     
        .in3(OrResult),     
        .in4(SltResult),      
        .sel(ALUControl),      
        .out(Result)       
);

    


    // Flags
    always_comb begin
        oVerflow = (~(A[31] ^ B[31] ^ ALUControl[0])) & (A[31] ^ Sum[31])  & ~ALUControl[1];
        Carry =   ~ALUControl[1] & C_out ;
        Negative = Result[31];
        assign zero = (Result == 32'b0) ? 1'b1 : 1'b0;
    end

endmodule


module full_adder(
    input         A,
    input         B,
    input         Cin,
    output logic  S,
    output logic  Cout
);

    assign S = (A ^ B) ^ Cin;

    assign Cout = ((A ^ B) & Cin) + (A & B) ;


endmodule


module adder_ripple_carry(
    input        [31:0] A,
    input        [31:0] B,
    input               Cin,
    output logic        Cout,
    output logic [31:0] S

);
    wire [31:0] cin_n;

        genvar i;

        generate
            for (i=0 ; i < 32 ; i++) begin
                if (i==0) begin
                    full_adder f_add_n (
                    .A(A[i]),
                    .B(B[i]), 
                    .Cin(Cin),
                    .Cout(cin_n[i]),
                    .S(S[i])  );
                end else begin
                    full_adder f_add_n (
                    .A(A[i]),
                    .B(B[i]), 
                    .Cin(cin_n[i-1]),
                    .Cout(cin_n[i]),
                    .S(S[i])                  
                    
                );
                end
            end
                
        endgenerate

    // Asignaciones del acarreo final
    assign Cout = cin_n;
    

endmodule

module mux_a2(
    input               sel,           // Señal de selección
    input        [31:0] in0,          // Entrada 0
    input        [31:0] in1,         // Entrada 1
    output logic [31:0] out    // Salida
);
    assign out = (sel) ? in1 : in0;
endmodule



module mux_out(
    input        [31:0] in0,      // Entrada 0 (sumador)
    input        [31:0] in1,      // Entrada 1 (restador)
    input        [31:0] in2,      // Entrada 2 (AND)
    input        [31:0] in3,      // Entrada 3 (OR)
    input        [31:0] in4,      // Entrada 4 (SLT)
    input        [2:0]  sel,      // Señal de selección
    output logic [31:0] out       // Salida
);

    always_comb begin
        case (sel)
            3'b000: out = in0;  // ADD
            3'b001: out = in1;  // SUB
            3'b010: out = in2;  // AND
            3'b011: out = in3;  // OR
            3'b101: out = in4;  // SLT
            default: out = 32'b0;
        endcase
    end

endmodule

