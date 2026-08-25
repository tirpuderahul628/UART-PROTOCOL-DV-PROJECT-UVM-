# UART Design & Verification (UVM)

A lightweight UVM verification environment and RTL design for a configurable UART core.

* **Simulation:** [Run on EDA Playground](https://www.edaplayground.com/x/QcdY)
* **Tutorial:** [Watch on YouTube](https://www.youtube.com/watch?v=rATLXIjYofw&t=1810s)

---

## Features
* **Baud Rates:** Configurable (9600 to 115200 bps)
* **Sampling:** 16x RX oversampling with mid-bit detection
* **Frame Formats:** 5 to 8-bit data length, optional parity (Even/Odd), 1 or 2 stop bits

---

## Test Cases Passed (10/10)

| Sequence | Description | Status |
|---|---|:---:|
| `rand_baud_seq.sv` | 8-bit data, 1 stop bit, random baud | PASSED |
| `rand_baud_with_stop_seq.sv` | 8-bit data, 2 stop bits, random baud | PASSED |
| `rand_baud_len5p_seq.sv` | 5-bit data with parity, random baud | PASSED |
| `rand_baud_len6p_seq.sv` | 6-bit data with parity, random baud | PASSED |
| `rand_baud_len7p_seq.sv` | 7-bit data with parity, random baud | PASSED |
| `rand_baud_len8p_seq.sv` | 8-bit data with parity, random baud | PASSED |
| `rand_baud_len5_seq.sv` | 5-bit data without parity, random baud | PASSED |
| `rand_baud_len6_seq.sv` | 6-bit data without parity, random baud | PASSED |
| `rand_baud_len7_seq.sv` | 7-bit data without parity, random baud | PASSED |
| `rand_baud_len8_seq.sv` | 8-bit data without parity, random baud | PASSED |

---

## File Structure

```text
├── tb_top.sv            # Testbench top wrapper
├── rtl/                 # UART RTL modules (TX, RX, Clock Gen, Top)
├── env/                 # UVM Environment (Agent, Driver, Monitor, Scoreboard, Interface)
└── sequences/           # Verification sequence files