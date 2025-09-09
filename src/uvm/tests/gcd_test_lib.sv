/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_test_lib.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
* Tasks to complete here:
*   1. Write more tests extended from the provided base test (gcd_base_test.svh)
*      to create different tests that run your different sequences.
-------------------------------------------------------------------------------------------------*/

// Example test that runs the simple example sequence
class simple_gcd_test extends base_gcd_test;

    // UVM Component Macro
    `uvm_component_utils(simple_gcd_test)

    // UVM Constructor
    function new(string name = "simple_gcd_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        // Set the default sequence for the agent's sequencer
        uvm_config_wrapper::set(this, "env.agent.sequencer.run_phase",
                                "default_sequence",
                                simple_gcd_seq::get_type());
        // Call the base class build_phase to create the testbench
        super.build_phase(phase);
    endfunction : build_phase

endclass : simple_gcd_test
