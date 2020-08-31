module mux16(input wire [15:0] x, y,
input wire s,
output wire [15:0] z);

assign z = s ? y : x; // s=1,z<-y; s=0,z<-x
endmodule
