

module scalar_product_pipe #(
    parameter Nbits = 8
) (
    input clk,
    input reset,
    input [4*Nbits-1:0] A,
    input [4*Nbits-1:0] B,
    output reg [2*Nbits-1:0] out
);

    // décomposition de A et B
    wire [Nbits-1:0] a1, a2, a3, a4;
    wire [Nbits-1:0] b1, b2, b3, b4;

    assign a1[Nbits-1:0] = A[Nbits-1:0];
    assign b1[Nbits-1:0] = B[Nbits-1:0];
    assign a2[Nbits-1:0] = A[2*Nbits-1:Nbits];
    assign b2[Nbits-1:0] = B[2*Nbits-1:Nbits];
    assign a3[Nbits-1:0] = A[3*Nbits-1:2*Nbits];
    assign b3[Nbits-1:0] = B[3*Nbits-1:2*Nbits];
    assign a4[Nbits-1:0] = A[4*Nbits-1:3*Nbits];
    assign b4[Nbits-1:0] = B[4*Nbits-1:3*Nbits];


    // pipeline des données pour les retarder

    // entrées du stage 2
    reg [Nbits-1:0] a2_tmp1, b2_tmp1;  // retard de 1 cycle

    // entrées du stage 3
    reg [Nbits-1:0] a3_tmp1, b3_tmp1;  // retard de 1 cycle
    reg [Nbits-1:0] a3_tmp2, b3_tmp2;  // retard de 2 cycle

    // entrées du stage 4
    reg [Nbits-1:0] a4_tmp1, b4_tmp1;  // retard de 1 cycle
    reg [Nbits-1:0] a4_tmp2, b4_tmp2;  // retard de 2 cycle
    reg [Nbits-1:0] a4_tmp3, b4_tmp3;  // retard de 3 cycle



    reg [8*Nbits-1:0] init, stage1_out;
    wire [2*Nbits-1:0] mult1_out, add1_out;

    mul #(
        .Nbits(Nbits)
    ) multi1 (
        .multiplier_u(a1[Nbits-1:0]),
        .multiplicand_u(b1[Nbits-1:0]),
        .mult_out_u(mult1_out[2*Nbits-1:0])
    );

    assign add1_out = mult1_out + init;

    reg [8*Nbits-1:0] stage2_out;
    wire [2*Nbits-1:0] mult2_out, add2_out;

    mul #(
        .Nbits(Nbits)
    ) multi2 (
        .multiplier_u(a2_tmp1[Nbits-1:0]),
        .multiplicand_u(b2_tmp1[Nbits-1:0]),
        .mult_out_u(mult2_out[2*Nbits-1:0])
    );

    assign add2_out = mult2_out + stage1_out;

    reg [8*Nbits-1:0] stage3_out;
    wire [2*Nbits-1:0] mult3_out, add3_out;

    mul #(
        .Nbits(Nbits)
    ) multi3 (
        .multiplier_u(a3_tmp2[Nbits-1:0]),
        .multiplicand_u(b3_tmp2[Nbits-1:0]),
        .mult_out_u(mult3_out[2*Nbits-1:0])
    );

    assign add3_out = mult3_out + stage2_out;

    reg [8*Nbits-1:0] stage4_out;
    wire [2*Nbits-1:0] mult4_out, add4_out;

    mul #(
        .Nbits(Nbits)
    ) multi4 (
        .multiplier_u(a4_tmp3[Nbits-1:0]),
        .multiplicand_u(b4_tmp3[Nbits-1:0]),
        .mult_out_u(mult4_out[2*Nbits-1:0])
    );

    assign add4_out = mult4_out + stage3_out;


    always @(posedge clk) begin
        if (reset) begin
            init <= 0;
            stage1_out <= 0;
            stage2_out <= 0;
            stage3_out <= 0;
            stage4_out <= 0;

            a2_tmp1 <= 0;
            b2_tmp1 <= 0;

            a3_tmp1 <= 0;
            b3_tmp1 <= 0;
            a3_tmp2 <= 0;
            b3_tmp2 <= 0;

            a4_tmp1 <= 0;
            b4_tmp1 <= 0;
            a4_tmp2 <= 0;
            b4_tmp2 <= 0;
            a4_tmp3 <= 0;
            b4_tmp3 <= 0;


        end else begin
            // Chargement

            // Stage 1
            // sauvegarde
            stage1_out <= add1_out;

            // retard de 1 cycle de toutes les données suivantes
            a2_tmp1[Nbits-1:0] <= a2[Nbits-1:0];
            b2_tmp1[Nbits-1:0] <= b2[Nbits-1:0];

            a3_tmp1[Nbits-1:0] <= a3[Nbits-1:0];
            b3_tmp1[Nbits-1:0] <= b3[Nbits-1:0];

            a4_tmp1[Nbits-1:0] <= a4[Nbits-1:0];
            b4_tmp1[Nbits-1:0] <= b4[Nbits-1:0];

            // Stage 2
            stage2_out <= add2_out;

            // retard de 1 cycle de toutes les données suivantes
            a3_tmp2[Nbits-1:0] <= a3_tmp1[Nbits-1:0];
            b3_tmp2[Nbits-1:0] <= b3_tmp1[Nbits-1:0];

            a4_tmp2[Nbits-1:0] <= a4_tmp1[Nbits-1:0];
            b4_tmp2[Nbits-1:0] <= b4_tmp1[Nbits-1:0];

            // Stage 3
            stage3_out <= add3_out;

            a4_tmp3[Nbits-1:0] <= a4_tmp2[Nbits-1:0];
            b4_tmp3[Nbits-1:0] <= b4_tmp2[Nbits-1:0];

            // Stage 4
            out <= add4_out;
            // out <=stage4_out;

        end

    end

endmodule
