/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_seq_lib.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Write more sequences extended from the provided base sequence (gcd_sequence.svh)
*      to create different test cases (ex. edge cases, randomized tests, etc) with the goal
*      to reach at least 96% coverage.
*
* A simple sequence that runs one randomized transaction is provided
-------------------------------------------------------------------------------------------------*/

// Example sequence extending the base sequence
class simple_gcd_seq extends base_gcd_seq;

    // UVM Component Macro
    `uvm_object_utils(simple_gcd_seq)

    // UVM Constructor
    function new(string name = "simple_gcd_seq");
        super.new(name);
    endfunction : new

    // Sequence body definition
    virtual task body();
        // Example transaction generation logic
        // This is where you would define the specific sequence behavior
        `uvm_info(get_type_name(), "Executing simple sequence", UVM_LOW)
        `uvm_do(req)
    endtask : body

endclass : simple_gcd_seq