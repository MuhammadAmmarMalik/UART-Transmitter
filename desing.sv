



module uart_trans ( 
					input logic reset,
  					input logic clk,
  					input logic valid_in,
  					input logic [8-1:0] data_in,
  					input logic tx_start,
  					output logic tx_data
  											);
  
  //wire for connection
  wire [3-1:0] baud_counter_wire;
  wire [4-1:0] bit_counter_wire;
  wire load_shift_reg_wire;
  wire shift_en_wire;
  wire mux_sel_wire;
  wire clear_baud_counter_wire;
  wire clear_bit_counter_wire;
  
  //UART control logic instantiation
  uart_cl inst_uart_cl (.reset(reset), .clk(clk), .valid_in(valid_in), .tx_start(tx_start), .baud_counter(baud_counter_wire), .bit_counter(bit_counter_wire), .load_shift_reg(load_shift_reg_wire), .shift_en(shift_en_wire), .mux_sel(mux_sel_wire), .clear_baud_counter(clear_baud_counter_wire), .clear_bit_counter(clear_bit_counter_wire));
  
  
  //UART Datapath instantiation
  
  uart_dp inst_uart_dp (.clk(clk), .reset(reset), .data_in(data_in), .load_shift_reg(load_shift_reg_wire), .shift_en(shift_en_wire), .mux_sel(mux_sel_wire), .clear_baud_counter(clear_baud_counter_wire), .clear_bit_counter(clear_bit_counter_wire), .baud_counter(baud_counter_wire), .bit_counter(bit_counter_wire), .tx_data(tx_data) );
  
  
endmodule


`include "uart_cl.sv"  //including Control logic of UART
`include "uart_dp.sv"