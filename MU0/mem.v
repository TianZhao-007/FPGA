module mem (input wire clk, 
input wire reset,
input wire memRW,             //0 means read, 1 means write
input wire [11:0] address, 
input wire [15:0] writedata, 
output reg [15:0] readdata);

//initial $readmemh("prog.lst", mem);

reg [15:0] mem [12'h0:12'hFFF]; //note this 2D array syntax (for RAM)

always @(negedge clk)     //note negedge, we will discuss this later
begin
	if(reset)
		$readmemh("prog.lst", mem);
	else 
		if (memRW) begin 
		mem[address] <= writedata;
		readdata <= 16'd0;
	end
	else readdata <= mem[address];
end
endmodule
