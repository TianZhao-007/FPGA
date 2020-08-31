module reg12(input wire clk, 
output reg [11:0] q, 
input wire [11:0] data, 
input wire en, 
input wire reset);

always @(posedge clk) begin
	if (reset) q <= 11'h000;
	else if (en) q <= data;
	else q <= q;     //not strictly required
end
endmodule
