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
            // Precarga los valores en las direcciones de memoria espec ficas
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


