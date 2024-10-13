    .intel_syntax noprefix
    .global _start

    .include "./constants.s"

    # short macro to create stack's with size of size
    .macro stack_frame size 
    push rbp 
    mov rbp, rsp 
    sub rsp, \size 
    .endm

    .section .text

_start:
    stack_frame 0x8
    call make_socket
    cmp rax, -1                # checks return of socket syscall
    jle socket_fail
    mov [rbp-0x8], rax         # sve socket descriptor 
    mov rdi, rax
    call bind_socket
    cmp rax, -1                # checks return of bind syscall
    jle bind_fail
    mov rdi, [rbp-0x8]
    mov rsi, 0                 # backlog = 0
    call socket_listen
    cmp rax, -1                # checks return of listen syscall
    jle listen_fail
    mov rdi, [rbp-0x8]
    call socket_accept 
    cmp rax, -1                # checks return of listen syscall
    jle socket_fail

    mov rdi, rax 
    call read_request

    jmp exit_success

/*
    read_request - Reads an HTTP request header from a socket, sends an HTTP 200 OK response, and closes the connection.

    Parameters:
        @rdi(u64): Socket file descriptor

    Stack Frame:
        =========RSP=========
        [rsp] Buffer: Temporary buffer to store the HTTP request line (size: REQUEST_LINE_SIZE = 0x300)
        [rsp+REQUEST_LINE_SIZE] Buffer: File path read in 
        [rbp-0x18]   int:File descriptor
        [rbp-0x10]   char*:Start of get path
        [rbp-0x8]   u64: @rdi 
        =========RBP=========
*/

read_request:
    .equ REQUEST_LINE_SIZE, 0x300
    .equ REQUESTS_SIZE,  REQUEST_LINE_SIZE * 2
    stack_frame   REQUESTS_SIZE+ 0x18
    mov [rbp-8], rdi           # socket descriptor 
    mov rdx, REQUEST_LINE_SIZE
    lea rsi, [rsp]        # read onto stack buffer
    mov rdi, [rbp-0x8]
    mov rax, SYS_read            # read http request header
    syscall

    # Find the first space to get file path 
    mov rsi, ' '
    lea rdi, [rsp]        # read onto stack buffer
    call strchr

    inc rax                  # currently at character, inc rax
    mov [rbp-0x10], rax

    mov rdi, rax
    mov rsi, ' '
    call strchr
    # Null out string 
    mov BYTE PTR [rax], 0 

    mov rdi, [rbp-0x10]
    mov rsi, O_RDONLY
    mov rdx, 0
    mov rax, SYS_open
    syscall

    mov [rbp-0x18], rax                # file path descriptor 
    mov rdi, rax 
    lea rsi, [rsp+REQUEST_LINE_SIZE]
    mov rdx, REQUEST_LINE_SIZE
    mov rax, SYS_read                  # read in file contents
    syscall

    mov rdi, [rbp-0x18]                 
    mov rax, SYS_close                 # close file descriptor
    syscall      


    # parse request for string name, find start + insert NULL at end 
    lea rsi, [rip+http_200_response]
    mov rdi, rsi 
    call strlen                         # get length of http_200_response
    mov rdx, rax
    mov rdi, [rbp-0x8]                  # socket descriptor 
    mov rax, SYS_write                  # write HTTP response
    syscall

    lea rsi, [rsp+REQUEST_LINE_SIZE]
    mov rdi, rsi 
    call strlen                         # get length of text file 
    mov rdx, rax
    mov rdi, [rbp-0x8]                  # socket descriptor 
    mov rax, SYS_write                  # write HTTP response
    syscall


    mov rdi, [rbp-0x8]         # socket descriptor 
    mov rax, SYS_close         # close socket descriptor
    syscall
    leave
    ret

socket_fail: 
    lea rdi, [rip+socket_error_msg]  # print socket error message
    call perror 
    jmp exit_failure

bind_fail: 
    lea rdi, [rip+bind_error_msg]  # print socket error message
    call perror 
    jmp exit_failure

listen_fail: 
    lea rdi, [rip+listen_error_msg]  # print socket error message
    call perror 
    jmp exit_failure

accept_fail: 
    lea rdi, [rip+accept_error_msg]  # print socket error message
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
    mov QWORD PTR [rbp-0x8], rdi         # socket descriptor 

    mov WORD PTR [rsp+0x2], 80           # sin_port 
    lea rdi, [rsp+0x2]                   # swap sin_port
    mov rsi, 2
    call swap_endian                     # htons bullshit

    mov DWORD PTR [rsp+0x4], 0x00000000     # in_addr
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


# Listening on socket set's value as passive socket and can be used to accept connections
socket_listen:
    mov rdi, rdi 
    mov rax, SYS_listen 
    syscall
    ret

/*
    socket_accept - Accepts a connection on a socket and binds it to a local address.
    
    Parameters:
        @rdi(u64): Socket file descriptor (socket_fd).
    
    PC Does NOT want sockaddr or addrlen but we keeping it for now
    Stack Frame:
        =========RSP=========
        struct sockaddr_in {              // Structure to hold the local address
            short sin_family;             // Address family (e.g., AF_INET) - 2 bytes
            unsigned short sin_port;      // Port number in network byte order - 2 bytes
            struct in_addr {              
                unsigned long s_addr;     // IP address (4 bytes, typically set with inet_pton)
            };
            char sin_zero[8];             // Padding to match the sockaddr structure - 8 bytes
        } sockaddr_in;
        
        u64 * addrlen                     // Length of the sockaddr_in structure
        u64 @rdi 
        =========RBP=========
    
*/
socket_accept:
    stack_frame 0x20
    mov QWORD PTR [rbp-0x8], rdi 
    mov QWORD PTR [rbp-0x10], 0x10 # addrlen = sizeof(sockaddr_in)
    mov rdi, [rbp-0x8]             # socket_fd
    mov rsi, rsp                   # sockaddr_in
    lea rdx, [rsi-0x10]            # &addrlen 
    mov rsi, 0
    mov rdx, 0
    mov rax, SYS_accept 
    syscall
    leave 
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

/* 
    Writes a null-terminated string to a specified file descriptor.
    Parameters:
        @rdi(char *): Address of the null-terminated string
        @rsi(u64): File descriptor to write to

    Stack Frame:
        =========RSP=========
        [rbp-0x10] u64: @rsi 
        [rbp-0x8]  char *: @rdi
        =========RBP=========
*/
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

/* 
    memcpy - Copies `size` bytes from the source buffer to the destination buffer.
    
    Parameters:
        @rdi(void *): Destination buffer pointer where bytes are copied to.
        @rsi(void *): Source buffer pointer from which bytes are copied.
        @rdx(u64): Number of bytes to copy from source to destination.
    
    Stack Frame:
        =========RSP=========
        [rbp-0x18]  u64: @rdx
        [rbp-0x10]  void *: @rsi 
        [rbp-0x8]   void *: @rdi 
        =========RBP=========
*/    
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

/*
    strlen - Calculates the length of a null-terminated string (like the C `strlen` function).

    Parameters:
        @rdi(void *): Pointer to the null-terminated string.

    Stack Frame:
        =========RSP=========
        [rbp-0x8]   char *: @rdi 
        =========RBP=========
*/
strlen:
    stack_frame 0x10 
    mov QWORD PTR [rbp-0x8], rdi    # string
    mov rax, rdi
    strlen_continue:
        cmp BYTE PTR [rax], 0    # check if current char NULL
        je strlen_found
        inc rax                  # inc string pointer and repeat check
        jmp strlen_continue 
    strlen_found:
        sub rax, rdi             # count = string_end - string_start
        leave
        ret

/*
    strchr- Searches for the first occurrence of a character in a null-terminated string.

    Parameters:
        @rdi(void *): Pointer to the null-terminated string.
        @rsi(u8 char): Character to search 
    Stack Frame:
        =========RSP=========
        [rbp-0x10]   char : @rsi 
        [rbp-0x8]   char *: @rdi 
        =========RBP=========
*/
strchr:
    stack_frame 0x10
    mov QWORD PTR [rbp-0x8], rdi    # string
    mov QWORD PTR [rbp-0x10], rsi    # character to search
    mov rax, rdi
    strchr_continue:
        cmp BYTE PTR [rax], sil    # check if current char NULL
        je strchr_found
        inc rax                  # inc string pointer and repeat check
        jmp strchr_continue 
    strchr_found:
        leave
        ret
/* 
    swap_endian - Reverses the byte order (endianess) of a buffer.
    
    Parameters:
        @rdi(void *): Pointer to the buffer to swap (up to 64-bit in size).
        @rsi(u64): Size of the buffer (only supports up to 64-bit integers).
    
    Stack Frame:
        =========RSP=========
        [rbp-0x18]  Buffer copy for temporary storage (used for endianness swap)
        [rbp-0x10]  u64:  @rsi
        [rbp-0x8]   void *: @rdi
        =========RBP=========
*/
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

    # cp from buffer_clone[-i] to buffer[i]
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
bind_error_msg:
    .ascii "[!] Unable to bind to socket\n"
listen_error_msg:
    .ascii "[!] Unable to listen to socket\n"
accept_error_msg:
    .ascii "[!] Unable to accept connection\n"
http_200_response:
    .ascii "HTTP/1.0 200 OK\r\n\r\n"
