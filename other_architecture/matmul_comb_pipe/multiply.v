module multiply
#(parameter Ndata = 4, Nbits=8)
(
input [Nbits*Ndata-1:0] multiplier,
input [Nbits*Ndata-1:0] multiplicand,
output [Ndata*2*Nbits-1:0] mult_out
);

genvar i;
wire [2*Nbits*Ndata-1 :0] prod;

generate
    for(i=0;i<Ndata;i=i+1) begin
        mul#(.Nbits(Nbits))
        multi (
        .multiplier_u(multiplier[Nbits*(i+1) - 1: i*Nbits]),
        .multiplicand_u(multiplicand[Nbits*(i+1) -1 : i*Nbits]),
        .mult_out_u(prod[2*Nbits*i+2*Nbits-1: 2*Nbits*i])
        );
    end
endgenerate

assign mult_out = prod[2*Nbits*Ndata-1:0];

endmodule
