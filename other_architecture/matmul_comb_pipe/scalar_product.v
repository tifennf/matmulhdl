module scalar_product #(
    parameter Ndata = 4,
    Nbits = 8
) (
    input [Nbits*Ndata-1:0] A,
    input [Nbits*Ndata-1:0] B,
    output [2*Nbits-1:0] out
);

    wire [(Ndata+1)*2*Nbits-1 : 0] sumi;

    wire [Ndata*2*Nbits-1:0] prod;
    assign sumi[2*Nbits-1:0] = 0;

    multiply #(
        .Nbits(Nbits),
        .Ndata(Ndata)
    ) multi (
        .multiplier(A[Nbits*Ndata-1:0]),
        .multiplicand(B[Nbits*Ndata-1:0]),
        .mult_out(prod[Ndata*2*Nbits-1:0])
    );

    genvar i;
    generate
        for (i = 0; i < Ndata; i = i + 1) begin
            assign sumi[(i+2)*2*Nbits-1:(i+1)*2*Nbits] = prod[(i+1)*2*Nbits-1: i*2*Nbits] + sumi[(i+1)*2*Nbits-1: i*2*Nbits];
        end
    endgenerate

    assign out = sumi[(Ndata+1)*2*Nbits-1:Ndata*2*Nbits];

endmodule
