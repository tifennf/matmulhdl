

module mult_mat_vec_comb #(
    parameter Mdata = 4,
    Ndata = 4,
    Nbits = 8
) (
    input [Mdata*Ndata*Nbits-1:0] M,
    input [Ndata*Nbits-1:0] X,
    output [Mdata*(2*Nbits)-1:0] out
);

    genvar i;
    for (i = 0; i < Mdata; i = i + 1) begin
        scalar_product #(
            .Ndata(Ndata),
            .Nbits(Nbits)
        ) sp (
            .A  (M[(i+1)*Ndata*Nbits-1:i*Ndata*Nbits]),
            .B  (X[Ndata*Nbits-1:0]),
            .out(out[(i+1)*2*Nbits-1:i*2*Nbits])
        );
    end


endmodule
