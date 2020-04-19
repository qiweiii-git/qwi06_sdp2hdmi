//*****************************************************************************
// led_indicator.v
// 
// Qiwei.Wu
// May 1, 2018
//
// This module is the module of led indicator.
// Revision 
// 0.01 - File Created
// 1.0  - Release at May 5, 2018
//*****************************************************************************

module led_indicator	
#(
   parameter SET_TIME_1S = 50_000_000 ,
   parameter LED_NUM     = 1
)								
(
	input                      clk     ,
   input                      rst     ,
	output reg [LED_NUM-1:0]   led
);

//*****************************************************************************
// Signals
//*****************************************************************************					
reg	[31:0]	time_cnt;					

//*****************************************************************************
// Processes
//*****************************************************************************
always @(posedge clk, posedge rst)
begin
   if(rst)
      time_cnt <= 32'h0;
   else if(time_cnt == SET_TIME_1S - 1)
      time_cnt <= 32'h0;
   else
      time_cnt <= time_cnt + 32'h1;
end

always @(posedge clk, posedge rst)
begin
   if(rst)									
      led <= {LED_NUM{1'b0}};			
   else if (time_cnt == SET_TIME_1S - 1)
      led <= ~led;		
end

endmodule

