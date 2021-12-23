global start

section .text
bits 32

load_page_table:
    ; move page table address to cr3
    mov eax, p4_table
    mov cr3, eax

    ; enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; set the long mode bit
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax
    return

start:
    mov word [0xb8000], 0x0E54 ; T
    mov word [0xb8002], 0x0E49 ; I
    mov word [0xb8004], 0x0E4E ; N
    mov word [0xb8006], 0x0E4B ; K
    mov word [0xb8008], 0x0E45 ; E
    mov word [0xb800a], 0x0E52 ; R
    mov word [0xb800c], 0x0E20 ;
    mov word [0xb800e], 0x0E4F ; O
    mov word [0xb8010], 0x0E53 ; S
    call load_page_table

    hlt

section .bss

align 4096

p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096

