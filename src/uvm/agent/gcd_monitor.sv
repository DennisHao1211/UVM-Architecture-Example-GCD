/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_monitor.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Instantiate and connect the monitor to the DUT virtual interface (connect_phase)
*   4. Define the logic to monitor transaction signals from the DUT (run_phase)
*   5. Create a UVM analysis port that writes monitored transactions to the scoreboard
-------------------------------------------------------------------------------------------------*/

class gcd_monitor extends uvm_monitor;

    virtual function void connect_phase(uvm_phase phase);

    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);

    endtask : run_phase

endclass : gcd_monitor