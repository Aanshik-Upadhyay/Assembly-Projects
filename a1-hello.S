#ifdef MACOS
    .global _main
    printf: jmp _printf
#else 
    .global main
    _printf: jmp printf
#endif

.bss
# [unitialized static variables]

.data
# [initialized static variables]


.text
hello:
    .asciz "Computer Organization 2024\nAssignment 1 - hello \nby: Aanshik and Ronnit\n"

_main:
main:
    pushq   %rbp                    # save previous base pointer
    movq    %rsp, %rbp              # set base pointer for new stack frame

    leaq hello(%rip), %rdi          # load the address of our asci string into rdi register
    movb $0, %al                    # specify vector registers to 0
    call printf                     # call the printf function

    movq $0, %rax                   # load 0 into the rax register to return 0
    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret