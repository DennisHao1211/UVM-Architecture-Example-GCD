/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_test_lib.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
* Tasks to complete here:
*   1. Write more tests extended from the provided base test (gcd_base_test.svh)
*      to create different tests that run your different sequences.
-------------------------------------------------------------------------------------------------*/


class simple_gcd_test extends base_gcd_test;
  `uvm_component_utils(simple_gcd_test)

  function new(string name="simple_gcd_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
      "env.agent.seqr.run_phase",
      "default_sequence",
      simple_gcd_seq::get_type()
    );
    super.build_phase(phase);
  endfunction
endclass : simple_gcd_test


class gcd_randomN_test extends base_gcd_test;
  `uvm_component_utils(gcd_randomN_test)

  function new(string name="gcd_randomN_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
      "env.agent.seqr.run_phase",
      "default_sequence",
      gcd_randomN_seq::get_type()
    );
    super.build_phase(phase);
  endfunction
endclass : gcd_randomN_test


class gcd_corner_test extends base_gcd_test;
  `uvm_component_utils(gcd_corner_test)

  function new(string name="gcd_corner_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
      "env.agent.seqr.run_phase",
      "default_sequence",
      gcd_corner_seq::get_type()
    );
    super.build_phase(phase);
  endfunction
endclass : gcd_corner_test


class gcd_sweep_test extends base_gcd_test;
  `uvm_component_utils(gcd_sweep_test)

  function new(string name="gcd_sweep_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
      "env.agent.seqr.run_phase",
      "default_sequence",
      gcd_sweep_seq::get_type()
    );
    super.build_phase(phase);
  endfunction
endclass : gcd_sweep_test


class gcd_coprime_test extends base_gcd_test;
  `uvm_component_utils(gcd_coprime_test)

  function new(string name="gcd_coprime_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
      "env.agent.seqr.run_phase",
      "default_sequence",
      gcd_coprime_seq::get_type()
    );
    super.build_phase(phase);
  endfunction
endclass : gcd_coprime_test


class gcd_toggle_test extends base_gcd_test;
  `uvm_component_utils(gcd_toggle_test)

  function new(string name="gcd_toggle_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
      "env.agent.seqr.run_phase",
      "default_sequence",
      gcd_toggle_seq::get_type()
    );
    super.build_phase(phase);
  endfunction
endclass : gcd_toggle_test

class all_gcd_test extends base_gcd_test;
  `uvm_component_utils(all_gcd_test)

  function new(string name="all_gcd_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    if ((env == null) || (env.agent == null) || (env.agent.seqr == null)) begin
      `uvm_fatal("NOSEQR", "all_gcd_test: sequencer handle is null; cannot start sequences")
    end

    phase.raise_objection(this, "all_gcd_test: running full sequence sweep");

    run_sequence(simple_gcd_seq   ::type_id::create("simple_seq"   , this),
                 "simple_gcd_seq");
    run_sequence(gcd_randomN_seq  ::type_id::create("randomN_seq"  , this),
                 "gcd_randomN_seq");
    run_sequence(gcd_corner_seq   ::type_id::create("corner_seq"   , this),
                 "gcd_corner_seq");
    run_sequence(gcd_sweep_seq    ::type_id::create("sweep_seq"    , this),
                 "gcd_sweep_seq");
    run_sequence(gcd_coprime_seq  ::type_id::create("coprime_seq"  , this),
                 "gcd_coprime_seq");
    run_sequence(gcd_toggle_seq   ::type_id::create("toggle_seq"   , this),
                 "gcd_toggle_seq");

    phase.drop_objection(this, "all_gcd_test: completed full sequence sweep");
  endtask

  protected task run_sequence(base_gcd_seq seq_handle, string seq_name);
    if (seq_handle == null) begin
      `uvm_fatal("SEQNULL", $sformatf("Failed to create sequence '%s'", seq_name))
    end
    `uvm_info(get_type_name(),
              $sformatf("Starting %s", seq_name),
              UVM_MEDIUM)
    seq_handle.start(env.agent.seqr);
    `uvm_info(get_type_name(),
              $sformatf("Completed %s", seq_name),
              UVM_LOW)
  endtask

endclass : all_gcd_test
