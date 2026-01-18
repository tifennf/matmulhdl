module scalar_product_mac #(
    parameter Ndata = 4,
    Nbits = 8
) (
    input [Nbits*Ndata-1:0] A,
    input [Nbits*Ndata-1:0] B,
    input clk,
    input reset,
    output reg [2*Nbits-1:0] out
);

    reg [Nbits*Ndata-1:0] A_reg, B_reg;
    reg [4:0] index;


    reg [Nbits-1:0] multiplier;
    reg [Nbits-1:0] multiplicand;
    wire [2*Nbits-1:0] mac_acc;

    mac #(.Nbits(Nbits)) mac_inst (
    .clk(clk),
    .reset(reset),
    .multiplier(multiplier),
    .multiplicand(multiplicand),
    .accumulator_out(mac_acc)
    );

    // assign out = mac_acc;

    always @(posedge clk) begin
        // On va shift les entrées à chaque front montant si index < Ndata
        if(reset) begin
            A_reg <= A;
            B_reg <= B;
            multiplier <= 0;
            multiplicand <=0;
            index <= 0;

        end else if (index <= Ndata) begin
            multiplier <= A_reg[Nbits-1:0];
            multiplicand <= B_reg[Nbits-1:0];

            A_reg <= A_reg >> Nbits;
            B_reg <= B_reg >> Nbits;
            index <= index +1;
        end else begin
            out <= mac_acc;
        end
    end

endmodule
