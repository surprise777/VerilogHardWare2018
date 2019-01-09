module top(CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
    	input CLOCK_50, CLOCK2_50;
	input [3:0] KEY;
	input [9:0] SW;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1;
	 
	 // Local wires.
	wire read_ready, write_ready;
	reg read, write;
	wire [23:0] readdata_left, readdata_right;
	reg [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
    
    wire resetn;
    wire go;
    wire wren_key;
  
    assign go = ~KEY[1];
    assign resetn = KEY[0];
    assign wren_key = ~KEY[2];
	 
	 /////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	

	always @(*)
	begin
	if (reset)
		read <= 1'b0;
	write <= 1'b0;
	writedata_left <= 24'd0;
	writedata_right <= 24'd0;	
	if (write_ready)
		write <= 1'b1;
	if (write) begin
		writedata_left <= {soundOut, 23'd0};
		writedata_right <= {soundOut, 23'd0};
		end
	if (read_ready)
		read <= 1'b1;
	end
	wire soundOut;
	 
    CD cd(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .note_in(SW[3:0]),
        .address(SW[8:4]),
        .wren_key(wren_key),
        .play(SW[9]),
        .metronome(LEDR[0]),
        .sound(soundOut)
    );
	 
	 hex_display h0(SW[0], SW[1], SW[2], SW[3], HEX0);
	 hex_display h1(SW[4], SW[5], SW[6], SW[7], HEX1);
	 
	 /////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
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
    
endmodule

module hex_display(c0,c1,c2,c3,h);
    input c0, c1, c2, c3;
    output [6:0] h;
    
    assign h[0] = ~c3&~c2&~c1&c0|~c3&c2&~c1&~c0|c3&~c2&c1&c0|c3&c2&~c1&c0;
    assign h[1] = c3&c2&~c0|c3&c1&c0|~c3&c2&~c1&c0|c2&c1&~c0;
    assign h[2] = c3&c2&c1|c3&c2&~c0|~c3&~c2&c1&~c0;
    assign h[3] = ~c3&c2&~c1&~c0|~c2&~c1&c0|c2&c1&c0|c3&~c2&c1&~c0;
    assign h[4] = ~c3&c0|~c2&~c1&c0|~c3&c2&~c1;
    assign h[5] = ~c3&~c2&c1|~c3&c1&c0|~c3&~c2&c0|c3&c2&~c1&c0;
    assign h[6] = ~c3&~c2&~c1|c3&c2&~c1&~c0|~c3&c2&c1&c0;
endmodule

module CD(
    input clk,
    input resetn,
    input go,
    input [3:0] note_in,
    input [4:0] address,
    input wren_key,
    input play,
    output metronome,
    output sound
    );
    
    wire  dem_sel, loop_en;
    wire  mux_sel_a, mux_sel_b, mux_sel_c;

    control C0(
        .clk(clk),
        .resetn(resetn),
        .go(go),
        .dem_sel(dem_sel), 
        .loop_en(loop_en),
        .mux_sel_a(mux_sel_a), 
        .mux_sel_b(mux_sel_b), 
        .mux_sel_c(mux_sel_c)
    );

    datapath D0(
        .clk(clk), 
        .resetn(resetn), 
        .note_in(note_in), 
        .address(address), 
        .wren_key(wren_key), 
        .play(play),
        .dem_sel(dem_sel),
        .mux_sel_a(mux_sel_a), 
        .mux_sel_b(mux_sel_b), 
        .mux_sel_c(mux_sel_c),
	.loop_en(loop_en), 
        .metronome(metronome), 
        .sound(sound)
    );
endmodule

module control(
    input clk,
    input resetn,
    input go,

    output reg  dem_sel, loop_en,
    output reg  mux_sel_a, mux_sel_b, mux_sel_c
    );

    reg [2:0] current_state, next_state; 
    
    localparam  PLAY             = 3'd0,
                PLAY_WAIT        = 3'd1,
                LOAD_NOTE        = 3'd2,
                LOAD_NOTE_WAIT   = 3'd3,
                LOOP             = 3'd4,
                LOOP_WAIT        = 3'd5;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                PLAY:              next_state = go ? PLAY_WAIT : PLAY;
                PLAY_WAIT:         next_state = go ? PLAY_WAIT : LOAD_NOTE;
                LOAD_NOTE:         next_state = go ? LOAD_NOTE_WAIT : LOAD_NOTE;
                LOAD_NOTE_WAIT:    next_state = go ? LOAD_NOTE_WAIT : LOOP;   
                LOOP:              next_state = go ? LOOP_WAIT : LOOP;        
                LOOP_WAIT:         next_state = go ? LOOP_WAIT: PLAY;
            	default:           next_state = PLAY;
        	endcase
    end // state_table

   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        dem_sel   = 1'b0;
        loop_en   = 1'b0;
        mux_sel_a = 1'b0;
        mux_sel_b = 1'b0;
        mux_sel_c = 1'b0;

        case (current_state)
            PLAY: begin
                dem_sel   = 1'b0; // Load notes to the muxA
                mux_sel_a = 1'b0; // Load notes from the muxA
                mux_sel_c = 1'b0;                
                // Play Switch on or off decide by user
                end
            LOAD_NOTE: begin
                loop_en   = 1'b0; // Loop is not enabled
                dem_sel   = 1'b1; // Load notes to the RAM               
                mux_sel_a = 1'b1; // Load notes from the RAM
                mux_sel_b = 1'b0; // Address from SW-related address
                mux_sel_c = 1'b0;// Load Address from SW-related address and load notes directly to muxA
                end
            LOOP: begin
                loop_en   = 1'b1; 
                mux_sel_a = 1'b1; // Load notes from the RAM
                mux_sel_b = 1'b1; // Address from address selector
                mux_sel_c = 1'b1;// Load Address from address selector and load notes to RAM
                end
        // default:    
        // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= PLAY;
        else
            current_state <= next_state;
    end // state_FFS
endmodule


module datapath(clk, resetn, note_in, address, wren_key, dem_sel,
				mux_sel_a, mux_sel_b, mux_sel_c, play, loop_en, metronome, sound);
	input clk, resetn;
	input [3:0] note_in;
	input [4:0] address;
	input wren_key;
	input dem_sel, mux_sel_a, mux_sel_b, mux_sel_c, play, loop_en;
	output metronome;
	output sound;
	
	wire [3:0] note_to_gen;
	wire [3:0] note_to_ram;
	
	wire [4:0] auto_ad;
	
	wire wren_wire;
	
	wire [4:0] ram_address;
	
	wire [3:0] ram_to_gen;
	
	wire [3:0] note_gen_in;
	
	demux1to2 demux(
		.in(note_in),
		.sel(dem_sel),
		.out_l(note_to_gen),
		.out_r(note_to_ram));
	
	addressSelector as(
		.clk(clk),
		.enable(loop_en),
		.resetn(resetn),
		.beat(metronome),
		.num(auto_ad));
	
	w5mux2to1 mux_ads(
		.a(address),
		.b(auto_ad),
		.sel(mux_sel_b),
		.out(ram_address));
	
	w1mux2to1 mux_wren(
		.a(wren_key),
		.b(1'b0),
		.sel(mux_sel_c),
		.out(wren_wire));
	
	ram32x4 ram(
		.address(ram_address),
		.clock(clk),
		.data(note_to_ram),
		.wren(wren_wire),
		.q(ram_to_gen));
	
	w4mux2to1 mux_gen(
		.a(note_to_gen),
		.b(ram_to_gen),
		.sel(mux_sel_a),
		.out(note_gen_in));
	
	noteGenerator ng(clk, play, resetn, note_gen_in, sound);
	
endmodule
// ----------------------------------------------------------
// --------------- AUTOMATIC ADDRESS SELECTOR -----------------
// -----------------------------------------------------------
// Beat: controls the LED
// 		- the light flashes at 120bpm, on every quarter beat
// 		- the result is that the light alternates between on and off on every eighth note
//		- this way the user can tell what note they're on when they switch off enable
// Num: ram address
// 		- increases on every eighth note
// 		- the result is that every cell in the ram corresponds to one eighth note

module addressSelector(clk, enable, resetn, beat, num);
	input clk, enable, resetn;
	output beat;
	output [4:0] num;
	
	wire rate;
	rateDivider r(clk, enable, resetn, rate);
	
	lightChanger lc(clk, rate, resetn, beat);
	addressCounter ad(clk, rate, resetn, num);
endmodule

module rateDivider(clk, enable, resetn, out);
	input clk, enable, resetn;
	output reg out;
//	localparam d = 25'd20; // for key (use and simulation)
//	localparam d = 25'd3; // for simulation
 	localparam d = 25'd12500000; // for use (with CLOCK_50)
	
	reg [24:0] count;
	
	always @(posedge clk)
	begin
		out <= 1'b0;
		if (!resetn)
			begin
			out <= 1'b0;
			count <= d - 1'b1;
			end
		else if (enable)
		begin
			if (count == 25'd0)
				begin
				out <= 1'b1;
				count <= d - 1'b1;
				end
			else
				count <= count - 1'b1;
		end 
	end
endmodule

module lightChanger(clk, enable, resetn, out);
	input clk, enable, resetn;
	output reg out;
	
	always @(posedge clk)
	begin
		if (!resetn)
			out <= 1'b0;
		else if (enable)
			out <= ~out;
	end
endmodule

module addressCounter(clk, enable, resetn, out);
	input clk, enable, resetn;
	output reg [4:0] out;
	
	reg flag; // 1 if the count is starting from reset
	
	always @(posedge clk)
	begin
		if (!resetn)
			begin
			out <= 5'b0;
			flag <= 1'b1;
			end
		else if (enable)
			begin
			if (flag)
				begin
				out <= 5'b0;
				flag <= 1'b0;
				end
			else if (out == 5'd15)
				out <= 5'd0;
			else	
				out <= out + 1'b1;
			end
	end
endmodule

// -----------------------------------------------------

// -------------------------------------------------------
// ------------- RAM32X4 ---------------------------------
// -------------------------------------------------------

module ram32x4 (
	address,
	clock,
	data,
	wren,
	q);

	input	[4:0]  address;
	input	  clock;
	input	[3:0]  data;
	input	  wren;
	output	[3:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  clock;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [3:0] sub_wire0;
	wire [3:0] q = sub_wire0[3:0];

	altsyncram	altsyncram_component (
				.address_a (address),
				.clock0 (clock),
				.data_a (data),
				.wren_a (wren),
				.q_a (sub_wire0),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.address_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_b (1'b0));
	defparam
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.intended_device_family = "Cyclone V",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 32,
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = 5,
		altsyncram_component.width_a = 4,
		altsyncram_component.width_byteena_a = 1;


endmodule
// -------------------------------------------------------

// -------------------------------------------------------
// -------------NOTE GENERATOR--------------------------------
// -------------------------------------------------------

module noteGenerator(clk, enable, resetn, note, sound);
	input clk, enable, resetn;
	input [3:0] note;
	output sound;
	
	wire [16:0] frequency;
	noteLUT nl(note, frequency);
	
	soundGenerator sg(clk, resetn, enable, frequency, sound);
endmodule

module soundGenerator(clk, resetn, enable, freq, sound);
	input clk, resetn, enable;
	input [16:0] freq;
	output reg sound;
	
	reg [16:0] count;
    
    always @(posedge clk)
		begin
		if (!resetn)
    		count <= 17'd0;
    	else if (enable)
			begin	
			if(count == 17'd0)
				count <= freq;
			else
				count <= count - 1'b1;
			end
		end
	 
    always @(posedge clk) 
		begin
		if (!resetn)
			sound <= 1'b0;
		else if (enable)
			begin
			if(count == 17'd0)
				sound <= ~sound;
			end
		end
endmodule

module noteLUT(note, frequency);
    input [3:0] note;
    output reg [16:0] frequency;
    
    always @(*)
        case(note)
         0: frequency = 17'd95420 - 1'b1; // C4
  	    1: frequency = 17'd85034 - 1'b1; // D4
  	    2: frequency = 17'd71633 - 1'b1; // F4
  	    3: frequency = 17'd63776 - 1'b1; // G4
  	    4: frequency = 17'd56818 - 1'b1; // A4
  	    5: frequency = 17'd47801 - 1'b1; // C5
  	    6: frequency = 17'd42589 - 1'b1; // D5
         7: frequency =17'd35817 - 1'b1; // F5
         8: frequency = 17'd31888 - 1'b1; // G5
  	    9: frequency = 17'd28409 - 1'b1; // A5
//		0: frequency = 16'd3 - 1'b1; // C4
// 	    1: frequency = 16'd4 - 1'b1; // D4
// 	    2: frequency = 16'd5 - 1'b1; // F4
// 	    3: frequency = 16'd6 - 1'b1; // G4
// 	    4: frequency = 16'd7 - 1'b1; // A4
// 	    5: frequency = 16'd8 - 1'b1; // C5
// 	    6: frequency = 16'd9 - 1'b1; // D5
//        7: frequency = 16'd10 - 1'b1; // F5
//	    8: frequency = 16'd11 - 1'b1; // G5
// 	    9: frequency = 16'd12 - 1'b1; // A5
 	    default: frequency = 17'd0;
        endcase
endmodule
// -------------------------------------------------------

// -------------------------------------------------------
// -------------(DE)MUXES--------------------------------
// -------------------------------------------------------

module demux1to2(in, sel, out_l, out_r);
	input [3:0] in;
	input sel;
	output reg [3:0] out_l;
	output reg [3:0] out_r;
	
	always @(*)
	case(sel)
		0: 	begin
			out_l = in;
			out_r = 4'd0;
			end
		1:	begin
			out_l = 4'd0;
			out_r = in;
			end
	endcase
	
endmodule

module w5mux2to1(a, b, sel, out);
    input [4:0] a; //selected when sel is 0
    input [4:0] b; //selected when sel is 1
    input sel; //select signal
    output [4:0] out; //output
  
    assign out = sel ? b : a;

endmodule

module w4mux2to1(a, b, sel, out);
    input [3:0] a; //selected when sel is 0
    input [3:0] b; //selected when sel is 1
    input sel; //select signal
    output [3:0] out; //output
  
    assign out = sel ? b : a;

endmodule

module w1mux2to1(a, b, sel, out);
	input a, b, sel;
	output out;
	
	assign out = sel ? b : a;
endmodule
// -------------------------------------------------------