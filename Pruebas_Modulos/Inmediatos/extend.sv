module extend(
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