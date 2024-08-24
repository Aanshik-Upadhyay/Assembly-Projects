#ifdef MACOS
    .global _my_pow
    printf: jmp _printf
    scanf: jmp _scanf
    #ifdef STANDALONE
        .global _main
    #endif
#else 
    .global my_pow
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
    .asciz "%ld"

uint_fmt:
    .asciz "%lu"

input1:
    .asciz "Enter a base: "

input2:
    .asciz "Enter an exponent: "

result:
    .asciz "%ld^%lu = %ld"


_main:
main:
    pushq   %rbp                    # save previous base pointer
    movq    %rsp, %rbp              # set base pointer for new stack frame
    
    leaq    input1(%rip), %rdi
    call    printf                  # printing the input message
    subq    $16, %rsp               # reserving space for both base and exponent (doesn't misalign the stack ~ 16)
    leaq    int_fmt(%rip), %rdi     # load address of asci string as 1st arg (rdi)
    leaq    -8(%rbp), %rsi          # loading the first address as 2nd arg (rsi)
    movb    $0, %al                   # 0 vector registers used
    call    scanf                   # calling scanf to accept the base from the user 

    leaq    input2(%rip), %rdi
    call    printf                  # printing the input message
    leaq    uint_fmt(%rip), %rdi    # load address of asci string as 1st arg (rdi)
    leaq    -16(%rbp), %rsi         # loading the second address as 2nd arg (rsi)
    movb    $0, %al                 # 0 vector registers used
    call    scanf                   # calling scanf again to accept the exponent from user
    pop     %rsi                    # popping the value of exponent into rsi
    pop     %rdi                    # popping the value of base into rdi 
    

    call    my_pow

    movq    %rdi, %rsi              # move the value of rdi to rsi (rdi currently has the base and it needs to be cleared for the printf)
    leaq    result(%rip), %rdi      # load the address of result statement into rdi
    movq    %rcx, %rdx              # rcx stores the exponent which is convinient coz rsi loses the value above
    movq    %rax, %rcx              # move the final result stored in rax to rcx (4th arg) now that we used rcx
    movb    $0, %al
    call    printf
    
    movq    $0,   %rax
    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret

# int64_t my_pow(int64_t base, uint64_t exponent)
_my_pow:
my_pow:
    pushq   %rbp                    # save previous base pointer
    movq    %rsp, %rbp              # set base pointer for new stack frame

    movq    $0, %rcx                # set the loop counter to 0
    movq    $1, %rax                # set the rax (which is where I am storing the result) to 1

loop:
    cmpq    %rsi, %rcx              # compare the exponent(rsi) to loop counter(rcx) at each iteration
    jge     end                     # jump to end if greater or equal
    
    imulq   %rdi, %rax              # multiply rdi(base) to rax(result)
    incq    %rcx                    # increase the loop counter by 1 at each iteration

    jmp     loop                    # restart the loop (sorta like a continue statement)
end:

    movq    %rbp, %rsp              # reset stack pointer (-> reset stack)
    popq    %rbp                    # restore previous base pointer
    ret