module mu0top (input wire sysclk, 
input wire ext_reset);

wire [3:0] opcode;
wire ACCmsb, ACCor, Asel, Xsel, Ysel, PCce, IRce, ACCce, MemRW, reset;
wire [1:0] M;
wire [15:0] memRbus, memWbus, IRout, ACCout, ALUout, ALUinX;
wire [11:0] Addrbus, PCout;

assign ACCmsb=ACCout[15];
assign ACCor=(|ACCout);

mux12 a_mux(.x(PCout),.y(IRout[11:0]),.s(Asel),.z(Addrbus));
mux16 x_mux(.x(ACCout),.y({4'b0, PCout}),.s(Xsel),.z(memWbus));
mux16 y_mux(.x(memWbus),.y({4'b0, IRout[11:0]}),.s(Ysel),.z(ALUinX));

alu16 alu(.M(M), .X(ALUinX), .Y(memRbus), .Z(ALUout));

mem ram (.clk(sysclk), .reset(reset), .memRW(MemRW), .address(Addrbus), .writedata(memWbus), .readdata(memRbus));

reg16 IR(.clk(sysclk), .q(IRout), .data(memRbus), .en(IRce), .reset(reset));
reg12 PC(.clk(sysclk), .q(PCout), .data(ALUout[11:0]), .en(PCce), .reset(reset));
reg16 ACC(.clk(sysclk), .q(ACCout), .data(ALUout), .en(ACCce), .reset(reset));

CU_FSM cu(.opcode(IRout[15:12]), .sysclk(sysclk), .ext_reset(ext_reset), .ACCmsb(ACCmsb), .ACCor(ACCor),
.Asel(Asel), .Xsel(Xsel), .Ysel(Ysel), .PCce(PCce), .IRce(IRce), .ACCce(ACCce), .MemRW(MemRW), .reset(reset),
.M(M));

endmodule