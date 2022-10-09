module slave_mux #(
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

wire [DATA_WD-1 : 0] prdata0, prdata1, prdata2, prdata3;
wire                 psel0,   psel1,   psel2,   psel3;
wire                 pready0, pready1, pready2, pready3;

wire [1 : 0] addrx;
wire [3 : 0] selx;

reg [DATA_WD-1 : 0] b_prdata_r;

assign b_prdata = b_prdata_r;

assign addrx = b_paddr[ADDR_WD-1 : ADDR_WD-2];
assign selx  = {addrx == 2'd3, addrx == 2'd2, addrx == 2'd1, addrx == 2'd0};
assign psel0 = b_psel && selx[0];
assign psel1 = b_psel && selx[1];
assign psel2 = b_psel && selx[2];
assign psel3 = b_psel && selx[3];

assign b_pready = pready0 && selx[0] || pready1 && selx[1] || pready2 && selx[2] || pready2 && selx[3]; 

always @(*) begin
    case (selx)
        4'b0001: b_prdata_r = prdata0;
        4'b0010: b_prdata_r = prdata1;
        4'b0100: b_prdata_r = prdata2;
        4'b1000: b_prdata_r = prdata3;
        default: b_prdata_r = prdata0;
    endcase
end

slave #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  slave0(
    .b_pclk(b_pclk),
    .b_prst_n(b_prst_n),
    .b_psel(psel0),
    .b_penable(b_penable),
    .b_pwrite(b_pwrite),
    .b_paddr(b_paddr),
    .b_pwdata(b_pwdata),
    .b_pprot(b_pprot),
    .b_pstrb(b_pstrb),
    .b_prdata(prdata0),
    .b_pready(pready0)
);

slave #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  slave1(
    .b_pclk(b_pclk),
    .b_prst_n(b_prst_n),
    .b_psel(psel1),
    .b_penable(b_penable),
    .b_pwrite(b_pwrite),
    .b_paddr(b_paddr),
    .b_pwdata(b_pwdata),
    .b_pprot(b_pprot),
    .b_pstrb(b_pstrb),
    .b_prdata(prdata1),
    .b_pready(pready1)
);

slave #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  slave2(
    .b_pclk(b_pclk),
    .b_prst_n(b_prst_n),
    .b_psel(psel2),
    .b_penable(b_penable),
    .b_pwrite(b_pwrite),
    .b_paddr(b_paddr),
    .b_pwdata(b_pwdata),
    .b_pprot(b_pprot),
    .b_pstrb(b_pstrb),
    .b_prdata(prdata2),
    .b_pready(pready2)
);

slave #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  slave3(
    .b_pclk(b_pclk),
    .b_prst_n(b_prst_n),
    .b_psel(psel3),
    .b_penable(b_penable),
    .b_pwrite(b_pwrite),
    .b_paddr(b_paddr),
    .b_pwdata(b_pwdata),
    .b_pprot(b_pprot),
    .b_pstrb(b_pstrb),
    .b_prdata(prdata3),
    .b_pready(pready3)
);

endmodule