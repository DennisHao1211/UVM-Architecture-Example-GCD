/*-----------------------------------------------------------------------------------------------
* File Name     :   agent_template.sv
* Author        :   Andrew Chen
* Date          :   8/9/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Instantiate your driver, monitor, and sequencer based on is_active
*   4. Connect your sequencer to your driver based on is_active
-------------------------------------------------------------------------------------------------*/

class gcd_agent extends uvm_agent;

    virtual function void build_phase(uvm_phase phase);
        
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        
    endfunction : connect_phase

endclass : gcd_agent