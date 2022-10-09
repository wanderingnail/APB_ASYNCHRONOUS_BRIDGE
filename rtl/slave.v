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

reg [DATA_WD-1 : 0] mem [(1 << ADDR_WD)-1 : 0];

assign b_pready = 1;

always @(posedge b_pclk or negedge b_prst_n ) begin
    if (b_psel && b_pwrite && b_pready) begin
        mem[b_paddr] <= b_pwdata;
    end
end

assign b_prdata = mem[b_paddr];

endmodule