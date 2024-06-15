# Supplement

## Addressing

- Immediate Addressing: The operand directly contains the value we need. `ADDI R1, R2, #100` reads the value of R2, adds 100 to it, and stores the result in R1.
- Direct Addressing: The operand contains the address of the value we need. `LDR R1, 100` reads the value at memory address 100 and stores it in R1.
- Indirect Addressing: The operand contains an address, which contains the address of the value we need. `LDR R1, (100)` the data at the memory location `100` is an address, and we uses the address to read the value.
- Register Direct Addressing: 
