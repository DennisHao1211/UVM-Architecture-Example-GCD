/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_env.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Call the UVM component macro to register with the factory
*   2. Define the basic UVM Constructor
*   3. Instantiate the agent and scoreboard
*   4. Connect your monitor analysis port to the scoreboard analysis import
-------------------------------------------------------------------------------------------------*/

class gcd_env extends uvm_env;

  // 1) Register with factory
  `uvm_component_utils(gcd_env)

  // Sub-components
  gcd_agent agent;
  gcd_sb    sb;

  // 2) Basic constructor
  function new(string name="gcd_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // 3) Instantiate the agent and scoreboard
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = gcd_agent::type_id::create("agent", this);
    sb    = gcd_sb   ::type_id::create("sb",    this);
  endfunction : build_phase

  // 4) Connect monitor.ap to scoreboard.analysis_export
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.ap.connect(sb.analysis_export);
  endfunction : connect_phase

endclass : gcd_env