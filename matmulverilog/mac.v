module mac #(
    parameter Nbits = 8
) (
    input clk,
    input reset,
    input [Nbits-1:0] multiplier,
    input [Nbits-1:0] multiplicand,
    output reg [2*Nbits-1:0] accumulator_out
);


    wire [2*Nbits-1:0] oprod, omux;
    mul #(
        .Nbits(Nbits)
    ) multi (
        .multiplier_u(multiplier),
        .multiplicand_u(multiplicand),
        .mult_out_u(oprod)
    );

    assign omux = reset ? 0 : accumulator_out;

    always @(posedge clk) begin
        accumulator_out <= omux + oprod;
    end

endmodule
