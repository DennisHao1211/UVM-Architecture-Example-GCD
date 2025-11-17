/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_sequencer.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
-------------------------------------------------------------------------------------------------*/

class gcd_sequencer extends uvm_sequencer #(gcd_seq_item);

    `uvm_component_utils(gcd_sequencer)

    // UVM Constructor
    function new(string name = "gcd_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : gcd_sequencer