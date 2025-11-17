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

  `uvm_component_utils(gcd_driver)

  // Get virtual interface from tb_top through config_db
  virtual gcd_if vif;

  function new(string name="gcd_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // Connect to DUT virtual interface
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual gcd_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "gcd_driver: virtual interface 'vif' not set via config_db")
  endfunction : connect_phase
    
  // Driving logic: 1) set valid_i=1 to send a_i/b_i, then wait until valid_o=1 (done)
  virtual task run_phase(uvm_phase phase);
    gcd_seq_item tr;

    // Initialize inputs (ensure these signals are reset before simulation starts)
    vif.valid_i <= 1'b0;
    vif.a_i     <= '0;
    vif.b_i     <= '0;

    // Wait for reset sequence to finish (handle already-asserted reset)
    if (vif.rst_i !== 1'b1) begin
      @(posedge vif.rst_i);
    end
    wait (vif.rst_i === 1'b0);

    forever begin
      // 1) Get next transaction from sequencer
      seq_item_port.get_next_item(tr);

      // 2) Drive signals and assert valid_i
      @(posedge vif.clk_i);
      vif.a_i     <= tr.data_a;
      vif.b_i     <= tr.data_b;
      vif.valid_i <= 1'b1;

      // 3) Deassert valid_i after one cycle
      @(posedge vif.clk_i);
      vif.valid_i <= 1'b0;

      // 4) Wait for DUT output (valid_o=1)
      do @(posedge vif.clk_i); while (vif.valid_o !== 1'b1);

      // 5) Finish current transaction
      seq_item_port.item_done();
    end
  endtask : run_phase

endclass : gcd_driver
