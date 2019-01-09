module music(KEY, SW, CLOCK_50, LEDR,AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	
	
	input [2:0] KEY;
	input [0:0] SW;
	input CLOCK_50;

	output [7:0] LEDR;
	// Audio CODEC
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	wire sound;
	
	wire [2:0] note;
	
	assign note = KEY[2:0];
	
	wire clock2;
	wire CLOCK_50;
	
	wire read_ready, write_ready;
	reg read, write;
	wire [23:0] readdata_left, readdata_right;
	reg [23:0] writedata_left, writedata_right;

	always @(*)
	begin
		if (!SW[0]) begin
			read <= 1'b0;
			write <= 1'b0;
			writedata_left <= 24'd0;
			writedata_right <= 24'd0;end
		else if (SW[0]) begin
		   write <= 1'b1;
			writedata_left <= {sound, 23'd0};
			writedata_right <= {sound, 23'd0};
			read <= 1'b1;
			end
	end
	
	assign reset = ~SW[0];
	
	clock_generator my_clock_gen(
		// inputs
		CLOCK_50,
		reset,

		// outputs
		AUD_XCK
	);


	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
	
	note n(.clk(clock2),
				.note(note),
				.note_clock(sound),
				.note_leds(LEDR));
				
				
	divider d(.clock(CLOCK_50), 
					.reset(SW[0]),
					.clock2(clock2));
					

endmodule



module divider(clock,reset,clock2);
	input clock;
	input reset;
	output reg clock2;
	reg [2:0] count;

	always @(posedge clock) begin
		if (!reset) begin
			count <= 3'd4;
			clock2 <= 0;
		end
		else begin
			if (count==3'd0) begin 
				count <= 3'd4;
				clock2 <= ~clock2; end
			else count <= count-3'd1;
		end
	end
	
endmodule

	

module note(
		 input wire clk,       //source clock 5Mhz 
		 input wire [2:0] note, //ID of note 
		 
									//output freq grid
									//basic freq is note A = 440Hz
									//every next note differs by 2^(-1/12)
									//C     523,2511306 Hz
									//D     587,3295358 Hz
									//E     659,2551138 Hz
		 output reg note_clock,      //generated note clock /
		 output reg [7:0]note_leds   //blink LEDs /
		);

		//divide coeff /
		reg [13:0]factor;
		reg eocnt; 
		reg [13:0]cnt;
		

		//select divide coefficient according to current note being played

		always @(*) 
		begin
			 case(note)
				  3'b011:  begin factor = 9560; note_leds = 8'b00000001; end   //C
				  3'b101:  begin factor = 8518; note_leds = 8'b00000010; end   //D
				  3'b110:  begin factor = 7587; note_leds = 8'b00000100; end   //E
			 default: begin factor = 1;   note_leds = 8'b00000000; end   //nothing 
			 endcase
		end
		
		always @(posedge clk)
			 eocnt <= (cnt == factor);
			 

		always @(posedge clk or posedge eocnt)
		begin 
			 if(eocnt)
				  cnt <= 0;
			 else
				  cnt <= cnt + 1'b1;
		end

		//output sound frequency 
		always @(posedge eocnt)
			 note_clock <= note_clock ^ 1'b1;

endmodule
 