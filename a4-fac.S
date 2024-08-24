#ifdef MACOS
    .global _my_factorial
    printf: jmp _printf
    scanf: jmp _scanf
    #ifdef STANDALONE
        .global _main
    #endif
#else 
    .global my_factorial
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
uint_fmt:
    .asciz "%lu"

input_msg:
    .asciz "Enter a number: "

output_msg:
    .asciz "%lu! = %lu"

_main:
main:
    pushq   %rbp                    # save previous base pointer
    movq    %rsp, %rbp              # set base pointer for new stack frame
    
    leaq    input_msg(%rip), %rdi   # load address of input msg as 1st arg (rdi)
    call    printf                  # printing the input message
    subq    $16, %rsp               # reserving space for input (doesn't misalign the stack ~ 16)
    leaq    uint_fmt(%rip), %rdi    # load address of asci string as 1st arg (rdi)
    leaq    -8(%rbp), %rsi          # loading the first address as 2nd arg (rsi)
    movb    $0, %al                 # 0 vector registers used
    call    scanf                   # calling scanf to accept the input from the user 
    addq    $8, %rsp                # since we used 8 bytes, we must add the other 8 to remove the misalignment
    pop     %rdi                    # popping the value of input into rdi

    call my_factorial

    # Printing the factorial
    movq    %rdi, %rsi              # since rdi stores the last popped value (initial input)
    movq    %rax, %rdx              # since rax stores the value of factorial
    leaq output_msg(%rip), %rdi     # load address of output msg as 1st arg (rdi) 
    movb    $0, %al                 # 0 vector registers used
    call    printf                  # calling printf to print the output message

    movq    $0,   %rax              # returning 0
    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret


# uint64_t my_factorial(uint64_t n)
_my_factorial:
my_factorial:
    pushq   %rbp                    # save previous base pointer
    movq    %rsp, %rbp              # set base pointer for new stack frame
    
    movq    $1, %rax                # set initial value of rax to 1 
    cmpq    $1, %rdi                # compare 1 to rdi on each iteration
    je      end                      # if rdi <= 1, jump to end
    jl      zero

    pushq   %rdi                    # save rdi
    decq    %rdi                    # decrement rdi
    call    my_factorial            # call my_factorial
    popq    %rdi                    # restore rdi

end:
    imulq   %rdi, %rax              # multiply rax by rdi
    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret                             # return the result

zero:
    movq    $1, %rax
    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret                             # return the result