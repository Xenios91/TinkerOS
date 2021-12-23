global start

section .text
bits 32

setup_page_table:
    ; Point the first entry of the level 4 page table to the first entry in the
    ; p3 table
    mov eax, p3_table
    or eax, 0b11
    mov dword [p4_table], eax

    ; Point the first entry of the level 3 page table to the first entry in the
    ; p2 table
    mov eax, p2_table
    or eax, 0b11
    mov dword [p3_table], eax

    ; point each page table level two entry to a page
    mov ecx, 0         ; counter variable
.map_p2_table:
    mov eax, 0x200000  ; 2MiB
    mul ecx
    or eax, 0b10000011
    mov [p2_table + ecx * 8], eax

    inc ecx
    cmp ecx, 512
    jne .map_p2_table

    ret

enable_physical_address_extension:
    ; enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; set the long mode bit
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ret

enable_paging:
    ; enable paging
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax

    ret

load_message:
    mov word [0xb8000], 0x0E54 ; T
    mov word [0xb8002], 0x0E49 ; I
    mov word [0xb8004], 0x0E4E ; N
    mov word [0xb8006], 0x0E4B ; K
    mov word [0xb8008], 0x0E45 ; E
    mov word [0xb800a], 0x0E52 ; R
    mov word [0xb800c], 0x0E20 ;
    mov word [0xb800e], 0x0E4F ; O
    mov word [0xb8010], 0x0E53 ; S

    ret

start:
    call load_message
    call setup_page_table
    call enable_physical_address_extension
    call enable_paging
    lgdt [gdt64.pointer]

    hlt ; halt

section .bss

align 4096

p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096

section .rodata
gdt64:
    dq 0
.code: equ $ - gdt64
    dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53)
.data: equ $ - gdt64
    dq (1<<44) | (1<<47) | (1<<41)
.pointer:
    dw .pointer - gdt64 - 1
    dq gdt64
