module add32 (
    input [31:0] A,
    input [31:0] B,
    output logic [31:0] Q

);

    always_comb assign Q = A + B;
endmodule