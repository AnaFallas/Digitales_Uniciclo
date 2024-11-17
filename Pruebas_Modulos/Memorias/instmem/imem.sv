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
