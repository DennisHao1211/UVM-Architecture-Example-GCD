/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_seq_item.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
-------------------------------------------------------------------------------------------------*/

class gcd_seq_item extends uvm_sequence_item;

    localparam TB_WIDTH = 8;

    // Data fields for the transaction
    rand bit [TB_WIDTH-1:0] data_a, data_b;

    bit [7:0] result_gcd;

    // UVM Component Macro
    `uvm_object_utils_begin(gcd_seq_item)
        // Register data fields for randomization and recording
        `uvm_field_int(data_a, UVM_ALL_ON)
        `uvm_field_int(data_b, UVM_ALL_ON)
        `uvm_field_int(result_gcd, UVM_ALL_ON)
    `uvm_object_utils_end

    // UVM Constructor
    function new(string name = "gcd_seq_item");
        super.new(name);
    endfunction : new

    // Define desired constraints for randomization
    constraint valid_inputs { data_a > 0; data_a <= 255;
                              data_b > 0; data_b <= 255; }

endclass : gcd_seq_item