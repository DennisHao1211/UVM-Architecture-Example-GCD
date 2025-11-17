/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_sb.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Create a UVM analysis import to receive transactions from the monitor
*   4. Define the logic to handle incoming transactions and update provided statistics (in write)
*
* We have provided a golden function to compute the gcd that you can use to 
* compare received with expected outputs
-------------------------------------------------------------------------------------------------*/

class gcd_sb extends uvm_scoreboard;

    // 1) Register with factory
    `uvm_component_utils(gcd_sb)

    // 3) Analysis import to receive transactions from monitor
    uvm_analysis_imp #(gcd_seq_item, gcd_sb) analysis_export;

    // Scoreboard statistics. You can optionally add more if you want
    int num_in, num_correct, num_incorrect;

    // 2) Basic constructor
    function new(string name="gcd_sb", uvm_component parent=null);
      super.new(name, parent);
      analysis_export = new("analysis_export", this);
      num_in = 0; num_correct = 0; num_incorrect = 0;
    endfunction

    // Golden function to compute GCD
    function automatic bit [7:0] compute_gcd(bit [7:0] a, bit [7:0] b);
        bit [7:0] x = a;
        bit [7:0] y = b;
        while (y != 0) begin
            bit [7:0] temp = y;
            y = x % y;
            x = temp;
        end
        return x;
    endfunction : compute_gcd

    // 4) Handle incoming transactions
    virtual function void write (gcd_seq_item tr);
      bit [7:0] exp = compute_gcd(tr.data_a, tr.data_b);
      num_in++;
      if (tr.result_gcd === exp) begin
        num_correct++;
        `uvm_info("SB", $sformatf("Match: A=%0d B=%0d GCD=%0d",
                                tr.data_a, tr.data_b, tr.result_gcd), UVM_LOW)
      end
      else begin
        num_incorrect++;
        `uvm_error("SB", $sformatf("Mismatch: A=%0d B=%0d got=%0d exp=%0d",
                                 tr.data_a, tr.data_b, tr.result_gcd, exp))
      end
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report:\n\n   Scoreboard: Simulation Statistics \n     Num In:   %0d     Num Correct: %0d\n     Num Incorrect: %0d\n", num_in, num_correct, num_incorrect), UVM_LOW)
        if (num_incorrect > 0)
            `uvm_error(get_type_name(), "Status:\n\nSimulation FAILED\n")
        else
            `uvm_info(get_type_name(), "Status:\n\nSimulation PASSED\n", UVM_NONE)
    endfunction : report_phase


endclass : gcd_sb
