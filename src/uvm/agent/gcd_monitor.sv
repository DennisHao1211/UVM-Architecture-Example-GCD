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

  // 1) Register with factory
  `uvm_component_utils(gcd_monitor)

  // DUT virtual interface
  virtual gcd_if vif;

  // 5) Analysis port to broadcast observed transactions
  uvm_analysis_port #(gcd_seq_item) ap;

  // 2) Basic constructor
  function new(string name="gcd_monitor", uvm_component parent=null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  // 3) Get the virtual interface (per template: in connect_phase)
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual gcd_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "gcd_monitor: virtual interface 'vif' not set via config_db")
    end
  endfunction : connect_phase

  // 4) Sampling logic: when valid_o==1, capture a_i/b_i/gcd_o and write() out
  virtual task run_phase(uvm_phase phase);
    gcd_seq_item tr;
    forever begin
      @(posedge vif.clk_i);
      if (vif.valid_o === 1'b1) begin
        tr = gcd_seq_item::type_id::create("tr", this);
        tr.data_a     = vif.a_i;
        tr.data_b     = vif.b_i;
        tr.result_gcd = vif.gcd_o;
        ap.write(tr);
        `uvm_info("MON", $sformatf("Observed: A=%0d B=%0d GCD=%0d",
                                   tr.data_a, tr.data_b, tr.result_gcd), UVM_LOW)
      end
    end
  endtask : run_phase

endclass : gcd_monitor