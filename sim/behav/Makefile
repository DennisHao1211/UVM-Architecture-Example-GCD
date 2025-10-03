#--------------------------------------------------------------------
# Makefile for Simulation (sim/behav workspace)
# - Creates symlinks to all sources under ../../src/
# - Runs Cadence Xcelium / SimVision with UVM
#--------------------------------------------------------------------

# ===== User-configurable knobs =====================================
TESTNAME        ?= all_gcd_test 
UVM_MAX_QUIT    ?= 1
UVM_VERBOSITY   ?= UVM_FULL

# Top level testbench
TOPLEVEL        ?= gcd_tb_top

# Define source directories relative to the project root
SRC_DIRS := src/sv/rtl \
            src/uvm/env \
            src/uvm/agent \
            src/uvm/sequences \
            src/uvm/tb \
            src/uvm/tests
# Define the simulation directory (current directory where makefile is located)
SIM_DIR := .

# Define the project root (assuming makefile is in /sim/behav)
PROJECT_ROOT := ../..

INC_DIRS := -incdir src/uvm/tests \
			-incdir src/uvm/agent \
			-incdir src/uvm/sequences \
			-incdir src/uvm/env \
			-incdir src/uvm/tb

SV_FILES := src/sv/rtl/gcd_pkg.sv \
			src/sv/rtl/gcd.sv \
			src/uvm/sequences/gcd_seq_pkg.sv \
			src/uvm/agent/gcd_agent_pkg.sv \
			src/uvm/env/gcd_env_pkg.sv \
			src/uvm/tests/gcd_test_pkg.sv \
			src/uvm/tb/gcd_if.sv \
			src/uvm/tb/gcd_tb_top.sv \

VERILOG_DEFINES := +SIM=1

# ===== Tool setup ==================================================
XRUN_FLAGS = -64bit -sv -linedebug -access +rwc \
             -timescale 1ns/10ps \
             -coverage all \
             -licqueue \
             -covoverwrite

UVMHOME ?=
ifeq ($(strip $(UVMHOME)),)
  UVM_SWITCH := -uvm
else
  UVM_SWITCH := -uvmhome $(UVMHOME)
endif

UVM_PLUSARGS = \
  +UVM_MAX_QUIT_COUNT=$(UVM_MAX_QUIT) \
  +UVM_TESTNAME=$(TESTNAME) \
  +UVM_VERBOSITY=$(UVM_VERBOSITY) \
  +define+$(VERILOG_DEFINES)

.DEFAULT_GOAL := run_and_view

# ===== Source linking ==============================================
.PHONY: link_src
link_src:
	@echo "Creating symbolic links..."
	@for src_dir in $(SRC_DIRS); do \
		echo "Processing $$src_dir..."; \
		if [ -d "$(PROJECT_ROOT)/$$src_dir" ]; then \
			mkdir -p "$$src_dir"; \
			find "$(PROJECT_ROOT)/$$src_dir" -type f \( -name "*.sv" -o -name "*.svh" -o -name "*.include" \) -exec bash -c ' \
				src_file="$$1"; \
				rel_path="$${src_file#$(PROJECT_ROOT)/}"; \
				target_dir="$$(dirname "$$rel_path")"; \
				mkdir -p "$$target_dir"; \
				ln -sf "$$(realpath "$$src_file")" "$$rel_path"; \
				echo "  Linked: $$rel_path"; \
			' _ {} \; ; \
		else \
			echo "  Warning: $$src_dir does not exist"; \
		fi; \
	done
	@echo "Symbolic links created successfully!"

# ===== Simulation targets ==========================================
.PHONY: xrun simvision run_and_view coverage

xrun: link_src
	xrun $(UVM_SWITCH) $(XRUN_FLAGS) \
	     $(UVM_PLUSARGS) \
		 $(INC_DIRS) \
	     $(SV_FILES) \
	     -top $(TOPLEVEL) \
	     -logfile simulation.log

simvision:
	simvision waves.shm &

run_and_view: xrun simvision

coverage:
	/tools/software/cadence/vmanager/latest/tools.lnx86/vmgr/bin/imc -load cov_work/scope/test &

# ===== Cleanup =====================================================
.PHONY: clean
clean:
	@echo "Cleaning workspace..."
	rm -rf *.v *.sv *.svh *.include
	rm -rf xcelium.d simv* *.log *.shm cov_work .simvision
	rm -rf waves.shm* *.fsdb *.vpd
	rm -rf simulation.history xrun.key
	@echo "Cleaning existing symbolic links..."
	@for src_dir in $(SRC_DIRS); do \
		if [ -d "$$src_dir" ]; then \
			find "$$src_dir" -type l -delete 2>/dev/null || true; \
			find "$$src_dir" -type d -exec rm -rf {} + 2>/dev/null || true; \
		fi; \
	done
	@echo "Cleanup complete!"
