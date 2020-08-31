module CU_FSM (input wire [3:0] opcode,
input wire sysclk, ext_reset, ACCmsb, ACCor,
output reg Asel, Xsel, Ysel, PCce, IRce, ACCce, MemRW, reset,
output reg [1:0] M);

//state description
parameter INIT=2'b00;
parameter FETCH=2'b01;
parameter EXEC=2'b11;

//opcode description
parameter LDA=4'h0;
parameter STO=4'h1;
parameter ADD=4'h2;
parameter SUB=4'h3;
parameter JMP=4'h4;
parameter JGE=4'h5;
parameter JNE=4'h6;
parameter STP=4'h7;

reg [1:0] state, Snext;

always @(posedge sysclk) begin // state memory
	if(ext_reset) state<=INIT;
	else state<=Snext;
end

always @(*) begin //next state logic
	case(state)	
		INIT: Snext=FETCH;
		FETCH: Snext=EXEC;
		EXEC: if (opcode<4'h4) Snext=FETCH;
			  else if ((opcode==JGE && ACCmsb) | (opcode==JNE && (~ACCor))) Snext=FETCH;
			  else Snext=EXEC;
		default: Snext=INIT; //should not occur
	endcase
end

always @(*) begin //output logic
	case(state)	
		INIT: begin 
				Asel=1'b0; 
				Xsel=1'b0; 
				Ysel=1'b0; 
				PCce=1'b0; 
				IRce=1'b0; 
				ACCce=1'b0; 
				MemRW=1'b0; 
				M=2'b00; 
				reset=1'b1; 
			  end
		FETCH: begin 
				Asel=1'b0; 
				Xsel=1'b1; 
				Ysel=1'b0; 
				PCce=1'b1; 
				IRce=1'b1; 
				ACCce=1'b0; 
				MemRW=1'b0; 
				M=2'b10; 
				reset=1'b0; 
			   end
		EXEC: begin 
			   case(opcode)
				LDA: begin 
						Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b1; 
						PCce=1'b0; 
						IRce=1'b0; 
						ACCce=1'b1; 
						MemRW=1'b0; 
						M=2'b00; 
						reset=1'b0; 
					  end
				ADD: begin 
						Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b0; 
						PCce=1'b0; 
						IRce=1'b0; 
						ACCce=1'b1; 
						MemRW=1'b0; 
						M=2'b01; 
						reset=1'b0; 
					  end
				SUB:  begin 
						Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b0; 
						PCce=1'b0; 
						IRce=1'b0; 
						ACCce=1'b1; 
						MemRW=1'b0; 
						M=2'b11; 
						reset=1'b0; 
					  end
				STO:  begin 
						Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b0; 
						PCce=1'b0; 
						IRce=1'b0; 
						ACCce=1'b0; 
						MemRW=1'b1; 
						M=2'b00; 
						reset=1'b0; 
					  end
				JMP:  begin 
						Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b1; 
						PCce=1'b1; 
						IRce=1'b1; 
						ACCce=1'b0; 
						MemRW=1'b0; 
						M=2'b10; 
						reset=1'b0; 
					  end
				JGE:  if (ACCmsb) begin 
						Asel=1'b0; 
						Xsel=1'b1; 
						Ysel=1'b0; 
						PCce=1'b0	; 
						IRce=1'b0; 
						ACCce=1'b0; 
						MemRW=1'b0; 
						M=2'b10; 
						reset=1'b0; end 
					   else begin
					    Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b1; 
						PCce=1'b1; 
						IRce=1'b1; 
						ACCce=1'b0; 
						MemRW=1'b0; 
						M=2'b10; 
						reset=1'b0; end 
				JNE: if (~ACCor) begin  //if ACCor is 0 then the instruction should not execute
						Asel=1'b0; 
						Xsel=1'b1; 
						Ysel=1'b0; 
						PCce=1'b0; 
						IRce=1'b0; 
						ACCce=1'b0; 
						MemRW=1'b0; 
						M=2'b10; 
						reset=1'b0; end 
					   else begin
					    Asel=1'b1; 
						Xsel=1'b0; 
						Ysel=1'b1; 
						PCce=1'b1; 
						IRce=1'b1; 
						ACCce=1'b0; 
						MemRW=1'b0; 
						M=2'b10; 
						reset=1'b0; end 
				STP: begin 
							Asel=1'b0; 
							Xsel=1'b1; 
							Ysel=1'b0; 
							PCce=1'b0; 
							IRce=1'b0; 
							ACCce=1'b0; 
							MemRW=1'b0; 
							M=2'b00; 
							reset=1'b0; 
						end
				default: begin 
							Asel=1'b0; 
							Xsel=1'b0; 
							Ysel=1'b0; 
							PCce=1'b0; 
							IRce=1'b0; 
							ACCce=1'b0; 
							MemRW=1'b0; 
							M=2'b00; 
							reset=1'b1; 
						end
			endcase end
		default: begin 
					Asel=1'b0; 
					Xsel=1'b0; 
					Ysel=1'b0; 
					PCce=1'b0; 
					IRce=1'b0; 
					ACCce=1'b0; 
					MemRW=1'b0; 
					M=2'b00; 
					reset=1'b1; 
				 end
	endcase
end

endmodule
