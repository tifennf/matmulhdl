module scalar_product_Nmac #(
    parameter Nbits = 4,
    Ndata = 4,
    Nmac = 4
) (
    input clk,
    input reset,
    input [Ndata*Nbits-1:0] A,
    input [Ndata*Nbits-1:0] B,
    output reg [2*Nbits-1:0] out
);

localparam len_output_mac = 2*Nbits;
localparam len_output = 2*Nbits;

reg [Ndata*Nbits-1:0] A_tmp, B_tmp;

wire [Nmac*len_output_mac-1:0] outk;
wire [(Nmac+1)*len_output-1:0] sum; // pour la réduction

assign sum[len_output-1:0] = 0;

// calcul parallèle
genvar k;
for(k=0; k< Nmac;k=k+1) begin
    scalar_product_mac #(
    .Nbits(Nbits),
    .Ndata(Ndata/Nmac)
    ) M (
        .clk(clk),
        .reset(reset),
        .A(A_tmp[((k+1)*Ndata/Nmac)*Nbits-1:(k*Ndata/Nmac)*Nbits]),
        .B(B_tmp[((k+1)*Ndata/Nmac)*Nbits-1:(k*Ndata/Nmac)*Nbits]),
        .out(outk[(k+1)*len_output_mac-1:k*len_output_mac])
    );

    assign sum[(k+2)*len_output-1:(k+1)*2*Nbits] = outk[(k+1)*len_output_mac-1:k*len_output_mac] + sum[(k+1)*len_output-1:k*len_output];
end

always @(posedge clk) begin
    if(reset) begin
        A_tmp <=A;
        B_tmp <=B;
        out <=0;
    end else begin
        if(A!=A_tmp && B!= B_tmp)begin
            A_tmp <= A;
            B_tmp <= B;

        end

        out[2*Nbits-1:0] <= sum[(Nmac+1)*2*Nbits-1:Nmac*len_output];
    end
end

// assign out = sum[(Nmac+1)*2*Nbits-1:Nmac*2*Nbits];

endmodule
