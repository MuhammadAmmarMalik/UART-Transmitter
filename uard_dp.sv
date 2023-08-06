module uart_dp(
					input logic clk, reset,
  					input logic [8-1:0] data_in,
  					input logic load_shift_reg,
  					input logic shift_en,
  					input logic mux_sel,
  					input logic clear_baud_counter,
  					input logic clear_bit_counter,
  					output logic [3-1:0] baud_counter,
  					output logic [4-1:0] bit_counter,
  					output logic tx_data
													);
 //Shift register
  logic [10-1:0] shift_reg;
  
  //transmission bin
  //mux operation
  assign tx_data = mux_sel ? 1'b1 : shift_reg [0];
  
  //sequential logic
  always @(posedge clk) begin
    if (reset) begin
      baud_counter = 0;
      bit_counter = 0;   
   	  shift_reg = 0;
      
  	end
  
  	//baud_counter
    if(clear_baud_counter)
      	baud_counter = 0;
    else 
    	baud_counter = baud_counter + 1;
    
    //bit counter 
    if (clear_bit_counter)
      	bit_counter = 0;
    if (baud_counter == 5 ) 
      	bit_counter = bit_counter + 1;
  
  
  end//always
  
  
  //combinational logic
  always @ (*) begin
    //Loading of data in shift register
    if(load_shift_reg) begin
      shift_reg [8:1] = data_in;
      shift_reg [9] = 1;
      shift_reg [0] = 0;
    end// if block
    
    //mux selection logic
    
    
    //shift register operation
    /*if(shift_en) begin
      shift_reg [9] <= 0;
      shift_reg [8] <= shift_reg [9];
      shift_reg [7] <= shift_reg [8];
      shift_reg [6] <= shift_reg [7];
      shift_reg [5] <= shift_reg [5];
      shift_reg [4] <= shift_reg [5];
      shift_reg [3] <= shift_reg [4];
      shift_reg [2] <= shift_reg [3];
      shift_reg [1] <= shift_reg [2];
      shift_reg [0] <= shift_reg [1];
    end//if block
    */
    if(shift_en) begin
      
      shift_reg [0] = shift_reg [1];
      shift_reg [1] = shift_reg [2];
      shift_reg [2] = shift_reg [3];
      shift_reg [3] = shift_reg [4];
      shift_reg [4] = shift_reg [5];
      shift_reg [5] = shift_reg [6];
      shift_reg [6] = shift_reg [7];
      shift_reg [7] = shift_reg [8];
      shift_reg [8] = shift_reg [9];
      shift_reg [9] = 1;
    end
    
    
      	
  end//always block
  
endmodule