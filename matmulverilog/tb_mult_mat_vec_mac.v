module tb_mult_mac_vec_mac;
    reg clk = 1'b0;
    reg reset;
    always #2 clk <= !clk;
    localparam integer Mdata = 4;
    localparam integer Ndata = 4;
    localparam integer Nbits = 8;

    // Entrées / sorties
    reg enable;
    reg [Mdata*Ndata*Nbits-1:0] M_flat;
    reg [Ndata*Nbits-1:0] N;
    wire [Ndata*(2*Nbits)-1:0] C;


    mult_mat_vec_mac #(
        .Mdata(Mdata),
        .Ndata(Ndata),
        .Nbits(Nbits)
    ) dut (
        .M(M_flat),
        .X(N),
        .clk(clk),
        .reset(reset),

        .out(C)
    );

    integer i, j;
    integer idx;
    initial begin
        $dumpfile("dump_mult_mac_vec_mac.vcd");
        $dumpvars(0, tb_mult_mac_vec_mac);
        reset <= 1;
        // init
        M_flat <= 0;
        N <= 0;
        #40;
        M_flat[Ndata*Nbits-1:0] = {8'd5, 8'd6, 8'd7, 8'd1};
        M_flat[2*Ndata*Nbits-1:Ndata*Nbits] = {8'd4, 8'd3, 8'd2, 8'd1};
        M_flat[3*Ndata*Nbits-1:2*Ndata*Nbits] = {8'd4, 8'd5, 8'd0, 8'd0};
        M_flat[4*Ndata*Nbits-1:3*Ndata*Nbits] = {8'd1, 8'd3, 8'd5, 8'd2};
        N = {8'd1, 8'd2, 8'd1, 8'd1};
        #100;
        reset <= 0;

        #100;

        $finish;
    end
endmodule
