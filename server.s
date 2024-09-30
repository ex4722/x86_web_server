.intel_syntax noprefix
.globl _start

.include "./constants.s"

# short macro to create stack's with size of size
.macro stack_frame size 
    push rbp 
    mov rbp, rsp 
    sub rsp, \size 
.endm

.section .text

_start:
    call make_socket
    cmp rax, -1
    je socket_fail
    mov rdi, rax
    call bind_socket
    jmp exit_success
socket_fail: 
    lea rdi, [rip+socket_error_msg]  # print socket error message
    call perror 
    jmp exit_failure

exit_success: 
    mov rdi, 0
    mov rax, SYS_exit
    syscall

exit_failure: 
    mov rdi, -1
    mov rax, SYS_exit
    syscall

/* 
Binds a socket to a local address 
Parameters: 
    @rdi(u64): socket descriptor
Stack Frame:
    =========RSP=========
    struct sockaddr_in {
        short            sin_family;   // e.g. AF_INET, AF_INET6     2 BYTES
        unsigned short   sin_port;     // e.g. htons(3490)           2 BYTES
        struct in_addr {
            unsigned long s_addr;          // load with inet_pton()  4 BYTES
        };
        char             sin_zero[8];  // zero this if you want to
    };
    u64 @rdi 
    =========RBP=========
*/
bind_socket: 
    stack_frame 0x18
    mov WORD PTR [rsp], AF_INET          # sin_family
    mov QWORD PTR [rbp-0x8], rdi        # socket descriptor 

    mov WORD PTR [rsp+0x2], 1337 # sin_port 
    lea rdi, [rsp+0x2]                   # swap sin_port
    mov rsi, 2
    call swap_endian                     # hton bullshit

    mov DWORD PTR [rsp+0x4], 0xff000     # in_addr
    mov QWORD PTR [rsp+0x8], 0x10        # sin_zero
    mov rsi, rsp                         # sockaddr_in structure
    mov rdx, 0x10                        # sizeof(sockaddr_in)
    mov rdi, [rbp-0x8]
    mov rax, SYS_bind 
    syscall 
    leave
    ret

make_socket:
    mov rdi, AF_INET 
    mov rsi, SOCK_STREAM 
    mov rdx, IPPROTO_IP
    mov rax, SYS_socket
    syscall
    ret

# Prints string to stdout
puts:
    mov rsi, STDOUT
    call print_string
    ret

# Prints string to stderror 
perror:
    mov rsi, STDERR
    call print_string
    ret

# @rdi string to print 
# @rsi File descriptor to write to
print_string:
    stack_frame 0x10 
    mov QWORD PTR [rbp-0x8], rdi    # string 
    mov QWORD PTR [rbp-0x10], rsi   # file descriptor
    mov rdx, rdi
not_null:
    cmp BYTE PTR [rdx], 0    # check if current char NULL
    je null_found 
    inc rdx                  # inc string pointer and repeat check
    jmp not_null            
null_found:
    sub rdx, rdi             # count = string_end - string_start
    mov rsi, rdi             # buffer
    mov rdi, [rbp-0x10]      # file descriptor
    mov rax, SYS_write
    syscall
    leave
    ret

# @rdi void * dest 
# @rsi  void * src 
# @rdx size 
memcpy:
    stack_frame 0x18
    mov QWORD PTR [rbp-0x8], rdi     # void * to dest 
    mov QWORD PTR [rbp-0x10], rsi    # void * to src 
    mov QWORD PTR [rbp-0x18], rdx    # int size 
    mov r11, 0                       # iterator
    continue_copying:
        cmp r11, [rbp-0x18]          # while i < size
        jge memcpy_done 
        mov al, BYTE PTR [rsi]
        mov BYTE PTR [rdi], al
        inc rdi                      # inc dest
        inc rsi                      # inc src 
        inc r11                      # inc counter
        jmp continue_copying
    memcpy_done:
        mov rax,  QWORD PTR [rbp-0x8] # return dest
        leave
        ret


# @rdi void * to buffer to swap 
# @rsi size of buffer(Only supports up to 64 bit int)
swap_endian:
    stack_frame 0x18
    mov QWORD PTR [rbp-0x8], rdi     # void * to buffer
    mov QWORD PTR [rbp-0x10], rsi    # size of buffer
    # copy from buffer to stack
    lea rdi, [rbp-0x18]
    mov rsi, [rbp-0x8]
    mov rdx, [rbp-0x10]
    call memcpy

    # copy our buffer to target buffer backwards
    mov r11, 0                      # iterator
    mov rdi, [rbp-0x8]              # buffer
    lea rsi, [rbp-0x18]             # stack buffer copy
    add rsi, [rbp-0x10]             # point to end of stack buffer copy
    dec rsi

continue_swap_endian:
    cmp r11, [rbp-0x10]
    jge swap_endian_done

    mov al, BYTE PTR [rsi]
    mov BYTE PTR [rdi], al
    inc rdi 
    inc r11 
    dec rsi
    jmp continue_swap_endian

    swap_endian_done:
        leave
        ret


.section .data
socket_error_msg:
    .ascii "[!] Unable to create socket\n"
