module high_frequency_apb #(
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

    output                 a_apb_req,
    output                 write,
    output [ADDR_WD-1 : 0] addr,
    output [DATA_WD-1 : 0] wdata,
    output [PROT_WD-1 : 0] prot,
    output [STRB_WD-1 : 0] strb,

    input                  b_ready_req,
    input  [DATA_WD-1 : 0] rdata                   
);

reg                 a_pwrite_r;
reg [ADDR_WD-1 : 0] a_paddr_r;
reg [DATA_WD-1 : 0] a_pwdata_r;
reg [PROT_WD-1 : 0] a_pprot_r;
reg [STRB_WD-1 : 0] a_pstrb_r;
reg [DATA_WD-1 : 0] a_prdata_r;
reg                 a_pready_r;
reg                 a_apb_req_r;

wire b2a_ready_req_edge;

reg q1_r, q2_r, q3_r;

always @(posedge a_pclk or negedge a_prst_n) begin
    if (!a_prst_n) begin
        a_apb_req_r <= 1'b0;
    end
    else if (a_psel && !a_penable) begin
        a_apb_req_r <= !a_apb_req_r;
        a_pwrite_r  <= a_pwrite;
        a_pwdata_r  <= a_pwdata;
        a_paddr_r   <= a_paddr;
        a_pprot_r   <= a_pprot;
        a_pstrb_r   <= a_pstrb;
    end    
end

assign a_apb_req = a_apb_req_r;
assign write     = a_pwrite_r;
assign addr      = a_paddr_r;
assign wdata     = a_pwdata_r;
assign prot      = a_pprot_r;
assign strb      = a_pstrb;

// generate pulse
always @(posedge a_pclk or negedge a_prst_n) begin
    if (!a_prst_n) begin
        {q1_r, q2_r, q3_r} <= 'b0;
    end
    else begin
        {q1_r, q2_r, q3_r} <= {b_ready_req, q1_r, q2_r};
    end
end

assign b2a_ready_req_edge = q2_r ^ q3_r;

always @(posedge a_pclk or negedge a_prst_n) begin
    if (!a_prst_n) begin
        a_pready_r <= 1'b1;
    end
    else if (a_psel) begin
        a_pready_r <= 1'b0;
    end
    if (b2a_ready_req_edge) begin
        a_pready_r <= 1'b1;
    end
end

assign a_pready = a_pready_r;
assign a_prdata = rdata;

endmodule
