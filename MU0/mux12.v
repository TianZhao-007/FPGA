module mux12(input wire [11:0] x, y,
input wire s,
output wire [11:0] z);

assign z = s ? y : x; // s=1,z<-y; s=0,z<-x
endmodule
