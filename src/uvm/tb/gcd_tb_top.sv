/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_tb_top.sv
* Author        :   Andrew Chen
* Date          :   8/9/2025
-------------------------------------------------------------------------------------------------*/

module gcd_tb_top;

    timeunit 1ns;
    timeprecision 100ps;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import gcd_test_pkg::*;
    import gcd_seq_pkg::*;
    import gcd_agent_pkg::*;
    import gcd_env_pkg::*;

    logic clk = 0;
    logic rst = 0;

    always #10ns clk = ~clk;

    initial begin
        rst = 1;
        #10ns rst = 0;
    end

    // Interface instantiation
    gcd_if if0(clk, rst);

    // DUT instantiation
    gcd dut(
        .clk_i(clk),
        .rst_i(rst),
        .valid_i(if0.valid_i),
        .a_i(if0.a_i),
        .b_i(if0.b_i),
        .gcd_o(if0.gcd_o),
        .valid_o(if0.valid_o));

    initial begin
        // Initialize waveform dumping
        $shm_open("waves.shm");
        $shm_probe("AS");
        // Store the virtual interface handle 'if0' in the UVM configuration database
        // under the field name "vif" so all components under uvm_root can access it.
        uvm_config_db #(virtual gcd_if)::set(uvm_root::get(), "*", "vif", if0);
        run_test();
    end

endmodule : gcd_tb_top
