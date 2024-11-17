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