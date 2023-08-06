
// Code your design here
module uart_cl (
					input logic reset,
  					input logic clk,
  					input logic valid_in,
  					input logic tx_start,
  					input logic [3-1:0] baud_counter,
  					input logic [4-1:0] bit_counter,
  					output logic load_shift_reg,
  					output logic shift_en,
  					output logic mux_sel,
  					output logic clear_baud_counter,
  					output logic clear_bit_counter
				);
  
  //define states
  logic [2-1:0] PS, NS;
  parameter Ideal = 0;
  parameter Load_shift_reg =1;
  parameter transmission = 2;
 	
  
  
  //sequential logic
  always @ (posedge clk) begin
    if (reset) begin
      PS <= #1 0;
      mux_sel <= #1 1;
    end
    else begin
      PS <= #1 NS;
    end
  end
  //tx_start
  always @ (*) begin
    if(tx_start) begin
      clear_baud_counter = #1 1;
      clear_bit_counter = #1 1;
    end
    
  end
  
  //combinational block
  always @ (*) begin
    case (PS)
      Ideal: if (valid_in) begin
        		load_shift_reg = 1 ;
			    shift_en = 0;
  				clear_baud_counter = 0;
  				clear_bit_counter = 0 ;
        		mux_sel = 1;
        		NS = Load_shift_reg;
      		 end
      		 else begin
                load_shift_reg = 0 ;
			    shift_en = 0;
  				clear_baud_counter = 0;
  				clear_bit_counter = 0 ;
                mux_sel = 1;
        		NS = Ideal;
             end
      Load_shift_reg : if(tx_start) begin
        					load_shift_reg = 0 ;
						    shift_en = 0;
  							clear_baud_counter = 0;
  							clear_bit_counter = 0 ;
        					mux_sel = 0;
        					NS = transmission;
      					end
      					else begin
                          	load_shift_reg = 0 ;
						    shift_en = 0;
  							clear_baud_counter = 0;
  							clear_bit_counter = 0 ;
                          	mux_sel = 1;
        					NS = Load_shift_reg;	
                        end
      transmission: if (!(baud_counter==5) &&  !(bit_counter == 10)) begin
        					load_shift_reg = 0 ;
						    shift_en = 0;
  							clear_baud_counter = 0;
  							clear_bit_counter = 0 ;
                          	mux_sel = 0;
        					NS = transmission;
      						end
        			else if ((baud_counter==5) &&  !(bit_counter == 10)) begin
                    		load_shift_reg = 0 ;
						    shift_en = 1;
  							clear_baud_counter = 1;
  							clear_bit_counter = 0 ;
                          	mux_sel = 0;
        					NS = transmission;        	  
        			end
      				else if (baud_counter==5 &&  bit_counter == 10) begin
                    		load_shift_reg = 0 ;
						    shift_en = 0;
  							clear_baud_counter = 1;
  							clear_bit_counter = 1 ;
                          	mux_sel = 1;
        					NS = Ideal;        	  
        			end
      default: 
							NS = 0;	        
        
        
    endcase
    
    
  end 
  
endmodule