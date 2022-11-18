module slave #(
    parameter ADDR_WD = 32,
    parameter DATA_WD = 32,
    parameter STRB_WD = 4,
    parameter PROT_WD = 3
)(
    input                  b_pclk,
    input                  b_prst_n,

    input                  b_psel,
    input                  b_penable,
    input                  b_pwrite,
    input  [ADDR_WD-1 : 0] b_paddr,
    input  [DATA_WD-1 : 0] b_pwdata,
    input  [PROT_WD-1 : 0] b_pprot,
    input  [STRB_WD-1 : 0] b_pstrb,
    output [DATA_WD-1 : 0] b_prdata,
    output                 b_pready                
);

localparam ADDR_WD_L = ADDR_WD - 2;

reg  [DATA_WD-1 : 0] mem [(1 << ADDR_WD_L)-1 : 0];

wire [ADDR_WD_L-1 : 0] b_paddr_L;

assign b_paddr_L = b_paddr[ADDR_WD_L-1 : 0];
assign b_prdata  = mem[b_paddr_L];
assign b_pready  = 1'b1;

always @(posedge b_pclk or negedge b_prst_n ) begin
    if (b_penable && b_pwrite && b_pready) begin
        mem[b_paddr_L] <= b_pwdata;
    end
end

endmodule