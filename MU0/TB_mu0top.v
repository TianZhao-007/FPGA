`timescale 1ns/1ps
module TB_mu0_ctrl;

reg clk; 
reg reset;
  
mu0top uut(.sysclk(clk), .ext_reset(reset));

initial begin
	clk=1'b0;
	forever  #1 clk=~clk;
end

initial begin
   $dumpfile("MU0.vcd");
   $dumpvars;
end

initial begin 
   reset=1'b1;
   #3 reset=0;
end

initial begin: stopat
   #120; $finish;
end

endmodule