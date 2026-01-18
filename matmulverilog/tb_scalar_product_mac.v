module tb_scalar_product_mac ();
    localparam Nbits = 4;
    localparam Ndata = 4;
    localparam Ntests = 100;
    reg clk = 1'b0;
    always #2 clk <= !clk;

    // mémoire pour les fichiers de données
    reg     [Ndata*Nbits-1:0] rom_A        [0:Ntests-1];
    reg     [Ndata*Nbits-1:0] rom_B        [0:Ntests-1];
    reg     [    2*Nbits-1:0] rom_exp      [0:Ntests-1];

    integer                   i;
    integer                   errors = 0;
    reg     [    2*Nbits-1:0] expected_val;

    reg                       reset;
    reg     [Ndata*Nbits-1:0] A;
    reg     [Ndata*Nbits-1:0] B;
    wire    [   2*Nbits -1:0] out;

    scalar_product_mac #(
        .Nbits(4),
        .Ndata(4)
    ) scalar_product_inst (
        .A(A),
        .B(B),
        .out(out),
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("dump_scalar_product_mac.vcd");
        $dumpvars(0, tb_scalar_product_mac);

        $readmemh("data_sp_A.hex", rom_A);
        $readmemh("data_sp_B.hex", rom_B);
        $readmemh("data_sp_expected.hex", rom_exp);

        A <= 0;
        B <= 0;
        reset <= 1;

        $display("--- Démarrage du Test Automatique (%0d vecteurs) ---", Ntests);

        for (i = 0; i < Ntests; i = i + 1) begin
            @(posedge clk);
            reset <=1;
            A <= rom_A[i];
            B <= rom_B[i];
            expected_val = rom_exp[i];

            repeat (2) @(posedge clk);
            reset <=0;

            repeat (10) @(posedge clk); // 40ns
            if (out !== expected_val) begin
                $display("[ERREUR] Time %0t | i=%0d", $time, i);
                $display("    A: %h | B: %h", rom_A[i], rom_B[i]);
                $display("    Attendu: %h | Obtenu: %h", expected_val, out);
                errors = errors + 1;
            end
        end

        repeat (400) @(posedge clk);
        $display("Test Complete, %0d errors", errors);
        $finish();
    end

endmodule
