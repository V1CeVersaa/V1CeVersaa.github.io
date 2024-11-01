# ZJU System II

!!! Info 
    教室在课程教室，可能教室还会调。
    
    Labs: Monday 2:15-5:00 pm

## Lec 1 

Course Topics:

1. Instruction Classification and Design Principle (1.5 weeks)
2. Concept, Category, Architecture and Design of Pipeline CPU (1.5 weeks)
3. Hazard of Pipeline CPU (2 weeks)
4. Software/Hardware Interfaces (1 week)

Instruction Set Principles:

ISA Classifications Basis: 

- Stack Architecture: 
    - Implicit Operands - on the Top Of the Stack(TOS). 
    - For operation `Add`, both operands are removed from the stack, then perform the operation with the operands, store the result to the stack.
    - Easy to operate: Implement `C = A + B`: 
    ```plaintext
    Push A          # A for element stored in address A
    Push B          
    Add             # Pop all, load to ALU and push the result to the stack
    Pop  C
    ``` 
- Accumulator Architecture:
    - One implicit operand: The accumulator.
    - One explicit openand: Memory location.
    - Instruction set: `add A`, `sub A`, `mult A`, `div A`, `store A`, `load A` ... 
    - Implement `C = A + B`:
    ```plaintext
    Load  A
    Add   B          # Implicitly specify the operand Accumulator Register
    Store C
    ```
- General Purpose Register Architecture (Register Memory Arch):
    - Only explicit operands: Registers and Memory Locations.
    - Operand access: 
- General Purpose Register Archtecture (Load-Store Arch) (RISC-V):
    - Only load and store instructions can access memory.

GPR Classification:

- 