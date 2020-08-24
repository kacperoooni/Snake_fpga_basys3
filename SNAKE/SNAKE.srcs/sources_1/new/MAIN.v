`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 15:55:41
// Design Name: 
// Module Name: MAIN
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


module MAIN(
    input wire clk,
    input wire rst,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire vsync,
    output wire hsync
    );

    wire clk_100Mhz, clk_65Mhz;
    
    
    clk_wiz_0 clk_wiz_0 (
      .clk_in1(clk),
      .clk_100Mhz(clk_100Mhz),
      .clk_65Mhz(clk_65Mhz)
    //  .reset(rst)
      );

      wire [15:0] vcount_wire, hcount_wire;
      wire [11:0] rgb_out_wire;
      wire vblnk_wire, hblnk_wire, hsync_wire, vsync_wire;
      
       
    

    VGA_timing_controller VGA_timing_controller (
      .vcount(vcount_wire),
      .hcount(hcount_wire),
      .rst(rst),
      .hsync(hsync_wire),
      .vsync(vsync_wire),
      .vblnk(vblnk_wire),
      .hblnk(hblnk_wire),
      .clk(clk_65Mhz)
     );
     wire [15:0] vcount_wire_RGB_to_grid, hcount_wire_RGB_to_grid;
     wire [11:0] rgb_RGB_to_grid;
    VGA_rgb_controller VGA_rgb_controller (
       .clk(clk_65Mhz),
       .hcount_in(hcount_wire),
       .hsync_in(hsync_wire),
       .vsync_in(vsync_wire),
       .hsync_out(hsync),
       .vsync_out(vsync),
       .hblnk_in(hblnk_wire),
       .vcount_in(vcount_wire),
       .vblnk_in(vblnk_wire),
       .rgb_out(rgb_RGB_to_grid),
       .vcount_out(vcount_wire_RGB_to_grid),
       .hcount_out(hcount_wire_RGB_to_grid)     
      );
    
    wire [15:0] rect_write_x,rect_write_y,rect_read_x,rect_read_y;
    wire [3:0] rect_write_function,rect_read;
    wire [35:0] rect_write_wire;
    grid_register grid_register (
       .clk(clk_65Mhz),
       .rgb_out({r,g,b}),
       .vcount(vcount_wire_RGB_to_grid),
       .hcount(hcount_wire_RGB_to_grid),
       .rgb_in(rgb_RGB_to_grid),
       .rst(rst),
    //   .rect_write_x(rect_write_x),
     //  .rect_write_y(rect_write_y),
       .rect_read_x(rect_read_x),
       .rect_read_y(rect_read_y),
    //   .rect_write_function(rect_write_function),
        .rect_write(rect_write_wire),
       .rect_read(rect_read)
       );
    
    rect_controller rect_controller (
       .clk(clk_65Mhz),
    //   .rect_write_x(rect_write_x),
     //  .rect_write_y(rect_write_y),
     //  .rect_read_x(rect_read_x),
    //   .rect_read_y(rect_read_y),
    //   .rect_write_function(rect_write_function),
       .rect_write(rect_write_wire),
       .rect_read(rect_read)
       );            
endmodule
