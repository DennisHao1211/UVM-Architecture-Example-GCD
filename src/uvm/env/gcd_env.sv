/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_env.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Instantiate the agent and scoreboard
*   4. Connect your monitor analysis port to the scoreboard analysis import
-------------------------------------------------------------------------------------------------*/

class gcd_env extends uvm_env;

    function void build_phase(uvm_phase phase);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        
    endfunction : connect_phase

endclass : gcd_env