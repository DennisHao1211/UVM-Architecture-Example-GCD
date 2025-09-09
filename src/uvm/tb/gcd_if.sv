/*-----------------------------------------------------------------------------------------------
* File Name     :   interface_template.sv
* Author        :   Andrew Chen
* Date          :   8/9/2025
* 
* This file defines an interface template that is connected to the DUT and provides 
* methods for the driver and monitor to interact with the DUT signals.
-------------------------------------------------------------------------------------------------*/

interface gcd_if(input logic clk_i, input logic rst_i);
timeunit 1ns;
timeprecision 100ps;

    localparam TB_WIDTH = 8;

    // Define actual DUT signals here
    logic valid_i;
    logic [TB_WIDTH-1:0] a_i;
    logic [TB_WIDTH-1:0] b_i;
    logic [TB_WIDTH-1:0] gcd_o;
    logic valid_o;

    // Feel free to define tasks to drive/collect signals for the driver/monitor here
    // ...

endinterface : gcd_if