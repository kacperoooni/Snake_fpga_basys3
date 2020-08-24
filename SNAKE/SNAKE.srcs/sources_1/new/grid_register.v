`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 20:28:12
// Design Name: 
// Module Name: grid_register
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


module grid_register(
    input wire clk, 
    input wire rst,
    input wire [15:0] vcount,
    input wire [15:0] hcount,
    input wire [31:0] rect_read_in, //Xpos,Ypox
    input wire [35:0] rect_write, //Xpos,Ypos,Function
    output reg [3:0] rect_read_out, //Function
    
    input wire [11:0] rgb_in,
    output reg [11:0] rgb_out
    );
    
    
    localparam 
    GRID_SIZE_X = 32,
    GRID_SIZE_Y = 24,
    RECT_SIZE_X = 32,
    RECT_SIZE_Y = 32,
    NULL = 4'b0000,
    SNAKE = 4'b0001,
    ROCK = 4'b0010,
    SNACK = 4'b0100;

    
    reg [3:0] grid_register [768:1];
    reg [3:0] grid_register_nxt [768:1];
    // null - null
    // bit 0 - snake
    // bit 1 - rock
    // bit 2 - snack
    wire [15:0] rect_write_x, rect_write_y, rect_read_x, rect_read_y;
    wire [3:0] rect_write_function;
    
    assign {rect_write_x,rect_write_y,rect_write_function} = rect_write;
    assign {rect_read_x, rect_read_y} = rect_read_in;
    
 
  reg [15:0] current_painted_rect;
  reg [11:0] rgb_nxt;

 
    localparam
        INIT = 0,
		INIT_2 = 0, //one is too slow 
        READnWRITE = 2,
        RESET = 3;
    reg [3:0] state = INIT_1;
    reg [3:0] state_nxt;
    reg [15:0] register_reseter_comb, register_reseter_seq;
    
    
    
    
    always@(*)
        begin
        rgb_nxt = rgb_in;
        state_nxt = state;
        case(state)
            INIT:
              begin
                for(register_reseter_comb = 1; register_reseter_comb <= 660; register_reseter_comb = register_reseter_comb + 1)
                    begin
                    grid_register_nxt[register_reseter_comb] = NULL;
                    end 
               state_nxt = READnWRITE;
              end			  
            READnWRITE:
              begin
                if (rect_write_y >= 0 && rect_write_y <= 32 && rect_write_x >= 0 && rect_write_x <= 32)
                    begin
                        grid_register_nxt[rect_write_y*GRID_SIZE_X+rect_write_x] = rect_write_function;
                    end
                else begin end 
                if (rect_read_y >= 0 && rect_read_y <= 32 && rect_read_x >= 0 && rect_read_x <= 32)
                    begin
                        rect_read_out = grid_register[rect_read_y*GRID_SIZE_X+rect_read_x];
                    end 
				else begin end
                if(rst)
                    begin
                        state_nxt = RESET;
                    end
                else
                    begin
                        state_nxt = READnWRITE;
                    end                    
               end
            RESET:
                begin        
                    state_nxt = INIT;
                end
        endcase        

            if(vcount >= 0 && vcount <= 768 && hcount >= 0 && hcount <= 1024)
                    begin
                        current_painted_rect = vcount/RECT_SIZE_Y*RECT_SIZE_X+hcount/RECT_SIZE_X+1;
                        case(grid_register[current_painted_rect])
                                   NULL:
                                       begin
                                       rgb_nxt = rgb_in;
                                       end
                                   SNAKE:
                                       begin
                                       rgb_nxt = 12'h0_f_0;
                                       end
                                   ROCK:
                                       begin
                                       rgb_nxt = 12'hf_f_f;
                                       end
                                   SNACK:
                                       begin
                                       rgb_nxt = 12'hf_0_0;
                                       end 
                                   default:
                                       begin  
                                       rgb_nxt = rgb_in;
                                       end           
                               endcase
                    end
            end    
    
    always@(posedge clk)
        begin
            state <= state_nxt;
            rgb_out <= rgb_nxt;
            grid_register[rect_write_y*GRID_SIZE_X+rect_write_x] <= grid_register_nxt[rect_write_y*GRID_SIZE_X+rect_write_x];
            if(rst == 1)
                for(register_reseter_seq = 1; register_reseter_seq <= 768; register_reseter_seq = register_reseter_seq + 1)
                     begin
                          grid_register[register_reseter_seq] = NULL;
                     end 
         end   
            
    
        
endmodule
