module alu16 (input wire [1:0] M, 
input wire [15:0] X, Y, 
output reg [15:0] Z);

parameter Acc =	2'b00;	//Pass Y through unchanged (to the accumulator)
parameter add =	2'b01;	//Add X and Y
parameter Inc =	2'b10;	//Increment X by 1
parameter sub =	2'b11;	//Subtract Y from X

always @(*) begin
	case(M)	
		add: Z = X + Y;
		sub: Z = X + ~Y + 1'b1; 
		Inc: Z = X + 1'b1;
		Acc: Z = Y;		   
		default:	Z = 1'b0;
	endcase
end
endmodule
