package gcd_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import gcd_seq_pkg::*;
    `include "gcd_driver.sv"
    `include "gcd_monitor.sv"
    `include "gcd_sequencer.sv"
    `include "gcd_agent.sv"
endpackage : gcd_agent_pkg