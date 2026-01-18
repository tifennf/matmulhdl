module tb_mult_mac_vec_pipe;
    reg clk = 1'b0;
    reg reset;
    always #2 clk <= !clk;

    localparam integer Mdata = 4;
    localparam integer Ndata = 4;
    localparam integer Nbits = 4;

    // Entrées / sorties
    reg enable;
    reg [Mdata*Ndata*Nbits-1:0] M_flat;
    reg [Ndata*Nbits-1:0] N;
    wire [Ndata*(2*Nbits)-1:0] C;


    mult_mat_vec_pipe #(
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
        $dumpfile("dump_mult_mac_vec_pipe.vcd");
        $dumpvars(0, tb_mult_mac_vec_pipe);
        reset <= 1;
        // init
        M_flat <= 0;
        N <= 0;
        #40;
        M_flat[Ndata*Nbits-1:0] = {4'd5, 4'd6, 4'd7, 4'd1};
        M_flat[2*Ndata*Nbits-1:Ndata*Nbits] = {4'd4, 4'd3, 4'd2, 4'd1};
        M_flat[3*Ndata*Nbits-1:2*Ndata*Nbits] = {4'd4, 4'd5, 4'd0, 4'd0};
        M_flat[4*Ndata*Nbits-1:3*Ndata*Nbits] = {4'd1, 4'd3, 4'd5, 4'd2};
        N = {4'd1, 4'd2, 4'd1, 4'd1};
        #100;
        reset <= 0;

        #100;

        $finish;
    end
endmodule
