org 0x7c00 ; Tell the assembler where to put the code
bits 16 ; Tell the assembler to emit 16-bit code

%define ENDL 0x0D, 0x0A

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; Setup the stack
    mov ss, ax
    mov sp, 0x7c00

    mov si, message
    call print_str

    cli
    hlt

; Print a string
print_str:
    push si
    push ax

.print_char:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0e
    mov bh, 0
    int 0x10

    jmp .print_char

.done:
    pop ax
    pop si

    ret

message: db "test", ENDL, 0

times 510-($-$$) db 0 ; Create a 512 byte sector
dw 0aa55h ; BIOS signature