

module mul
    #(parameter Nbits = 8)
    (
    input [Nbits - 1:0] multiplier_u,
    input [Nbits - 1:0] multiplicand_u,
    output [2*Nbits-1:0] mult_out_u
    );

    assign mult_out_u = multiplier_u*multiplicand_u;
endmodule
