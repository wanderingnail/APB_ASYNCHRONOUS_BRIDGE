module asyn_bridge_top #(
    parameter ADDR_WD = 32,
    parameter DATA_WD = 32,
    parameter STRB_WD = 4,
    parameter PROT_WD = 3
)(
    input                  a_pclk,
    input                  a_prst_n,

    input                  a_psel,
    input                  a_penable,
    input                  a_pwrite,
    input  [ADDR_WD-1 : 0] a_paddr,
    input  [DATA_WD-1 : 0] a_pwdata,
    input  [PROT_WD-1 : 0] a_pprot,
    input  [STRB_WD-1 : 0] a_pstrb,
    output [DATA_WD-1 : 0] a_prdata,
    output                 a_pready,

    input                  b_pclk,
    input                  b_prst_n,

    output                 b_psel,
    output                 b_penable,
    output                 b_pwrite,
    output [ADDR_WD-1 : 0] b_paddr,
    output [DATA_WD-1 : 0] b_pwdata,
    output [PROT_WD-1 : 0] b_pprot,
    output [STRB_WD-1 : 0] b_pstrb,
    input  [DATA_WD-1 : 0] b_prdata,
    input                  b_pready                   
);

wire                 a_apb_req;
wire                 write;
wire [ADDR_WD-1 : 0] addr;
wire [DATA_WD-1 : 0] wdata;
wire [PROT_WD-1 : 0] prot;
wire [STRB_WD-1 : 0] strb;
wire                 b_ready_req;
wire [DATA_WD-1 : 0] rdata;

high_frequency_apb #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  high_frequency(
    .a_pclk(a_pclk),
    .a_prst_n(a_prst_n),
    .a_psel(a_psel),
    .a_penable(a_penable),
    .a_pwrite(a_pwrite),
    .a_paddr(a_paddr),
    .a_pwdata(a_pwdata),
    .a_pprot(a_pprot),
    .a_pstrb(a_pstrb),
    .a_prdata(a_prdata),
    .a_pready(a_pready),
    .a_apb_req(a_apb_req),
    .write(write),
    .addr(addr),
    .wdata(wdata),
    .prot(prot),
    .strb(strb),
    .b_ready_req(b_ready_req),
    .rdata(rdata)
);

low_frequency_apb #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
) low_frequency(
    .b_pclk(b_pclk),
    .b_prst_n(b_prst_n),
    .b_psel(b_psel),
    .b_penable(b_penable),
    .b_pwrite(b_pwrite),
    .b_paddr(b_paddr),
    .b_pwdata(b_pwdata),
    .b_pprot(b_pprot),
    .b_pstrb(b_pstrb),
    .b_prdata(b_prdata),
    .b_pready(b_pready),
    .a_apb_req(a_apb_req),
    .write(write),
    .addr(addr),
    .wdata(wdata),
    .prot(prot),
    .strb(strb),
    .b_ready_req(b_ready_req),
    .rdata(rdata)
);
    
endmodule