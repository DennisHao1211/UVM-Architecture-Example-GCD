/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_sequence.svh
* Author        :   Andrew Chen
* Date          :   9/7/2025
-------------------------------------------------------------------------------------------------*/

class base_gcd_seq extends uvm_sequence #(gcd_seq_item);

    gcd_seq_item seq;

    // UVM Component Macro
    `uvm_object_utils(base_gcd_seq)

    // UVM Constructor
    function new(string name = "base_gcd_seq");
        super.new(name);
    endfunction : new

    // Pre body phase
    virtual task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            // in UVM1.2, get starting phase from method
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
        // Raise an objection to the phase to indicate that this sequence is active
        if (phase != null) begin
            phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "Raise Objection", UVM_MEDIUM)
        end
    endtask : pre_body

    virtual task body();
        `uvm_do(seq)
    endtask : body

    // Post body phase
    virtual task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            // in UVM1.2, get starting phase from method
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
        // Drop the objection to the phase to indicate that this sequence has completed
        if (phase != null) begin
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "Drop Objection", UVM_MEDIUM)
        end
    endtask : post_body

endclass : base_gcd_seq