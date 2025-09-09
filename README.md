# A VERY Brief Introduction to UVM
UVM Onboarding For DV Members
## Setup
Add the following to `.my-cshrc`:
```zsh
source /tools/software/cadence/setup.csh
setenv UVMHOME /tools/software/cadence/xcelium/latest/tools/methodology/UVM/CDNS-1.1d
```
## Onboarding Tasks
In this onboarding, you will learn a high-level overview of UVM. Due to the compressed nature of this onboarding, we cannot go over 100% of the library. In each chapter, there **will** be inline links. It is imperative for you to click on them and read them to have a complete understanding. We also assume that you have some idea of what OOP is. If not, please read up on it.

In this project, you will:
1. Write different sequences (by extending the base sequence) for different test cases.
3. Create the driver, monitor, and sequencer.
4. Instantiate the driver, monitor, and sequencer in an agent.
5. Write the scoreboard.
6. Instantiate the agent and scoreboard in the environment.
7. Write different tests to run the different sequences.
8. Debug the faulty RTL.
9. Get 96% code coverage.
   
Don't worry if a lot of words here make no sense. In the following chapters,  we will address all of them.

REFER [HERE](https://github.gatech.edu/SiliconJackets/uvm_onboarding/blob/main/EXAMPLE.md) to learn via an example.
## Alternate (and probably better) Resources:
- Notes by Andrew: [here](https://docs.google.com/document/d/13cL66MN8yQ5Vs8Dwl6D2McG42TZfc3M4IRJPkBa-3QA/edit?usp=sharing)
- ChipVerify: [here](https://www.chipverify.com/uvm/)
- Verification Guide: [here](https://verificationguide.com/uvm/uvm-tutorial/)
- VLSI Verify: [here](https://vlsiverify.com/uvm/)
- ALU Verification With UVM (video): [here](https://www.youtube.com/watch?v=2026Ei1wGTU)
