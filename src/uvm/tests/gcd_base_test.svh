/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_base_test.svh
* Author        :   Andrew Chen
* Date          :   9/7/2025
-------------------------------------------------------------------------------------------------*/

class base_gcd_test extends uvm_test;

    // UVM Component Macro
    `uvm_component_utils(base_gcd_test)

    // Testbench handle
    gcd_env env;

    // UVM Constructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        // Call the base class build_phase
        super.build_phase(phase);
        // Enable transaction recording for everything
        uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);
        // Instantiate the testbench
        env = gcd_env::type_id::create("env", this);
    endfunction : build_phase

    // Run phase
    virtual task run_phase(uvm_phase phase);
        // Get the objection for the run phase and set a drain time
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 2000ns);
    endtask : run_phase

    // The following phases are optional, but commonly used in UVM tests
    // They can be customized as needed for desired behavior and reporting

    // End of Elaboration phase
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        // Prints the UVM component hierarchy
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    // Start of Simulation phase
    virtual function void start_of_simulation_phase(uvm_phase phase);
        // Informational message indicating the start of simulation
        `uvm_info(get_type_name(), {"Start of simulation for ", get_full_name()}, UVM_HIGH);
    endfunction : start_of_simulation_phase

    // Check phase
    virtual function void check_phase(uvm_phase phase);
        // configuration checker
        check_config_usage();
    endfunction : check_phase

endclass : base_gcd_test