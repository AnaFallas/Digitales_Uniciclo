//TestBench 


`timescale 1ns/1ps //escala de tiempo

module uni_tb();

    logic clk;
    logic rst;
    wire [31:0] ReadData;

    uni uni1(
        .clk(clk),
        .rst(rst),
        .Result(ReadData)

    );

    initial begin
        rst = 1;

        #40;
        rst= 0;

        #400;

        $finish();

    end

    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end




endmodule