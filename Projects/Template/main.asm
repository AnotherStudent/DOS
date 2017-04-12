.model small
.stack 100h

.data
    HelloMessage db 'Hello World!',13,10,'$'

.code

.startup
    ; set @data to ds segment register
    push @data
    pop ds
    ; call dos print string proc
    mov ah,9
    mov dx,OFFSET HelloMessage
    int 21h
    ; call dos end proc
    mov ah,4ch
    int 21h
end
