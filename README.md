# A Brief Introduction to UVM
UVM Onboarding For DV Members

## Onboarding Tasks
In this onboarding, you will learn a high-level overview of UVM. Due to the compressed nature of this onboarding, we cannot go over 100% of the library. In each chapter, there **will** be inline links. It is imperative for you to click on them and read them to have a complete understanding. We also assume that you have some idea of what OOP is. If not, please read up on it.

In this project, you will create a UVM Testbench for a GCD Module completing the following steps:
1. Create the driver, monitor, and sequencer.
2. Instantiate the driver, monitor, and sequencer in an agent.
3. Write the scoreboard.
4. Instantiate the agent and scoreboard in the environment.
5. Write different sequences (by extending the base sequence) for different test cases.
6. Write different tests to run the different sequences.
7. Debug the faulty RTL.
8. Get 96% code coverage.
   
Don't worry if a lot of words here make no sense. In the following chapters,  we will address all of them.

REFER [HERE](https://github.gatech.edu/SiliconJackets/uvm_onboarding/blob/main/EXAMPLE.md) to learn via an example.

## Getting Started
1. Log in to the LinLab server and clone the git repo
   - `git clone https://github.gatech.edu/SiliconJackets/uvm_onboarding.git`
2. Setting up your environment for UVM
   - Add the following line to your ~/.my-cshrc file: `setenv UVMHOME /tools/software/cadence/xcelium/latest/tools/methodology/UVM/CDNS-1.1d`
   - You should have previously signed the Cadence EULA from onboarding and have the line `source /tools/software/cadence/setup.csh` in your ~/.my-cshrc. If not, you will need to do this before continuing
   - Switch to tc shell by running `tcsh`
3. Create your UVM Testbench for the GCD Module. The tasks you need to complete for each step are listed in comments at the top of each file
   - Create the driver, monitor, and sequencer.
   - Instantiate the driver, monitor, and sequencer in an agent.
   - Write the scoreboard.
   - Instantiate the agent and scoreboard in the environment.
   - Write different sequences (by extending the base sequence) for different test cases.
   - Write different tests to run the different sequences.
   - Debug the faulty RTL.
   - Get 96% code coverage.
4. Commands to run your testbench
   1. cd to the sim/behav/ subdirectory
   2. Run `make link_src`
   3. Run `make xrun`
      - To run the Cadence waveform tool, run `make simvision`
      - To run the Cadence coverage tool, run `make coverage`
      - To clean up output files and symbolic links to your src code, run `make clean`

## Directory Overview

### `sim/behav/`
This is the simulation directory where you will run your testbench. It contains the Makefile with all commands necessary to run your testbench and use the Cadence Tools

### `src/`
This directory contains all the source code for both RTL and your UVM Testbench

#### `src/sv/rtl/`
This subdirectory contains the GCD Module source code

#### `src/uvm/`
This subdirectory contains all the UVM subdirectories

##### `src/uvm/agent/`
This subdirectory contains the agent and all of its components (driver, monitor, sequencer)

##### `src/uvm/env/`
This subdirectory contains your environment and scoreboard

##### `src/uvm/sequences/`
This subdirectory contains the sequence item, base sequence, and sequence library

##### `src/uvm/tb/`
This subdirectory contains the testbench top and interface

##### `src/uvm/tests/`
This subdirectory contains the base test and test library

## Deliverables
The only deliverable for this onboarding is a working UVM testbench with at least a 96% DUT coverage score

If you have any issues or questions, feel free to reach out to Andrew Chen or Ethan Huang on Discord.
   
## Alternate (and probably better) Resources:
- Notes by Andrew: [here](https://docs.google.com/document/d/13cL66MN8yQ5Vs8Dwl6D2McG42TZfc3M4IRJPkBa-3QA/edit?usp=sharing)
- ChipVerify: [here](https://www.chipverify.com/uvm/)
- Verification Guide: [here](https://verificationguide.com/uvm/uvm-tutorial/)
- VLSI Verify: [here](https://vlsiverify.com/uvm/)
- ALU Verification With UVM (video): [here](https://www.youtube.com/watch?v=2026Ei1wGTU)
