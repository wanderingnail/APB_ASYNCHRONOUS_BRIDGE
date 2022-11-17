`timescale 1ns / 1ns
module tb_asyn_bridge;

localparam ADDR_WD = 8,
           DATA_WD = 8,
           STRB_WD = 2,
           PROT_WD = 4;

reg                  a_pclk;
reg                  a_prst_n;
reg                  b_pclk;
reg                  b_prst_n;
reg                  a_psel;
reg                  a_penable;
reg                  a_pwrite;
reg  [ADDR_WD-1 : 0] a_paddr;
reg  [DATA_WD-1 : 0] a_pwdata;
reg  [PROT_WD-1 : 0] a_pprot;
reg  [STRB_WD-1 : 0] a_pstrb;

wire [DATA_WD-1 : 0] a_prdata;
wire                 a_pready;

wire                 b_psel;
wire                 b_penable;
wire                 b_pwrite;
wire [ADDR_WD-1 : 0] b_paddr;
wire [DATA_WD-1 : 0] b_pwdata;
wire [PROT_WD-1 : 0] b_pprot;
wire [STRB_WD-1 : 0] b_pstrb;
wire [DATA_WD-1 : 0] b_prdata;
wire                 b_pready;

reg  [DATA_WD-1 : 0] cnt;

initial begin
    $dumpfile("asyn_bridge.vcd");
    $dumpvars;
end

initial begin
    a_pclk = 1'b0;
    forever begin
        #3;
        a_pclk = ~a_pclk;
    end
end

initial begin
    b_pclk = 1'b0;
    forever begin
        #6;
        b_pclk = ~b_pclk;
    end
end

initial begin
    a_prst_n = 1'b1;
    b_prst_n = 1'b1;
    #1;
    a_prst_n = 1'b0;
    b_prst_n = 1'b0;
    #1;
    a_prst_n = 1'b1;
    b_prst_n = 1'b1;
    #2000;
    $finish;
end

always @(posedge a_pclk or negedge a_prst_n) begin
    if (!a_prst_n) begin
        a_psel <= 1'b0;
    end
    else if (!a_psel) begin
        a_psel <= $random;
    end
    else if (a_penable && a_pready) begin
        a_psel <= $random;
    end
end

always @(posedge a_pclk or negedge a_prst_n) begin
    if (!a_prst_n) begin
        a_penable <= 1'b0;
    end
    else if (a_psel) begin
        a_penable <= 1'b1;
    end
    else if (a_penable && a_pready) begin
        a_penable <= 1'b0;
    end
end

always @(posedge a_pclk or negedge a_prst_n) begin
    if (!a_prst_n) begin
        cnt <= 'b0;
    end
    else if (a_penable && a_pready) begin
        cnt <= cnt + 1'b1;
    end
end

always @(posedge a_pclk) begin
    a_pwrite <= ~cnt[5];
    a_paddr  <= cnt;
    a_pwdata <= cnt;
end

initial begin
    a_pprot = 3'b0;
    a_pstrb = 4'b1111;
end

asyn_bridge_top #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  asyn_bridge_top(
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
    .b_pready(b_pready)
);

slave_mux #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD),
    .STRB_WD(STRB_WD),
    .PROT_WD(PROT_WD)
)  slave_mux(
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
    .b_pready(b_pready)
);

endmodule
