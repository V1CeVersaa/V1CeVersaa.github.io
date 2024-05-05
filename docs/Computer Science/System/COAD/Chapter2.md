# Instructions: Language of the Computer

使用移位指令与 `lw` 实现 `lbu` 指令。

```asm
# lbu using lw: lbu s1, 1(s0)
lw      s1, 0(s0)       # load word
li      t0, 0x0000FF00  # load bitmask
and     s1, s1, t0      # get target byte
srli    s1, s1, 8       # shift right
```

使用移位指令与 `sw` 实现 `sb` 指令。

```asm
# sb using sw: sb s1, 3(s0)
lw      t0, 0(s0)       # load current word
li      t1, 0x00FFFFFF  # load bitmask
and     t0, t0, t1      # zero top byte
slli    t1, s1, 24      # little-endian & shift left
or      t0, t0, t1      # combine
sw      s1, 0(s0)       # store
```

```C
while ((*q++ = *p++) != '\0') ;
```

```asm
# copy String p to q
# p -> s0, q -> s1
loop:
    lb      t0, 0(s0)       # load byte
    sb      t0, 0(s1)       # store byte
    addi    s0, s0, 1       # increment p
    addi    s1, s1, 1       # increment q
    bne     t0, x0, loop    # loop if not null
    j       exit            # exit if null
```

## Function Calls

Six steps of calling a function:

- Put arguments in a place where the function can access them.
- Transfer control to the function.
- The function will acquire any (local) storage it needs.
- The function performs its task.
- The function puts the return value in an accessible place and cleans up.
- Transfer back the control to the caller.

Arguments registers:

- `a0` to `a7` for arguments.
- `a0` and `a1` for return values.
- `sp` for the stack pointer, holding the current memory address of the bottom of the stack.
- Order of arguments matters.
- If need extra arguments, use the stack.

Example:

```C
void main(void) {
    int a = 3;
    int b = a + 1;
    a = add(a, b);
}

int add(int x, int y) {
    return x + y;
}
```

```asm
main:
    addi a0, x0, 3
    addi a1, a0, 1
    jal  ra, add
add:
    add  a0, a0, a1
    jr   ra
```

## local Storage for variables

Stack Pointer `sp` holds the address of the bottom of the stack.

- Decrement it (stack grows downwards), and use `sw` to write to a variable.
- To clean up, just increment the stack pointer.

```asm
# store t0 to the stack
addi sp, sp, -4  # allocate space
sw   t0, sp      # store t0
addi sp, sp, 4   # clean up
```








