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
