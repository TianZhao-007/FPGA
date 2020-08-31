module reg16(input wire clk, 
output reg [15:0] q, 
input wire [15:0] data, 
input wire en, 
input wire reset);

always @(posedge clk) begin
if (reset) q <= 16'h0000;
else if (en) q <= data;
else q <= q;     //not strictly required
end
endmodule
