// Linux x86 syscall numbers
.equ SYS_read, 0
.equ SYS_write, 1
.equ SYS_open, 2
.equ SYS_close, 3
.equ SYS_stat, 4
.equ SYS_fstat, 5
.equ SYS_lstat, 6
.equ SYS_poll, 7
.equ SYS_lseek, 8
.equ SYS_mmap, 9
.equ SYS_mprotect, 10
.equ SYS_munmap, 11
.equ SYS_brk, 12
.equ SYS_rt_sigaction, 13
.equ SYS_rt_sigprocmask, 14
.equ SYS_rt_sigreturn, 15
.equ SYS_ioctl, 16
.equ SYS_pread64, 17
.equ SYS_pwrite64, 18
.equ SYS_readv, 19
.equ SYS_writev, 20
.equ SYS_access, 21
.equ SYS_pipe, 22
.equ SYS_select, 23
.equ SYS_sched_yield, 24
.equ SYS_mremap, 25
.equ SYS_msync, 26
.equ SYS_mincore, 27
.equ SYS_madvise, 28
.equ SYS_shmget, 29
.equ SYS_shmat, 30
.equ SYS_shmctl, 31
.equ SYS_dup, 32
.equ SYS_dup2, 33
.equ SYS_pause, 34
.equ SYS_nanosleep, 35
.equ SYS_getitimer, 36
.equ SYS_alarm, 37
.equ SYS_setitimer, 38
.equ SYS_getpid, 39
.equ SYS_sendfile, 40
.equ SYS_socket, 41
.equ SYS_connect, 42
.equ SYS_accept, 43
.equ SYS_sendto, 44
.equ SYS_recvfrom, 45
.equ SYS_sendmsg, 46
.equ SYS_recvmsg, 47
.equ SYS_shutdown, 48
.equ SYS_bind, 49
.equ SYS_listen, 50
.equ SYS_getsockname, 51
.equ SYS_getpeername, 52
.equ SYS_socketpair, 53
.equ SYS_setsockopt, 54
.equ SYS_getsockopt, 55
.equ SYS_clone, 56
.equ SYS_fork, 57
.equ SYS_vfork, 58
.equ SYS_execve, 59
.equ SYS_exit, 60
.equ SYS_wait4, 61
.equ SYS_kill, 62
.equ SYS_uname, 63
.equ SYS_semget, 64
.equ SYS_semop, 65
.equ SYS_semctl, 66
.equ SYS_shmdt, 67
.equ SYS_msgget, 68
.equ SYS_msgsnd, 69
.equ SYS_msgrcv, 70
.equ SYS_msgctl, 71
.equ SYS_fcntl, 72
.equ SYS_flock, 73
.equ SYS_fsync, 74
.equ SYS_fdatasync, 75
.equ SYS_truncate, 76
.equ SYS_ftruncate, 77
.equ SYS_getdents, 78
.equ SYS_getcwd, 79
.equ SYS_chdir, 80
.equ SYS_fchdir, 81
.equ SYS_rename, 82
.equ SYS_mkdir, 83
.equ SYS_rmdir, 84
.equ SYS_creat, 85
.equ SYS_link, 86
.equ SYS_unlink, 87
.equ SYS_symlink, 88
.equ SYS_readlink, 89
.equ SYS_chmod, 90
.equ SYS_fchmod, 91
.equ SYS_chown, 92
.equ SYS_fchown, 93
.equ SYS_lchown, 94
.equ SYS_umask, 95
.equ SYS_gettimeofday, 96
.equ SYS_getrlimit, 97
.equ SYS_getrusage, 98
.equ SYS_SYSinfo, 99
.equ SYS_times, 100
.equ SYS_ptrace, 101
.equ SYS_getuid, 102
.equ SYS_SYSlog, 103
.equ SYS_getgid, 104
.equ SYS_setuid, 105
.equ SYS_setgid, 106
.equ SYS_geteuid, 107
.equ SYS_getegid, 108
.equ SYS_setpgid, 109
.equ SYS_getppid, 110
.equ SYS_getpgrp, 111
.equ SYS_setsid, 112
.equ SYS_setreuid, 113
.equ SYS_setregid, 114
.equ SYS_getgroups, 115
.equ SYS_setgroups, 116
.equ SYS_setresuid, 117
.equ SYS_getresuid, 118
.equ SYS_setresgid, 119
.equ SYS_getresgid, 120
.equ SYS_getpgid, 121
.equ SYS_setfsuid, 122
.equ SYS_setfsgid, 123
.equ SYS_getsid, 124
.equ SYS_capget, 125
.equ SYS_capset, 126
.equ SYS_rt_sigpending, 127
.equ SYS_rt_sigtimedwait, 128
.equ SYS_rt_sigqueueinfo, 129
.equ SYS_rt_sigsuspend, 130
.equ SYS_sigaltstack, 131
.equ SYS_utime, 132
.equ SYS_mknod, 133
.equ SYS_uselib, 134
.equ SYS_personality, 135
.equ SYS_ustat, 136
.equ SYS_statfs, 137
.equ SYS_fstatfs, 138
.equ SYS_SYSfs, 139
.equ SYS_getpriority, 140
.equ SYS_setpriority, 141
.equ SYS_sched_setparam, 142
.equ SYS_sched_getparam, 143
.equ SYS_sched_setscheduler, 144
.equ SYS_sched_getscheduler, 145
.equ SYS_sched_get_priority_max, 146
.equ SYS_sched_get_priority_min, 147
.equ SYS_sched_rr_get_interval, 148
.equ SYS_mlock, 149
.equ SYS_munlock, 150
.equ SYS_mlockall, 151
.equ SYS_munlockall, 152
.equ SYS_vhangup, 153
.equ SYS_modify_ldt, 154
.equ SYS_pivot_root, 155
.equ SYS__SYSctl, 156
.equ SYS_prctl, 157
.equ SYS_arch_prctl, 158
.equ SYS_adjtimex, 159
.equ SYS_setrlimit, 160
.equ SYS_chroot, 161
.equ SYS_sync, 162
.equ SYS_acct, 163
.equ SYS_settimeofday, 164
.equ SYS_mount, 165
.equ SYS_umount2, 166
.equ SYS_swapon, 167
.equ SYS_swapoff, 168
.equ SYS_reboot, 169
.equ SYS_sethostname, 170
.equ SYS_setdomainname, 171
.equ SYS_iopl, 172
.equ SYS_ioperm, 173
.equ SYS_create_module, 174
.equ SYS_init_module, 175
.equ SYS_delete_module, 176
.equ SYS_get_kernel_syms, 177
.equ SYS_query_module, 178
.equ SYS_quotactl, 179
.equ SYS_nfsservctl, 180
.equ SYS_getpmsg, 181
.equ SYS_putpmsg, 182
.equ SYS_afs_SYScall, 183
.equ SYS_tuxcall, 184
.equ SYS_security, 185
.equ SYS_gettid, 186
.equ SYS_readahead, 187
.equ SYS_setxattr, 188
.equ SYS_lsetxattr, 189
.equ SYS_fsetxattr, 190
.equ SYS_getxattr, 191
.equ SYS_lgetxattr, 192
.equ SYS_fgetxattr, 193
.equ SYS_listxattr, 194
.equ SYS_llistxattr, 195
.equ SYS_flistxattr, 196
.equ SYS_removexattr, 197
.equ SYS_lremovexattr, 198
.equ SYS_fremovexattr, 199
.equ SYS_tkill, 200
.equ SYS_time, 201
.equ SYS_futex, 202
.equ SYS_sched_setaffinity, 203
.equ SYS_sched_getaffinity, 204
.equ SYS_set_thread_area, 205
.equ SYS_io_setup, 206
.equ SYS_io_destroy, 207
.equ SYS_io_getevents, 208
.equ SYS_io_submit, 209
.equ SYS_io_cancel, 210
.equ SYS_get_thread_area, 211
.equ SYS_lookup_dcookie, 212
.equ SYS_epoll_create, 213
.equ SYS_epoll_ctl_old, 214
.equ SYS_epoll_wait_old, 215
.equ SYS_remap_file_pages, 216
.equ SYS_getdents64, 217
.equ SYS_set_tid_address, 218
.equ SYS_restart_SYScall, 219
.equ SYS_semtimedop, 220
.equ SYS_fadvise64, 221
.equ SYS_timer_create, 222
.equ SYS_timer_settime, 223
.equ SYS_timer_gettime, 224
.equ SYS_timer_getoverrun, 225
.equ SYS_timer_delete, 226
.equ SYS_clock_settime, 227
.equ SYS_clock_gettime, 228
.equ SYS_clock_getres, 229
.equ SYS_clock_nanosleep, 230
.equ SYS_exit_group, 231
.equ SYS_epoll_wait, 232
.equ SYS_epoll_ctl, 233
.equ SYS_tgkill, 234
.equ SYS_utimes, 235
.equ SYS_vserver, 236
.equ SYS_mbind, 237
.equ SYS_set_mempolicy, 238
.equ SYS_get_mempolicy, 239
.equ SYS_mq_open, 240
.equ SYS_mq_unlink, 241
.equ SYS_mq_timedsend, 242
.equ SYS_mq_timedreceive, 243
.equ SYS_mq_notify, 244
.equ SYS_mq_getsetattr, 245
.equ SYS_kexec_load, 246
.equ SYS_waitid, 247
.equ SYS_add_key, 248
.equ SYS_request_key, 249
.equ SYS_keyctl, 250
.equ SYS_ioprio_set, 251
.equ SYS_ioprio_get, 252
.equ SYS_inotify_init, 253
.equ SYS_inotify_add_watch, 254
.equ SYS_inotify_rm_watch, 255
.equ SYS_migrate_pages, 256
.equ SYS_openat, 257
.equ SYS_mkdirat, 258
.equ SYS_mknodat, 259
.equ SYS_fchownat, 260
.equ SYS_futimesat, 261
.equ SYS_newfstatat, 262
.equ SYS_unlinkat, 263
.equ SYS_renameat, 264
.equ SYS_linkat, 265
.equ SYS_symlinkat, 266
.equ SYS_readlinkat, 267
.equ SYS_fchmodat, 268
.equ SYS_faccessat, 269
.equ SYS_pselect6, 270
.equ SYS_ppoll, 271
.equ SYS_unshare, 272
.equ SYS_set_robust_list, 273
.equ SYS_get_robust_list, 274
.equ SYS_splice, 275
.equ SYS_tee, 276
.equ SYS_sync_file_range, 277
.equ SYS_vmsplice, 278
.equ SYS_move_pages, 279
.equ SYS_utimensat, 280
.equ SYS_epoll_pwait, 281
.equ SYS_signalfd, 282
.equ SYS_timerfd_create, 283
.equ SYS_eventfd, 284
.equ SYS_fallocate, 285
.equ SYS_timerfd_settime, 286
.equ SYS_timerfd_gettime, 287
.equ SYS_accept4, 288
.equ SYS_signalfd4, 289
.equ SYS_eventfd2, 290
.equ SYS_epoll_create1, 291
.equ SYS_dup3, 292
.equ SYS_pipe2, 293
.equ SYS_inotify_init1, 294
.equ SYS_preadv, 295
.equ SYS_pwritev, 296
.equ SYS_rt_tgsigqueueinfo, 297
.equ SYS_perf_event_open, 298
.equ SYS_recvmmsg, 299
.equ SYS_fanotify_init, 300
.equ SYS_fanotify_mark, 301
.equ SYS_prlimit64, 302
.equ SYS_name_to_handle_at, 303
.equ SYS_open_by_handle_at, 304
.equ SYS_clock_adjtime, 305
.equ SYS_syncfs, 306
.equ SYS_sendmmsg, 307
.equ SYS_setns, 308
.equ SYS_getcpu, 309
.equ SYS_process_vm_readv, 310
.equ SYS_process_vm_writev, 311
.equ SYS_kcmp, 312
.equ SYS_finit_module, 313
.equ SYS_sched_setattr, 314
.equ SYS_sched_getattr, 315
.equ SYS_renameat2, 316
.equ SYS_seccomp, 317
.equ SYS_getrandom, 318
.equ SYS_memfd_create, 319
.equ SYS_kexec_file_load, 320
.equ SYS_bpf, 321
.equ SYS_stub_execveat, 322
.equ SYS_userfaultfd, 323
.equ SYS_membarrier, 324
.equ SYS_mlock2, 325
.equ SYS_copy_file_range, 326
.equ SYS_preadv2, 327
.equ SYS_pwritev2, 328
.equ SYS_pkey_mprotect, 329
.equ SYS_pkey_alloc, 330
.equ SYS_pkey_free, 331
.equ SYS_statx, 332
.equ SYS_io_pgetevents, 333
.equ SYS_rseq, 334
.equ SYS_pkey_mprotect, 335

// socket constants
.equ AF_INET, 2
.equ SOCK_STREAM, 1
.equ IPPROTO_IP, 0

// stdio 
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

// open flags 
.equ O_RDONLY, 0 
.equ O_WRONLY, 1 
.equ O_RDWR, 2 
.equ O_CREAT, 00000100
