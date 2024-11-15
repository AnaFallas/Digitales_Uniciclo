// Instituto Tecnológico de Costa Rica
// EL-3310 Diseño de sistemas digitales
// Autores:       David Leitón Flores
//                Ana Cristina Fallas Quiros
//                Tomas Campos Uribe
//                Jesús David Vargas Arias
// Fecha:       5.11.2024
// Descripción: CPU procesador Uniciclo

`timescale 1ns/1ps //escala de tiempo

module cpu (
    input               clk   ,
    input               rst   ,
    output logic [31:0] result
    
    
);
//Instanciar modulos(Conexiones)
//Arquitectura
//Cables de PC
    wire [31:0] PCNext   ;
    wire [31:0] PC       ;
    wire [31:0] PCPlus4  ;
    wire [31:0] PCTarget ;
//Cable Instrucciones 
    wire [31:0] Instr    ;
//Cables salidas banco registros y Immediato
    wire [31:0] ImmExt   ;
    wire [31:0] SrcA     ;
    wire [31:0] SrcB     ;
    wire [31:0] WriteData;
// Salidas de ALU y  banderas
    wire [31:0] ALUResult;
    wire        zero     ;
    wire        overflow ;
    wire        negative ;
    wire        carry    ;

//Salida Memoria de datos
    wire [31:0] ReadData ;

//--------------------------------------------------------------//
// Señales de Control parte Proyecto Corto 5


    wire        Zero      ;
    wire        PCSrc     ;
    wire        ResultSrc ;
    wire        MemWrite  ;//agregue tamaño
    wire [2:0]  ALUControl;
    wire        ALUSrc    ;
    wire [1:0]  ImmSrc    ;
    wire        RegWrite  ;

    
    
    
//----------------Modúlos instanciados------------//
    //---Sumadores---//
    add32 add_pc(
        .A  (PC)     ,
        .B  (4)      ,
        .Q  (PCPlus4)
    );

    add32 add_pc_target(
        .A  (PC)     ,
        .B  (ImmExt) ,
        .Q  (PCTarget)
    );

    //---Muxes---//
    mux32 mux_pc(
        .sel(PCSrc)   , 
        .A  (PCPlus4) ,
        .B  (PCTarget),
        .Q  (PCNext)
    );

    mux32 mux_rd2(
        .sel(ALUSrc)   , 
        .A  (WriteData),
        .B  (ImmExt)   ,
        .Q  (SrcB)
    );

    mux32 mux_result(
        .sel(ResultSrc)  ,
        .A  (ALUResult)  ,
        .B  (ReadData)   ,
        .Q  (result)
    );


    program_counter pc1 (
        .clk    (clk)   ,
        .rst    (rst)   ,
        .PCNext (PCNext),
        .PC     (PC)

    );
    //Memoria de instrucciones
    imem imem1(
        .A       (PC)   ,
        .rst     (rst)  ,
        .RD      (Instr)
    );
    
    register_bank  rb1(
        .clk   (clk)         ,
        .rst   (rst)         ,
        .A1    (Instr[19:15]),
        .A2    (Instr[24:20]),
        .A3    (Instr[11:7]) ,
        .RD1   (SrcA)        ,
        .RD2   (WriteData)   ,
        .WE3   (RegWrite)    ,//Instancia de control
        .WD3   (result)


    );

    
    dmem dmem1 (
        .clk    (clk)      ,
        .rst    (rst)      ,
        .WE     (MemWrite) ,//control
        .A      (ALUResult),
        .WD     (WriteData),
        .RD     (ReadData)
        
    );

    Extend ext1 (
        .sel (ImmSrc)     ,// control
        .A   (Instr[31:0]),//Toda instruccion por que inmediato puede estar en cualquier posicion
        .Q   (ImmExt)
    );

    alu alu1(
        .ALUControl (ALUControl), //señal de control wire(alucontrol)
        .A          (SrcA)      ,
        .B          (SrcB)      ,
        .Result     (ALUResult) ,
        .zero       (Zero)      ,
        .oVerflow   (overflow)  ,
        .Carry      (carry)     ,
        .Negative   (negative)
    );

    //---------------Instanciar modulo de control------------------------

    control_unit ctr1 (
        .op          (Instr[6:0])  ,
        .funct3      (Instr[14:12]),
        .funct7_bit5 (Instr[30])   ,//funct[5]
        .Zero        (Zero)        ,
        .PCSrc       (PCSrc)       ,
        .ResultSrc   (ResultSrc)   ,
        .MemWrite    (MemWrite)    ,
        .ALUControl  (ALUControl)  ,
        .ALUSrc      (ALUSrc)      ,
        .ImmSrc      (ImmSrc)      ,
        .RegWrite    (RegWrite)

    );


endmodule


//-----------------------------Bloques DATAPATH--------------------//

module program_counter(
    input               clk   ,
    input               rst   ,
    input        [31:0] PCNext,
    output logic [31:0] PC
);

    always_ff @( posedge clk ) begin 
        if (rst) PC <= 32'h00400000;//inicio segmento texto
        else PC <= PCNext;
 
    end


endmodule

//Memoria de instrucciones (rom)
//alineada cada 4 direcciones

module imem(
    input               rst,
    input        [31:0] A  ,
    output logic [31:0] RD
);

    always_comb begin

        case (A)                   
            32'h00400000: RD = 32'h3e802403; // lw x8, 1000(x0)
            32'h00400004: RD = 32'h3ec02483; // lw x9, 1004(x0)
            32'h00400008: RD = 32'h00940533; // add x10, x8, x9
            32'h0040000C: RD = 32'h40940533; // sub x10, x8, x9
            32'h00400010: RD = 32'h00947533; // and x10, x8, x9
            32'h00400014: RD = 32'h00946533; // or x10, x8, x9
            32'h00400018: RD = 32'h00942533; // slt x10, x8, x9
            32'h0040001C: RD = 32'hfe0002e3; // beq x0, x0, -28 (branch to L1)
            default:      RD = 32'hDEADBEEF; // error
        endcase


    end

endmodule

//-----------------------------------------------------------//
module register_bank(
    input               clk,
    input               rst,
    input        [4:0]  A1,
    input        [4:0]  A2,
    input        [4:0]  A3,
    input               WE3,
    input        [31:0] WD3,
    output logic [31:0] RD1,
    output logic [31:0] RD2
    

);
    logic [31:0] mem [32];//32 registros, los 31 a 0 van empaquetados

    int i;
    always_ff @ (posedge clk) begin
        if (rst) for (i = 0 ; i < 32; i++)  mem[i] <= 0;
        else if (WE3) mem[A3] <= WD3;
    end


     //Lectura
    assign RD1 = (A1 == 0) ? 32'h00000000 : mem[A1];
    assign RD2 = (A2 == 0) ? 32'h00000000 : mem[A2];

endmodule
//--------------Alu Proyecto corto 3 y submodulos-----------------------------//
module alu(
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
//-------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------//

//RAM
module dmem(
    input               clk,
    input               rst,
    input               WE,
    input        [31:0] A,
    input        [31:0] WD,
    output logic [31:0] RD
);
    //No se recomiendan declarar 4GB de memoria estatica
    //Mejor:Usar un arreglo asociativo(associative array)
    //Solo se usan las posiciones de memoria que se escriben
    logic [31:0] mem[logic[31:0]];//2^32 posiciones memoria dinamica

    
    //escritura
    always @(posedge clk) begin
        if (rst) begin
            mem.delete();
            // Precarga los valores en las direcciones de memoria espec�ficas
            mem[1000] = 32'h21212121; // dmem[1000] = 0x21212121
            mem[1004] = 32'h23232323; // dmem[1004] = 0x23232323
        end
        else if (WE) begin
            mem[A] = WD;
        end

    end

    //Lectura
  
    always_comb begin
        if (^A === 1'bX) begin
            RD = 32'h00000000; // Valor predeterminado si la dirección es indefinida
        end else if (mem.exists(A)) begin
            RD = mem[A];
        end else begin
            RD = 32'h00000000; // Valor predeterminado si la dirección no existe
        end
    end 
    


endmodule

//---------------------------------------------------//

module mux32 (
    input sel,
    input [31:0] A,
    input [31:0] B,
    output logic [31:0] Q

);

    always_comb begin
        assign Q = sel ? B: A;
    end


endmodule
//--------------------------------------------//

module add32 (
    input [31:0] A,
    input [31:0] B,
    output logic [31:0] Q

);

    always_comb assign Q = A + B;
endmodule

//------------------------------------------//

module Extend(
    input  [1:0]        sel,
    input [31:0]        A,
    output logic [31:0] Q
);
    always_comb begin
        case (sel)
            2'b00: Q = { {20{A[31]}},A[31:20] } ;//instrucc Tipo I
            2'b01: Q = { {20{A[31]}},A[31:25], A[11:7]  };//instrucc Tipo S
            2'b10: Q = { {20{A[31]}},A[31], A[7], A[30:25], A[11:8] , 1'b0  }; //Tipo B
            2'b11: Q = 32'hDEADBEEF;
        endcase
    end

endmodule

//---------------Modulo de control Uniciclo parte Proyecto Corto 5------------------------
module control_unit(
    input [6:0] op, 
    input [2:0] funct3, 
    input       funct7_bit5, 
    input       Zero, 
    output logic PCSrc, 
    output logic ResultSrc, 
    output logic MemWrite, 
    output logic [2:0] ALUControl, 
    output logic  ALUSrc, 
    output logic [1:0] ImmSrc, 
    output logic RegWrite
);  
    logic Branch; 
    logic [1:0] ALUop;  
    
    
    //logic Zero;   //revisar la bandera de 0 
    assign PCSrc = Branch && Zero; 
     
    
    //decoficador principal 
    always_comb begin 
    case(op)
    
    3: //lw   
    begin
        RegWrite = 1'b1; 
        ImmSrc   = 2'b00; 
        ALUSrc  = 1'b1;
        MemWrite = 1'b0; 
        ResultSrc = 1'b1;
        Branch =  1'b0; 
        ALUop =  2'b00;  
    end 
    
    35: //sw 
    begin
        RegWrite = 1'b0; 
        ImmSrc   = 2'b01; 
        ALUSrc  = 1'b1;
        MemWrite = 1'b1; 
        ResultSrc = 1'b0;    //x
        Branch =  1'b0; 
        ALUop =  2'b00; 
         
    end 
    
    51: //R-Type 
    begin
        RegWrite = 1'b1; 
        ImmSrc   = 2'b00;  //xx 
        ALUSrc  = 1'b0;
        MemWrite = 1'b0; 
        ResultSrc = 1'b0;
        Branch =  1'b0; 
        ALUop =  2'b10;  
    end 
    
        
    19: //I-Type 
    begin
        RegWrite = 1'b1; 
        ImmSrc   = 2'b00;  //xx 
        ALUSrc  = 1'b1;
        MemWrite = 1'b0; 
        ResultSrc = 1'b0;
        Branch =  1'b0; 
        ALUop =  2'b10;  
    end 
    
    99: //beq
    begin
        RegWrite = 1'b0; 
        ImmSrc   = 2'b10; 
        ALUSrc  = 1'b0;
        MemWrite = 1'b0; 
        ResultSrc = 1'b0;   //x
        Branch =  1'b1; 
        ALUop =  2'b01;  
    end 
    
    default: //no implementada
        begin
        RegWrite = 1'b0; 
        ImmSrc   = 2'b00; 
        ALUSrc  = 1'b0;
        MemWrite = 1'b0; 
        ResultSrc = 1'b0;   //x
        Branch =  1'b0; 
        ALUop =  2'b00;  
    end 
    endcase 
    end 
    
    
    
    //Decodoficador ALU 
    always_comb begin
     casez({ALUop, funct3, op[5], funct7_bit5})
     7'b00zzzzz : ALUControl = 3'b000;   //lw, sw 
     7'b01zzzzz : ALUControl = 3'b001;   //beq
     7'b1000000 : ALUControl = 3'b000;   //add  
     7'b1000001 : ALUControl = 3'b000;   //add
     7'b1000010 : ALUControl = 3'b000;   //add
     7'b1000011 : ALUControl = 3'b001;   //sub
     7'b10010zz : ALUControl = 3'b101;   //slt
     7'b10110zz : ALUControl = 3'b011;   //or
     7'b10111zz : ALUControl = 3'b010;   //and   
     default :    ALUControl = 3'bzzz; 
     
     endcase 
    end 
endmodule