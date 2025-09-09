# A VERY Brief Introduction to UVM
UVM Onboarding For DV Members
## Alternate (and probably better) Resources:
- Notes by Andrew: [here](https://docs.google.com/document/d/13cL66MN8yQ5Vs8Dwl6D2McG42TZfc3M4IRJPkBa-3QA/edit?usp=sharing)
- ChipVerify: [here](https://www.chipverify.com/uvm/)
- Verification Guide: [here](https://verificationguide.com/uvm/uvm-tutorial/)
- VLSI Verify: [here](https://vlsiverify.com/uvm/)
- ALU Verification With UVM (video): [here](https://www.youtube.com/watch?v=2026Ei1wGTU)
## Setup
Add the following to `.my-cshrc`:
```zsh
source /tools/software/cadence/setup.csh
setenv UVMHOME /tools/software/cadence/xcelium/latest/tools/methodology/UVM/CDNS-1.1d
```
## Onboarding Tasks
In this onboarding, you will learn a high-level overview of UVM. Due to the compressed nature of this onboarding, we cannot go over 100% of the library. In this project, you will:
1. Extend the base sequence item class.
2. Write the structure of a sequencer.
3. Write the components of the driver, monitor, sequencer, and scoreboard.
4. Instantiate the stuff you wrote in an UVM agent.
5. Debug the faulty RTL.
6. Get 96% code coverage.
