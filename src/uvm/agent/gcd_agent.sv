/*-----------------------------------------------------------------------------------------------
* File Name     :   agent_template.sv
* Author        :   Andrew Chen
* Date          :   8/9/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Instantiate your driver, monitor, and sequencer based on is_active
*   4. Connect your sequencer to your driver based on is_active
-------------------------------------------------------------------------------------------------*/

class gcd_agent extends uvm_agent;

  `uvm_component_utils(gcd_agent)

  // Sub-components
  gcd_driver     drv;
  gcd_sequencer  seqr;
  gcd_monitor    mon;

  function new(string name="gcd_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // 3) Instantiate driver/monitor/sequencer based on is_active, and pass down vif
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // monitor is always present
    mon  = gcd_monitor   ::type_id::create("mon",  this);
 
    if (is_active == UVM_ACTIVE) begin
      drv  = gcd_driver    ::type_id::create("drv",  this);
      seqr = gcd_sequencer ::type_id::create("seqr", this);
    end
  endfunction : build_phase

  // 4) Connect sequencer and driver when active
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
// The connection between monitor.ap and scoreboard.analysis_export is done in the environment.
  endfunction : connect_phase

endclass : gcd_agent