# A Simple Adder UVM Example ([vlsiverify](https://vlsiverify.com/uvm/uvm-adder-example/))
![How Components Connect](https://vlsiverify.com/wp-content/uploads/2021/05/Testbench-Block-Diagram.jpg)
## Table of Contents
- [Module + Interface](#adder-module-and-interface)
- [Sequence Item](#sequence-item)
- [Sequence](#sequence)
- [Sequencer](#sequencer)
- [Driver](#driver)
- [Monitor](#monitor)
- [Agent](#agent)
- [Scoreboard](#scoreboard)
- [Environment](#environment)
- [Test](#test)
- [Top](#top)
## Adder Module And Interface
```SystemVerilog
module adder(input clk, reset, input [7:0] in1, in2, output reg [8:0] out);
	always@(posedge clk or posedge reset) begin 
	    if(reset) out <= 0;
	    else out <= in1 + in2;
	end
endmodule
```
```SystemVerilog
interface add_if(input clk, input reset);
	logic[7:0] ip1;
	logic[7:0] ip2;
	logic[8:0] out;	
endinterface
```
## Sequence Item
The sequence item class contains the necessary stimulus generation data members.
```SystemVerilog
class seq_item extends uvm_sequence_item;
	rand bit [7:0] ip1, ip2;
	bit [8:0] out;

	function new(string name = "seq_item");
		super.new(name);
  	endfunction

	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(ip1,UVM_ALL_ON)
		`uvm_field_int(ip2,UVM_ALL_ON)
	`uvm_object_utils_end

	constraint ip_c {ip1 < 100; ip2 < 100;}
endclass
```

### Code Explanation
Inherits the `uvm_sequence_item` class.
```SystemVerilog
class seq_item extends uvm_sequence_item;
```
- `uvm_sequence_item` is the base class for all transaction-level objects.
- This means our `seq_item` can be used as a **transaction** between the [sequencer](#sequencer) and [driver](#driver).

Randomized stimulus fields.
```SystemVerilog
rand bit [7:0] ip1, ip2;
bit [8:0] out;
```
- `ip1` and `ip2` are randomizable inputs.
- `out` is **not** randomized, it represents the result that we be produced by the DUT or the [scoreboard](#scoreboard).

Constructor for [`uvm_object`](https://vlsiverify.com/uvm/uvm-object/).
```SystemVerilog
function new(string name = "seq_item");
	super.new(name);
endfunction
```
- What is an `uvm_object`: it is the **base class** for lightweight, transaction-level objects. No hierarchy or [phasing](https://vlsiverify.com/uvm/uvm-phases/) is involved — these are just _objects in memory_, not part of the UVM testbench hierarchy.
- Every `uvm_object`-derived class needs a constructor.
- `super.new(name)` calls the parent constructor so that UVM can track and manage this object properly.

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
```SystemVerilog
`uvm_object_utils_begin(seq_item)
	`uvm_field_int(ip1,UVM_ALL_ON)
	`uvm_field_int(ip2,UVM_ALL_ON)
`uvm_object_utils_end
```
- What is the [factory](https://vlsiverify.com/uvm/uvm-factory/): it is a **centralized creation mechanism** in UVM. Instead of hardcoding `new()`, you use the factory (`::type_id::create`) to build objects and components.
- `uvm_object_utils_begin/uvm_object_utils_end` registers the class with the factory.
- `uvm_field_*` registers individual fields for use in:
    - Printing (`print()` method)
    - Copying / Comparing (useful in scoreboards)
    - Recording (waveform-like logging)
- `UVM_ALL_ON` enables all automation features for these fields.
- **STOP HERE**: Utility and field macros are an important concept. Read [this](https://www.chipverify.com/uvm/uvm-field-macros) before continuing on as the notes above only cover the specifics of this example.

Constraint block.
```SystemVerilog
constaint ip_c {ip1 < 100; ip2 < 100;}
```
- Nothing special here. Just your regular SystemVerilog constraint.
## Sequence
The sequence creates the stimulus and drives them to the driver via sequencer.
```SystemVerilog
class base_seq extends uvm_sequence#(seq_item);
	seq_item req;
	`uvm_object_utils(base_seq)
	
	function new (string name = "base_seq");
	    super.new(name);
	endfunction
	
	task body();
		`uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
		`uvm_do(req);
	endtask
endclass
```

### Code Explanation
Inherits the `uvm_sequence` base class (parameterized by your transaction type).
```SystemVerilog
class base_seq extends uvm_sequence#(seq_item);
```
- `uvm_sequence#(T)` is the base for **active** objects that create and send transactions (`T`) to a sequencer.
- An active object is one that has a process or task running in time which generates or consumes transactions.
- Here `T` is `seq_item`, so this sequence will produce `seq_item` transactions for the [driver](#driver).

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
```SystemVerilog
`uvm_object_utils(base_seq)
```
- Notice how it is different to the [sequence item](#sequence-item). While a sequence item and a sequencer are both `uvm_object`, because the sequence does not have any fields, the syntax is *slightly* different.

Constructor for `uvm_object`. 
- Refer to previous notes.

Main sequence body.
```SystemVerilog
task body();
	`uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
	`uvm_do(req);
endtask
```
- `body()` is where you generate and send transactions. It is a `task`, so it can consume simulation time.
- `` `uvm_do(req)`` is a convenience macro. Read [this](https://www.chipverify.com/uvm/uvm-do-macros) for more details. This means one **randomized** `seq_item` is produced and handed to the sequencer/driver.
- Another common convenience macro is `` `uvm_do_with(req, {<constraints>}) ``. This is how we do directed tests.
- Instead of `print`, in UVM we use `` `uvm_info`` for logging. There are different verbosity levels. Refer [here](https://www.chipverify.com/uvm/report-functions) for more information on different types and when they are used.
- Once you create a base sequence, you can extend it to create more sequences with different conditions (different input vectors, different constraints etc.)
- Notice how in this sequence, it only sends **one** transaction. Below is an example to send 100 randomized transactions:
```SystemVerilog
task body();
	`uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
	repeat(100) begin
		`uvm_do(req);
	end
endtask
```
## Sequencer
The sequencer is a mediator who establishes a connection between [sequence](#sequence) and [driver](#driver).
```SystemVerilog
class seqcr extends uvm_sequencer#(seq_item);
	`uvm_component_utils(seqcr)
	
	function new(string name = "seqcr", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass
```

### Code Explanation
Inherits the `uvm_sequencer` base class (parameterized by your transaction type).
- Refer to notes above.

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
```SystemVerilog
`uvm_component_utils(seqcr)
```
- Registers `seqcr` as a **component** (not object) in the UVM factory.
- What is a `uvm_component`: lives in the testbench hierarchy, has simulation [phases](https://vlsiverify.com/uvm/uvm-phases/), and is static. It exists throughout the entire simulation.

Constructor
```SystemVerilog
function new(string name = "seqcr", uvm_component parent = null);
	super.new(name, parent);
endfunction
```
- Note the difference between this constructor and the constructor associated with an `uvm_object`.

[Build Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
```
- The build phase in UVM is a simulation phase where all `uvm_component`s are constructed and configured before simulation runs. You typically use it to create sub-components (via the factory) and set up configuration objects.
- **STOP HERE**: UVM phasing are an important concept. It is imperative that you read [this](https://vlsiverify.com/uvm/uvm-phases/).
## Driver
The driver drives randomized transactions or sequence items to DUT as a pin-level activity using an interface.
```SystemVerilog
class driver extends uvm_driver#(seq_item);
	virtual add_if vif;
	seq_item req; 
	`uvm_component_utils(driver)
	
	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
		  `uvm_fatal(get_type_name(), "Not set at top level");
	endfunction
	
	task run_phase (uvm_phase phase);
		forever begin
			// Driver to the DUT
			seq_item_port.get_next_item(req);
			`uvm_info(get_type_name, $sformatf("ip1 = %0d, ip2 = %0d", req.ip1, req.ip2), UVM_LOW);
			vif.ip1 <= req.ip1;
			vif.ip2 <= req.ip2;
			seq_item_port.item_done();
		end
	endtask
endclass
```

### Code Explanation
Inherits the `uvm_driver` base class (parameterized by your transaction type).
- Refer to notes above.

Virtual Interface Handle.
```SystemVerilog
virtual add_if vif;
```
- A [virtual interface](https://vlsiverify.com/system-verilog/virtual-interface/) is just a reference (pointer) to a real interface instance. It doesn’t hold signals itself. In UVM, this reference is bound at runtime through the [`uvm_config_db`](https://vlsiverify.com/uvm/uvm_config_db-in-uvm/): the top-level testbench sets the actual interface into the config database, and components like the driver retrieve that reference in `build_phase`.

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
- Refer to prior notes.

Constructor.
- Refer to prior notes.

[Build Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif))
	  `uvm_fatal(get_type_name(), "Not set at top level");
endfunction
```
- Retrieves the `vif` from the configuration database.
- What is [`uvm_config_db`](https://vlsiverify.com/uvm/uvm_config_db-in-uvm/): A global key-value store for passing configuration (like virtual interfaces) into UVM components. 
```SystemVerilog
// Set Key-Value Pair
uvm_config_db#(type)::set(parent, inst_path, field_name, value); 

// Get Key-Value Pair
uvm_config_db#(type)::get(this, inst_path, field_name, var)
````
- `type`: the data type being stored (e.g., `virtual add_if`)
- `parent`: scope where it’s set (`null` means global)
- `inst_path`: hierarchical path to target component (e.g., `"env.agent.driver"`)
- `field_name`: key name (string)
- `value` / `var`: the actual object or variable reference
- **STOP HERE**: UVM `config_db` is an important concept. It is imperative that you read [this](https://vlsiverify.com/uvm/uvm_config_db-in-uvm/).

[Run Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
task run_phase (uvm_phase phase);
	forever begin
		// Driver to the DUT
		seq_item_port.get_next_item(req);
		vif.ip1 <= req.ip1;
		vif.ip2 <= req.ip2;
		seq_item_port.item_done();
	end
endtask
```
- `seq_item_port.get_next_item(req);` blocks until a transaction is avaliable
- `vif.ip1 <= req.ip1` and variants drives the DUT via the virtual interface from the data encapsulated in the [sequence item](#sequence-item).
- `seq_item_port.item_done();` acknowledges completion. Notifies the sequencer we are done so it can send in more transactors. 
- The `seq_item_port` formalizes the handshake between the sequence, sequencer and driver.
## Monitor
A UVM monitor is a passive component used to capture DUT signals using a virtual interface and translate them into a sequence item format.
```SystemVerilog
class monitor extends uvm_monitor;
	virtual add_if vif;
	uvm_analysis_port #(seq_item) item_collect_port;
	`uvm_component_utils(monitor)
	
	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
		item_collect_port = new("item_collect_port", this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual add_if) :: get(this, "", "vif", vif)) 
			`uvm_fatal(get_type_name(), "Not set at top level");
	endfunction
	
	task run_phase (uvm_phase phase);
		forever begin
			wait(!vif.reset);
			@(posedge vif.clk);
			seq_item tr = seq_item::type_id::create("tr");
			tr.ip1 = vif.ip1;
			tr.ip2 = vif.ip2;
			`uvm_info(get_type_name, $sformatf("ip1 = %0d, ip2 = %0d", tr.ip1, tr.ip2), UVM_HIGH);
			@(posedge vif.clk);
			tr.out = vif.out;
			item_collect_port.write(tr);
		end
	endtask
endclass
```

### Code Explanation
Inherits the `uvm_monitor` base class (parameterized by your transaction type).
- Refer to notes above.

Virtual Interface Handle.
- Refer to notes above.

[Analysis Port](https://www.chipverify.com/uvm/uvm-tlm-analysis-port)
```SystemVerilog
uvm_analysis_port #(seq_item) item_collect_port;
```
- It is a broadcast port.
- Any number of subscribers (scoreboards, coverage collectors, subscribers) can be connected to it and will **automatically receive a copy** of the transaction.
	- Publisher = monitor (sends observed transactions).
	- Subscriber = scoreboard, coverage, logger (receive and process them).

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
- Refer to prior notes.

Constructor
```SystemVerilog
	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
		item_collect_port = new("item_collect_port", this);
	endfunction
```
- `item_collect_port = new("item_collect_port", this);` creates the analysis port.

[Build Phase](https://vlsiverify.com/uvm/uvm-phases/) with [`uvm_config_db`](https://vlsiverify.com/uvm/uvm_config_db-in-uvm/)
- Refer to prior notes.

[Run Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
task run_phase (uvm_phase phase);
	forever begin
		wait(!vif.reset);
		@(posedge vif.clk);
		seq_item tr = seq_item::type_id::create("tr");
		tr.ip1 = vif.ip1;
		tr.ip2 = vif.ip2;
		@(posedge vif.clk);
		tr.out = vif.out;
		item_collect_port.write(tr);
	end
endtask
```
- `seq_item tr = seq_item::type_id::create("tr");` we can do this because we registered `seq_item` with the factory. Enables **polymorphic substitution**: you can override `seq_item` with a different class (e.g., `my_seq_item`) in your test without changing the monitor/sequence code.
- Monitor looks at the pins and encapsulate the output back into the `seq_item` to be published to the [scoreboard](#scoreboard) via the analysis port. 
- `item_collect_port.write(tr);` publishes the item.
- If DUT latency differs, adjust the number of `@(posedge vif.clk);` between input and output sampling.
## Agent
An agent is a container that holds and connects the driver, monitor, and sequencer instances. Refer to the image at the very top.
```SystemVerilog
class agent extends uvm_agent;
	`uvm_component_utils(agent)
	driver drv;
	seqcr seqr;
	monitor mon;
	
	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin 
			drv = driver::type_id::create("drv", this);
			seqr = seqcr::type_id::create("seqr", this);
		end
		
		mon = monitor::type_id::create("mon", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE) begin 
			drv.seq_item_port.connect(seqr.seq_item_export);
		end
	endfunction
endclass
```

### Code Explanation
Inherits the `uvm_monitor` base class (parameterized by your transaction type).
- Refer to notes above.

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
- Refer to prior notes.

Instantiation of Sub-components
```SystemVerilog
driver drv;
seqcr seqr;
monitor mon;
```
- Handles for the agent's child components

Constructor
- Refer to prior notes.

[Build Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(get_is_active() == UVM_ACTIVE) begin 
		drv = driver::type_id::create("drv", this);
		seqr = seqcr::type_id::create("seqr", this);
	end
	
	mon = monitor::type_id::create("mon", this);
endfunction
```
- Active agent: builds driver and sequencer in addition to the monitor. Used when we want to drive stimulus into the DUT.
- Passive agent: builds monitor only. Used when we only need to observe and check DUT activity without controlling it.
- Uses the [factory](https://vlsiverify.com/uvm/uvm-factory/)  so tests can override implementations.

[Connect Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
function void connect_phase(uvm_phase phase);
	if(get_is_active() == UVM_ACTIVE) begin 
		drv.seq_item_port.connect(seqr.seq_item_export);
	end
endfunction
```
- What is Connect Phase: The connect phase is a UVM simulation phase used to wire up TLM ports and exports between components.
- `drv.seq_item_port.connect(seqr.seq_item_export);` connects the driver’s pull port to the sequencer’s export so the driver can fetch sequence items.
## Scoreboard
The UVM scoreboard is a component that checks the functionality of the DUT. It receives transactions from the monitor using the analysis export for checking purposes.
```SystemVerilog
class scoreboard extends uvm_scoreboard;
	uvm_analysis_imp #(seq_item, scoreboard) item_collect_export;
	seq_item item_q[$];
	`uvm_component_utils(scoreboard)
	
	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
		item_collect_export = new("item_collect_export", this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	function void write(seq_item req);
		item_q.push_back(req);
	endfunction
	
	task run_phase (uvm_phase phase);
		seq_item sb_item;
		forever begin
			wait(item_q.size > 0);
			
			if(item_q.size > 0) begin
				sb_item = item_q.pop_front();
				$display("----------------------------------------------------------------------------------------------------------");
				if(sb_item.ip1 + sb_item.ip2 == sb_item.out) begin
					`uvm_info(get_type_name(), $sformatf("Matched: ip1 = %0d, ip2 = %0d, out = %0d", sb_item.ip1, sb_item.ip2, sb_item.out),UVM_LOW);
				end
				else begin
					`uvm_error(get_name, $sformatf("NOT matched: ip1 = %0d, ip2 = %0d, out = %0d", sb_item.ip1, sb_item.ip2, sb_item.out));
				end
				$display("----------------------------------------------------------------------------------------------------------");
			end
		end
	endtask
endclass
```

### Code Explanation
Inherits the `uvm_scoreboard` base class (parameterized by your transaction type).
- Unlike drivers/monitors, a scoreboard is **purely passive**: it consumes transactions and checks correctness.

[Analysis Port](https://www.chipverify.com/uvm/uvm-tlm-analysis-port)
```SystemVerilog
uvm_analysis_port #(seq_item) item_collect_export;
```
- When the monitor calls `item_collect_port.write(tr)`, the scoreboard’s `write()` method is automatically invoked.
- To connect the `item_collect_port` in monitor to `item_collect_export` in scoreboard, it is done in the environment.

[Factory](https://vlsiverify.com/uvm/uvm-factory/) registration macros.
- Refer to prior notes.

Constructor
```SystemVerilog
function new(string name = "scoreboard", uvm_component parent = null);
	super.new(name, parent);
	item_collect_export = new("item_collect_export", this);
endfunction
```
- Creates `item_collect_export`

Build Phase
- Refer to previous notes.

Write Method
```SystemVerilog
function void write(seq_item req);
  item_q.push_back(req);
endfunction
```
- Pushes item into a local queue for processing.

[Run Phase](https://vlsiverify.com/uvm/uvm-phases/)
```SystemVerilog
	task run_phase (uvm_phase phase);
		seq_item sb_item;
		forever begin
			wait(item_q.size > 0);
			
			if(item_q.size > 0) begin
				sb_item = item_q.pop_front();

				if(sb_item.ip1 + sb_item.ip2 == sb_item.out) begin
					`uvm_info(get_type_name(), $sformatf("Matched: ip1 = %0d, ip2 = %0d, out = %0d", sb_item.ip1, sb_item.ip2, sb_item.out),UVM_LOW);
				end
				else begin
					`uvm_error(get_name, $sformatf("NOT matched: ip1 = %0d, ip2 = %0d, out = %0d", sb_item.ip1, sb_item.ip2, sb_item.out));
				end;
			end
		end
	endtask
```
- `wait(item_q.size > 0);` wait until there is item in queue, then pop it out for processing.
- **The Golden Model Is In Here**.
## Environment
An environment provides a container for agents, scoreboards, and other verification components.
```SystemVerilog
class env extends uvm_env;
	`uvm_component_utils(env)
	agent agt;
	scoreboard sb;
	
	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = agent::type_id::create("agt", this);
		sb = scoreboard::type_id::create("sb", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		agt.mon.item_collect_port.connect(sb.item_collect_export);
	endfunction
endclass
```

### Code Explanation
At this point of the tutorial, if you have read and understood everything above. You should be able to derive what is going on here. If you have any questions, please go back to the appropriate sections and reread it, ask ChatGPT or a DV lead.
## Test
The test is at the top of the hierarchical component that initiates the environment component construction.
```SystemVerilog
class base_test extends uvm_test;
	env env_o;
	base_seq bseq;
	`uvm_component_utils(base_test)
	
	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_o = env::type_id::create("env_o", this);
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		bseq = base_seq::type_id::create("bseq");
		
		repeat(10) begin 
			#5; bseq.start(env_o.agt.seqr);
		end
	
		phase.drop_objection(this);
		`uvm_info(get_type_name, "End of testcase", UVM_LOW);
	endtask
endclass
```
### Code Explanation
At this point of the tutorial, if you have read and understood everything above. You should be able to derive most of the things going on here. If you have any questions, please go back to the appropriate sections and reread it, ask ChatGPT or a DV lead.

Objections
```SystemVerilog
phase.raise_objection(this);
// Stuff
phase.drop_objection(this);
```
- By default, when all components finish their `run_phase`, UVM tries to end the simulation.
- If you want the simulation to keep running (e.g., while sequences are generating stimulus), you must **raise an objection**.
- When you’re done, you **drop the objection**, and UVM knows it can safely end the phase.

Starting the Sequence
```SystemVerilog
bseq.start(env_o.agt.seqr);
```
- We might have multiple environments and multiple agents with different sequencer. 
- This line tells us which sequence to run and where is the sequencer to generate the stimulus.
## Top
The testbench top is a static container that has an instantiation of DUT and interfaces.
```SystemVerilog
module tb_top;
	bit clk;
	bit reset;
	always #2 clk = ~clk;

	initial begin
		//clk = 0;
		reset = 1;
		#5; 
		reset = 0;
	end
	add_if vif(clk, reset);

	adder DUT(.clk(vif.clk),.reset(vif.reset),.in1(vif.ip1),.in2(vif.ip2),.out(vif.out));

	initial begin
		// set interface in config_db
		uvm_config_db#(virtual add_if)::set(uvm_root::get(), "*", "vif", vif);
	end
	initial begin
		run_test("base_test");
	end
endmodule
```
### Code Explanation
Instantiates everything. Stores the interface in `config_db`.
