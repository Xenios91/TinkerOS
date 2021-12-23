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
    return

enable_paging:

    return

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

start:
    call load_message
    call setup_page_table
    call enable_paging

    hlt

section .bss

align 4096

p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096

