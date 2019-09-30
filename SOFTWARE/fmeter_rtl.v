`timescale 1ns / 1ps

module fmeter(
	CLK100MHz,
	FREQIN,
	TXD,
	LED1,
	LED2
);

input	CLK100MHz;
input   FREQIN;
output  TXD;
output	LED1;
output	LED2;

reg [1:0]	r_fin;
reg		r_LED1;
reg		r_LED2;
reg		r_txd;

reg	[11:0]	presc_uart;
reg	[27:0]	prescaler;
reg	[3:0]	frequency [0:7];
reg 	[100:0] bitresult;

parameter	PRESCR = 99999999;
parameter 	BAUDRATE = 1735; //57600 bps


assign LED1 = r_LED1;
assign LED2 = r_txd;
assign TXD = r_txd;


always @ (posedge CLK100MHz) begin 
//Time base 1 second
	if (prescaler == PRESCR) begin
		prescaler <= 0;
// copy bcd counter to fifo shift register in ASCII format with \r\n on the end
		bitresult[0] <= 0;
		bitresult[4:1] <= frequency[7];
		bitresult[8:5] <= 3;
		
		bitresult[10] <= 0;
		bitresult[14:11] <= frequency[6];
		bitresult[18:15] <= 3;
		
		bitresult[20] <= 0;
		bitresult[24:21] <= frequency[5];
		bitresult[28:25] <= 3;
		
		bitresult[30] <= 0;
		bitresult[34:31] <= frequency[4];
		bitresult[38:35] <= 3;
		
		bitresult[40] <= 0;
		bitresult[44:41] <= frequency[3];
		bitresult[48:45] <= 3;
						
		bitresult[50] <= 0;
		bitresult[54:51] <= frequency[2];
		bitresult[58:55] <= 3;

		bitresult[60] <= 0;
		bitresult[64:61] <= frequency[1];
		bitresult[68:65] <= 3;
			
		bitresult[70] <= 0;
		bitresult[74:71] <= frequency[0];
		bitresult[78:75] <= 3;
			
		bitresult[80] <= 0;
		bitresult[84:81] <= 4'b1101;
		bitresult[88:85] <= 0;
						
			
		bitresult[90] <= 0;
		bitresult[94:91] <= 4'b1010;
		bitresult[98:95] <= 0;	
			
		frequency[0] <= 0;
		frequency[1] <= 0;
		frequency[2] <= 0;
		frequency[3] <= 0;
		frequency[4] <= 0;
		frequency[5] <= 0;
		frequency[6] <= 0;
		frequency[7] <= 0;
		r_LED1 <= !r_LED1;		
	end else prescaler <= prescaler + 1;
		
		

		
// UART fifo shift register		

	if (presc_uart == BAUDRATE) begin
		presc_uart <= 0;
		r_txd <= bitresult[0];
		bitresult <= bitresult >> 1;
		bitresult[100] <= 1;
		end else presc_uart <= presc_uart + 1;
		
// Check for negedge on FREQIN pin		
		r_fin <= r_fin >> 1;
		r_fin[1] <= FREQIN;
		
		if (r_fin == 2'b10) begin
		// Count in BCD format
		frequency[0] <= frequency[0] + 1;
		if (frequency[0] == 9) begin
			frequency[0] <= 0;
			frequency[1] <= frequency[1] + 1;
			if (frequency[1] == 9) begin
				frequency[1] <= 0;
				frequency[2] <= frequency[2] + 1;
				if (frequency[2] == 9) begin
					frequency[2] <= 0;
					frequency[3] <= frequency[3] + 1;
					if (frequency[3] == 9) begin
						frequency[3] <= 0;
						frequency[4] <= frequency[4] + 1;
						if (frequency[4] == 9) begin
							frequency[4] <= 0;
							frequency[5] <= frequency[5] + 1;
							if (frequency[5] == 9) begin
								frequency[5] <= 0;
								frequency[6] <= frequency[6] + 1;
								if (frequency[6] == 9) begin
								frequency[6] <= 0;
								frequency[7] <= frequency[7] + 1;
								end
							end
						end
					end
				end
			end
		end
	end
end
endmodule
