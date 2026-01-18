

module mult_mat_vec_pipe #(
    parameter Mdata = 4,
    Ndata = 4,
    Nbits = 8
) (
    input [Mdata*Ndata*Nbits-1:0] M,
    input [Ndata*Nbits-1:0] X,
    input clk,
    input reset,
    output reg [Mdata*(2*Nbits)-1:0] out
);
    wire [2*Nbits-1:0] sp_out;
    reg  [$clog2(Ndata+1)-1:0]cpt;

    reg [Mdata*Ndata*Nbits-1:0] Z_tmp;

    scalar_product_pipe #(
        .Nbits(Nbits)
    ) sp (
        .A  (Z_tmp[Ndata*Nbits-1:0]),
        .B  (X[Ndata*Nbits-1:0]),
        .clk(clk),
        .reset(reset),
        .out(sp_out[2*Nbits-1:0])
    );

    always @(posedge clk) begin
        if(reset) begin
            cpt <=0;
            out <=0;
            Z_tmp[Mdata*Ndata*Nbits-1:0] <= M[Mdata*Ndata*Nbits-1:0];
        end else begin
            if(cpt < Ndata) begin
                Z_tmp <= (Z_tmp >> Ndata*Nbits);
            end else begin
                out[Mdata*2*Nbits-1:0] <= {sp_out[2*Nbits-1:0], out[Mdata*2*Nbits - 1:2*Nbits]};
            end
            cpt <= cpt+1;
        end
    end


endmodule
