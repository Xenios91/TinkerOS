global start

section .text
bits 32
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
    hlt
