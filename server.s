.intel_syntax noprefix
.globl _start

.include "./constants.s"

.section .text

make_socket:
    mov rdi, AF_INET 
    mov rsi, SOCK_STREAM 
    mov rdx, IPPROTO_IP
    mov rax, SYS_socket
    syscall
    ret

_start:
    call make_socket
    cmp rax, -1
    jne socket_fail
    jmp exit_success
socket_fail: 
    jmp exit_failure


exit_success: 
    mov rdi, 0
    mov rax, SYS_exit
    syscall

exit_failure: 
    lea rdi, [rip+socket_error_str]
    mov rsi, STDERR
    call print_string
    mov rdi, -1
    mov rax, SYS_exit
    syscall


// @rdi String to print 
// @rsi file descriptor to write to
print_string:
    push rbp 
    mov rbp, rsp
    sub rsp, 0x10 
    mov QWORD PTR [rbp-0x8], rdi    # string 
    mov QWORD PTR [rbp-0x10], rsi   # file descriptor
    mov rdx, rdi
not_null:
    cmp BYTE PTR [rdx], 0    # check if current char NULL
    je null_found 
    inc rdx                  # inc string pointer and repeat check
    jmp not_null            
null_found:
    sub rdx, rdi             # string_end - string_start = length
    mov rsi, rdi 
    mov rdi, [rbp-0x10] 
    mov rax, SYS_write
    syscall
    leave
    ret




.section .data
socket_error_str:
    .ascii "[!] Unable to create socket\n"
