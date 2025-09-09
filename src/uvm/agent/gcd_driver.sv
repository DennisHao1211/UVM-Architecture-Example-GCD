/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_driver.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Instantiate and connect the driver to the DUT virtual interface (connect_phase)
*   4. Define the logic to drive transaction signals onto the DUT (run_phase)
-------------------------------------------------------------------------------------------------*/

class gcd_driver extends uvm_driver #(gcd_seq_item);

    virtual function void connect_phase(uvm_phase phase);
        
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
       
    endtask : run_phase

endclass : gcd_driver