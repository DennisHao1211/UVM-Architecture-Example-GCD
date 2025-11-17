/*-----------------------------------------------------------------------------------------------
* File Name     :   gcd_seq_lib.sv
* Author        :   Andrew Chen
* Date          :   9/7/2025
*
* Tasks to complete here:
*   1. Write more sequences extended from the provided base sequence (gcd_sequence.svh)
*      to create different test cases (ex. edge cases, randomized tests, etc) with the goal
*      to reach at least 96% coverage.
*
* A simple sequence that runs one randomized transaction is provided
-------------------------------------------------------------------------------------------------*/

// Example sequence extending the base sequence
class simple_gcd_seq extends base_gcd_seq;

    // UVM Component Macro
    `uvm_object_utils(simple_gcd_seq)

    // UVM Constructor
    function new(string name = "simple_gcd_seq");
        super.new(name);
    endfunction : new

    // Sequence body definition
    virtual task body();
        // Example transaction generation logic
        // This is where you would define the specific sequence behavior
        `uvm_info(get_type_name(), "Executing simple sequence", UVM_LOW)
        `uvm_do(seq)
    endtask : body

endclass : simple_gcd_seq


// ======================================================================
// 1) Multiple Randomized Transactions: gcd_randomN_seq
//    Purpose: Rapidly improve code coverage by running many random inputs
// ======================================================================
class gcd_randomN_seq extends base_gcd_seq;
  `uvm_object_utils(gcd_randomN_seq)

  // Number of random transactions to send
  int unsigned count = 200;

  function new(string name="gcd_randomN_seq");
    super.new(name);
  endfunction

  // Main sequence body
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Running %0d randomized items", count), UVM_MEDIUM)
    repeat (count) begin
      // Each call automatically randomizes seq.data_a and seq.data_b
      `uvm_do(seq)
    end
  endtask
endclass : gcd_randomN_seq



// ======================================================================
// 2) Corner / Boundary Case Sequence: gcd_corner_seq
//    Purpose: Hit edge cases like a=b, a=0, b=0, and max/min extremes
// ======================================================================
class gcd_corner_seq extends base_gcd_seq;
  `uvm_object_utils(gcd_corner_seq)

  function new(string name="gcd_corner_seq");
    super.new(name);
  endfunction

  // Main sequence body
  virtual task body();
    int unsigned equal_vals[5] = '{1, 2, 3, 16, 255};
    int unsigned b_vals[5]     = '{1, 2, 17, 128, 255};
    int unsigned a_vals[5]     = '{1, 2, 33, 200, 255};

    // Case 1: a == b (representative values)
    for (int idx=0; idx<5; idx++) begin
      `uvm_do_with(seq, { data_a == equal_vals[idx]; data_b == equal_vals[idx]; })
    end

    // Case 2: a == 0, b > 0
    for (int idx=0; idx<5; idx++) begin
      `uvm_do_with(seq, { data_a == 0; data_b == b_vals[idx]; })
    end

    // Case 3: b == 0, a > 0
    for (int idx=0; idx<5; idx++) begin
      `uvm_do_with(seq, { data_b == 0; data_a == a_vals[idx]; })
    end

    // Case 4: Extreme combinations
    `uvm_do_with(seq, { data_a == 1;   data_b == 255; })
    `uvm_do_with(seq, { data_a == 255; data_b == 1;   })
    `uvm_do_with(seq, { data_a == 254; data_b == 2;   })
    `uvm_do_with(seq, { data_a == 128; data_b == 128; })
  endtask
endclass : gcd_corner_seq



// ======================================================================
// 3) Small-Range Sweep Sequence: gcd_sweep_seq
//    Purpose: Systematically cover a compact grid (a,b) in [1..8]
// ======================================================================
class gcd_sweep_seq extends base_gcd_seq;
  `uvm_object_utils(gcd_sweep_seq)

  // Sweep range for a and b
  int unsigned a_lo = 1, a_hi = 8;
  int unsigned b_lo = 1, b_hi = 8;

  function new(string name="gcd_sweep_seq");
    super.new(name);
  endfunction

  // Main sequence body
  virtual task body();
    for (int a=a_lo; a<=a_hi; a++) begin
      for (int b=b_lo; b<=b_hi; b++) begin
        // Deterministic values (no randomize)
        `uvm_do_with(seq, { data_a == a; data_b == b; })
      end
    end
  endtask
endclass : gcd_sweep_seq



// ======================================================================
// 4) Coprime Input Sequence: gcd_coprime_seq
//    Purpose: Exercise the gcd==1 functional path (mutually prime pairs)
// ======================================================================
class gcd_coprime_seq extends base_gcd_seq;
  `uvm_object_utils(gcd_coprime_seq)

  // Predefined list of coprime pairs
  localparam int unsigned NUM = 8;
  int unsigned pairs[NUM][2] = '{
    '{3, 4}, '{8, 15}, '{14, 25}, '{35, 64},
    '{17, 31}, '{5,  12}, '{7,  20}, '{11, 19}
  };

  function new(string name="gcd_coprime_seq");
    super.new(name);
  endfunction

  // Main sequence body
  virtual task body();
    for (int i=0; i<NUM; i++) begin
      // Force inputs to specific coprime pairs
      `uvm_do_with(seq, { data_a == pairs[i][0]; data_b == pairs[i][1]; })
    end
  endtask
endclass : gcd_coprime_seq


// ======================================================================
// 5) Toggle Coverage Booster Sequence: gcd_toggle_seq
//    Purpose: Force wide bit activity on a_i/b_i/gcd_o to lift toggle cov
// ======================================================================
class gcd_toggle_seq extends base_gcd_seq;
  `uvm_object_utils(gcd_toggle_seq)

  typedef struct packed {
    bit [7:0] a;
    bit [7:0] b;
  } gcd_pair_t;

  localparam int NUM_PATTERNS = 12;
  gcd_pair_t patterns[NUM_PATTERNS] = '{
    '{8'h00, 8'h01}, // exercise zero operand
    '{8'hFF, 8'h01}, // MSBs high in a
    '{8'h01, 8'hFF}, // MSBs high in b
    '{8'hAA, 8'h55}, // alternating bits
    '{8'h55, 8'hAA}, // inverse alternating bits
    '{8'hF0, 8'h0F}, // high nibble vs low nibble
    '{8'h0F, 8'hF0},
    '{8'h80, 8'h40}, // single-bit walking patterns
    '{8'h40, 8'h80},
    '{8'h7F, 8'h03}, // result forces multiple bit transitions
    '{8'h9C, 8'h58},
    '{8'hFE, 8'h02}
  };

  function new(string name="gcd_toggle_seq");
    super.new(name);
  endfunction

  virtual task body();
    foreach (patterns[idx]) begin
      // Create a fresh item and drive explicit values to ensure bit toggling
      gcd_seq_item item;
      item = gcd_seq_item::type_id::create($sformatf("toggle_item_%0d", idx));
      if (item == null) begin
        `uvm_fatal(get_type_name(), $sformatf("Failed to allocate toggle_item_%0d", idx))
      end

      start_item(item);
      item.data_a = patterns[idx].a;
      item.data_b = patterns[idx].b;
      finish_item(item);
    end
  endtask
endclass : gcd_toggle_seq
