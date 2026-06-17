# Mini CPU CI Project

SystemVerilog + Verilator + cocotb + GitHub Actions を用いて開発している
ミニCPUプロジェクト。

---

# Features

- 32-bit RISC風CPU
- 単一クロック構成
- Verilator シミュレーション
- cocotb テストベンチ
- GitHub Actions CI
- 将来的な FPGA 実装対応

---

# Current Instruction Support

| Instruction | Status |
|---|---|
| ADD | ✅ |
| SUB | ✅ |
| AND | ✅ |
| OR  | ✅ |
| ADDI | ✅ |
| LOAD (LW) | 🚧 |
| STORE (SW) | 🚧 |
| BEQ | Planned |

---

# Directory Structure

```text
mini-cpu-ci/
├── rtl/
│   ├── top.sv
│   └── core/
│       ├── alu.sv
│       ├── decoder.sv
│       ├── regfile.sv
│       └── data_mem.sv
│
├── tb/
│   └── cocotb/
│       └── test_top.py
│
├── sim/
│   └── Makefile
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
└── docs/
    └── isa.md
```

---

# Build & Simulation

## Verilator

```bash
cd sim
make
```

---

# Run cocotb Test

```bash
cd sim
make SIM=verilator
```

---

# Generate Waveform

```make
EXTRA_ARGS += --trace
```

GTKWave:

```bash
gtkwave dump.vcd
```

---

# GitHub Actions CI

本プロジェクトでは GitHub Actions を使用して
RTLの自動検証を実施。

実行内容:

- Verilator build
- cocotb test
- Smoke test
- CI regression

---

# CPU Architecture

```text
PC
 ↓
Instruction Memory
 ↓
Decoder
 ↓
Register File
 ↓
ALU
 ↓
Writeback MUX
 ↓
Register File
```

---

# Future Work

- LOAD/STORE 完成
- Branch (BEQ)
- Pipeline
- Hazard Control
- FPGA implementation (Tang Nano 9K)
- UART Debug
- CI Coverage

---

# ISA Specification

詳細な命令セット仕様:

- mini_cpu_isa_spec.pdf

## ISA Overview

### Register Architecture

- 32-bit CPU
- 32 General Purpose Registers (x0-x31)
- x0 is hardwired to zero
- Single-cycle execution model

### Supported Instruction Formats

#### R-Type

```text
[31:25] funct7
[24:20] rs2
[19:15] rs1
[14:12] funct3
[11:7 ] rd
[6 :0 ] opcode
```

#### I-Type

```text
[31:20] imm[11:0]
[19:15] rs1
[14:12] funct3
[11:7 ] rd
[6 :0 ] opcode
```

#### S-Type

```text
[31:25] imm[11:5]
[24:20] rs2
[19:15] rs1
[14:12] funct3
[11:7 ] imm[4:0]
[6 :0 ] opcode
```

### Supported Instructions

| Instruction    | Opcode  | Funct3  | Funct7               | Description |
|----------------|---------|---------|----------------------|-------------|
| ADD  | 0110011 | 000     | 0000000 | rd = rs1 + rs2       |
| SUB  | 0110011 | 000     | 0100000 | rd = rs1 - rs2       |
| AND  | 0110011 | 111     | 0000000 | rd = rs1 & rs2       |
| OR   | 0110011 | 110     | 0000000 | rd = rs1 \| rs2      |
| ADDI | 0010011 | 000     |    -    | rd = rs1 + imm       |
| LW   | 0000011 | 010     |    -    | rd = MEM[rs1 + imm]  |
| SW   | 0100011 | 010     |    -    | MEM[rs1 + imm] = rs2 |

### ALU Operations

| alu_op | Operation |
|--------|---|
| 0      | ADD |
| 1 | SUB |
| 2 | AND |
| 3 | OR |
| 7 | INVALID / RESERVED |

### Memory Access

Current implementation supports 32-bit word accesses only.

| Instruction | Width | Alignment |
|-------------|---------|---------|
| LW | 32-bit | Word aligned |
| SW | 32-bit | Word aligned |

Address calculation:

```text
address = rs1 + imm
```

Example memory indexing:

```text
mem[address[9:2]]
```

### Decoder Control Signals

| Signal | Description |
|---------|---------|
| reg_we | Register write enable |
| mem_we | Data memory write enable |
| mem_re | Data memory read enable |
| use_imm | Select immediate operand |
| mem_to_reg | Select memory data for writeback |
| alu_op | ALU operation select |

### Planned ISA Extensions

| Instruction | Status |
|-------------|---------|
| BEQ | Planned |
| JAL | Planned |
| JALR | Planned |
| XOR | Planned |
| SLL | Planned |
| SRL | Planned |
| SLT | Planned |

---

# Development Environment

- SystemVerilog
- Verilator
- cocotb
- Python 3
- GitHub Actions
- VSCode

---

# License

MIT License
