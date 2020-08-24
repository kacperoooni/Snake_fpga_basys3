`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 23:42:23
// Design Name: 
// Module Name: rect_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rect_controller(
  //  output reg [15:0] rect_write_x, rect_write_y,
    output reg [15:0] rect_read_x, rect_read_y,
  //  output reg [3:0] rect_write_function,
    output reg [35:0] rect_write,
    input wire [3:0] rect_read,
    input wire clk
    );
   localparam 
      GRID_SIZE_X = 32,
      GRID_SIZE_Y = 24,
      RECT_SIZE_X = (1024/GRID_SIZE_X),
      RECT_SIZE_Y = (768/GRID_SIZE_Y),
      NULL = 4'b0000,
      SNAKE = 4'b0001,
      ROCK = 4'b0010,
      SNACK = 4'b0100;
   
   reg [31:0] i, i_nxt = 0; 
   reg [15:0] rect_write_x_nxt, rect_write_y_nxt;
   reg [15:0] rect_read_x_nxt, rect_read_y_nxt;
   reg [3:0] rect_write_function_nxt;
   reg [35:0] rect_write_nxt;
  //{rect_write_x,rect_write_y,rect_write_function} = rect_write;
   always@(*)
        begin
            
            if(i == 0)
                begin
                    rect_write_x_nxt = 1;
                    rect_write_y_nxt = 1; 
                    rect_write_function_nxt = SNAKE;
                    i_nxt = i + 1;
                end
            if(i == 1)
                 begin
                    rect_write_x_nxt = 2;
                    rect_write_y_nxt = 2; 
                    rect_write_function_nxt = ROCK; 
                    i_nxt = i + 1;
                 end
            if(i == 2)
                  begin
                  rect_write_x_nxt = 3;
                  rect_write_y_nxt = 3; 
                  rect_write_function_nxt = SNACK;  
                  end
             rect_write_nxt = {rect_write_x_nxt,rect_write_y_nxt,rect_write_function_nxt};            
        end     
   
   always@(posedge clk)
        begin
       //     rect_write_x <= rect_write_x_nxt;   
        //    rect_write_y <= rect_write_y_nxt;  
        //    rect_write_function <= rect_write_function_nxt;
            rect_write <= rect_write_nxt;
            i <= i_nxt;
        end     
    
        
    
    
   
endmodule
