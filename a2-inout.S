#ifdef MACOS
    .global _my_inc
    printf: jmp _printf
    scanf: jmp _scanf
    #ifdef STANDALONE
        .global _main
    #endif
#else 
    .global my_inc
    _printf: jmp printf
    _scanf: jmp scanf
    #ifdef STANDALONE
        .global main
    #endif
#endif

.bss
# [unitialized static variables]

.data
# [initialized static variables]


.text
# [constants/strings]
int_fmt: 
    .asciz "%ld"                   # format string for printing an integer and a newline

input:
    .asciz "Enter a number: "

result:
    .asciz "The incremented number is: %ld"

_main:
main:
    pushq   %rbp                    # save previous base pointer
    movq    %rsp, %rbp              # set base pointer for new stack frame

    # leaq input(%rip), %rdi          # calling input to get a number
    # movb $0, %al                    # converting to 8-bit for proper printing/scanning
    # call printf                     # printing input from user
    # call scanf                      # scanning input from user 

    leaq    input(%rip), %rdi
    call    printf
    
    subq    $8, %rsp                # reserve space for value
    movq    %rsp, %rsi              # loading the address of rsp to rsi
    leaq    int_fmt(%rip), %rdi     # load address of reserved space as 2nd arg
    movb    $0, %al                 # 0 vector registers used
    subq    $8, %rsp                # fix stack alignment
    call    scanf                   # calling scanf to accept an input from the user
    addq    $8, %rsp                # undo the stack alignment fix 
    popq    %rax                    # pop result of scanf into rax

    movq    %rax, %rdi              # moving the value of rax to rdi to call it in my_inc
    call    my_inc                  # calling the subroutine my_inc

    leaq    result(%rip), %rdi      # putting address of result into rdi to print
    movq    %rax, %rsi              # moving the value of rax to rsi to print it
    movb    $0, %al                 # setting vector registers as 0 
    call    printf                  # calling printf to print result statement

    movq    $0,   %rax
    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret

# int64_t my_inc(int64_t n)
_my_inc:
my_inc:
    pushq   %rbp        # save previous base pointer
    movq    %rsp, %rbp  # set base pointer for new stack frame

    incq    %rdi        # increasing the value of the argument by one
    movq    %rdi, %rax  # moving the value of rdi to rax

    movq    %rbp, %rsp  # reset stack pointer to bottom
    popq    %rbp        # restore previous base pointer
    ret