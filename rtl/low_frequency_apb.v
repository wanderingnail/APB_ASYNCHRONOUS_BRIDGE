module low_frequency_apb #(
    parameter ADDR_WD = 32,
    parameter DATA_WD = 32,
    parameter STRB_WD = 4,
    parameter PROT_WD = 3
)(
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
    input                  b_pready,

    input                  a_apb_req,
    input                  write,
    input  [ADDR_WD-1 : 0] addr,
    input  [DATA_WD-1 : 0] wdata,
    input  [PROT_WD-1 : 0] prot,
    input  [STRB_WD-1 : 0] strb,

    output                 b_ready_req,
    output [DATA_WD-1 : 0] rdata                   
);

reg [DATA_WD-1 : 0] rdata_r;

reg b_psel_r;
reg b_penable_r;
reg b_ready_req_r;

reg                 b_pwrite_r;
reg [ADDR_WD-1 : 0] b_paddr_r;
reg [DATA_WD-1 : 0] b_pwdata_r;
reg [PROT_WD-1 : 0] b_pprot_r;
reg [STRB_WD-1 : 0] b_pstrb_r;

reg q1_r, q2_r, q3_r;

wire a2b_apb_req_edge;

// generate pulse
always @(posedge b_pclk or negedge b_prst_n) begin
    if (!b_prst_n) begin
        {q1_r, q2_r, q3_r} <= 'b0;
    end
    else begin
        {q1_r, q2_r, q3_r} <= {a_apb_req, q1_r, q2_r};
    end
end

assign a2b_apb_req_edge = q2_r ^ q3_r;

//  control path
always @(posedge b_pclk or negedge b_prst_n) begin
    if (!b_prst_n) begin
        b_psel_r <= 1'b0;
    end
    else begin 
        if (a2b_apb_req_edge) begin
            b_psel_r <= 1'b1;
        end     
        else if (b_penable && b_pready) begin
            b_psel_r <= 1'b0;
        end
    end
end

always @(posedge b_pclk or negedge b_prst_n) begin
    if (!b_prst_n) begin
        b_penable_r   <= 1'b0;
        b_ready_req_r <= 1'b0;
    end
    else begin
        if (b_psel) begin
            b_penable_r <= 1'b1;
        end
        if (b_penable && b_pready) begin
            b_penable_r   <= 1'b0;
            b_ready_req_r <= ~b_ready_req_r;
        end
    end
end

assign b_psel      = b_psel_r;
assign b_penable   = b_penable_r;
assign b_ready_req = b_ready_req_r;

always @(posedge b_pclk) begin
    if (a2b_apb_req_edge) begin
        b_pwrite_r <= write;
        b_pwdata_r <= wdata;
        b_paddr_r  <= addr;
        b_pprot_r  <= prot;
        b_pstrb_r  <= strb;
    end
end

assign b_pwrite = b_pwrite_r;
assign b_pwdata = b_pwdata_r;
assign b_paddr  = b_paddr_r;
assign b_pprot  = b_pprot_r;
assign b_pstrb  = b_pstrb_r;

always @(posedge b_pclk or negedge b_prst_n) begin
    if (!b_prst_n) begin
        rdata_r <= 'b0;
    end
    else if (!b_pwrite && b_psel) begin
        rdata_r <= b_prdata;
    end
end

assign rdata = rdata_r;

endmodule



