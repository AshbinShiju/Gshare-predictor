# Gshare Branch Predictor with BTB

This repository contains a Register Transfer Level (RTL) implementation of a **Gshare Branch Predictor** integrated with a **Branch Target Buffer (BTB)**. Designed in Verilog, this module predicts branch directions and target addresses to minimize control hazards in pipelined processors.

## 📂 File Structure

* **`GHR.v`**: The main design module containing the GHR, PHT, and BTB logic.
* **`GHR_tb.v`**: The testbench used to verify initialization, hashing, prediction, and table updates.

## ⚙️ Features

* **Algorithm**: Gshare (Global History Sharing).
    * Uses an XOR hash of the **Program Counter (PC)** and the **Global History Register** to index the Pattern History Table.
* **Pattern History Table (PHT)**:
    * 128 entries.
    * 2-bit saturating counters for strong/weak Taken/Not-Taken prediction.
* **Branch Target Buffer (BTB)**:
    * 128 entries.
    * Structure: Valid Bit (1) | Tag (24) | Target Address (32).
* **Global History**:
    * 7-bit shifting history register (`gout`).

## 🔌 Interface Signal Description

| Signal Name | Width | Direction | Description |
| :--- | :---: | :---: | :--- |
| `clk` | 1 | Input | System Clock. |
| `rst` | 1 | Input | Active High Reset. Clears PHT, BTB, and GHR. |
| `gin` | 1 | Input | **Global Input**: The actual outcome of the branch (for update). |
| `branch` | 1 | Input | **Branch Enable**: Asserted when the current instruction is a branch. |
| `instruction` | 32 | Input | Current Program Counter (PC) / Instruction Address. |
| `target` | 32 | Input | Calculated target address (used for updating BTB). |
| `tag` | 24 | Input | Upper bits of PC used for BTB tag comparison. |
| `nnt` | 1 | Output | **Next prediction**: 1 if Taken, 0 if Not Taken. |
| `target_addr` | 32 | Output | Predicted target address. Outputs `target_store` on hit, else `PC+4`. |
| `hit` | 1 | Output | **BTB Hit**: Indicates if the instruction was found in the BTB. |

## 🛠️ Design Details

### Indexing Mechanism
The design uses a 7-bit index derived from the XOR operation of the instruction address and the global history register:
```verilog
hash = instr[6:0] ^ gout;
