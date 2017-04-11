.MODEL small
.stack 100h
.386


.data
HelloMessage DB 'Hello World!','$',0

conv_word  = 0
conv_uword = 1

.code

; ------------------------------
; Write string
; (str: word)
; ------------------------------
Write:
    ; enter
    push bp; save bp
    mov bp,sp
    ; save registers
    push ax
    push bx
    push dx
    ; work
    mov bx,[bp+4]
@@loop:
    mov dl,[bx]; load dl in bx address
    
    cmp dl,0; compare dl with 0
    je @@endloop; if dl == 0 then jmp @@endloop
    
    ; dos call
    mov ah,02h
    int 21h
    
    inc bx
    jmp @@loop

@@endloop:
    
    ; restore registers
    pop dx
    pop bx
    pop ax
    ; exit
    pop bp; load bp
    ret 2 

; ------------------------------
; New line   
; ------------------------------   
NewLine:
    push bp; save bp
    mov bp,sp
    push 0000h; 0  0
    push 0d0ah; 13 10
    push sp
    call Write
    pop bp; fake
    pop bp; fake
    pop bp; load bp
    ret

; ------------------------------
; Write string at new line
; (str: word)    
; ------------------------------ 
WriteLn:
    push bp; save bp
    mov bp,sp
    push word ptr [bp+4]
    call Write
    call NewLine
    pop bp; load bp
    ret 2

; ------------------------------
; UWord to string
; (dest: ptr[6]; N: word)    
; ------------------------------ 
UWordToStr:
    ; begin
    push bp; save bp
    mov bp,sp
    add bp,4
    ;
    push ax
    push bx
    push cx
    push dx
    push di
    ; load registrs
    mov di,[bp]
    mov ax,[bp+2]
    
    mov cx,0
    mov bx,10
@@LoopU:
    mov dx,0    
    div bx
    add dl,'0'
    ;mov [di],dl
    push dx
    inc cx

    cmp ax,0
    jne @@LoopU
     
@@PutSymbols:
    pop word ptr[di]
    inc di
    loop @@PutSymbols     
    mov byte ptr[di],0      
     
    ; end
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ;  
    pop bp
    ret 4

; ------------------------------
; Word to string
; (dest: ptr[7]; N: word)   
; ------------------------------ 
WordToStr:
    ; begin
    push bp; save bp
    mov bp,sp
    ;
    add bp,4
    ;
    push di
    ;
    cmp word ptr[bp+2],0
    jns @@Normal
   
    not word ptr[bp+2]
    inc word ptr[bp+2]
    mov di,[bp]
    mov byte ptr[di],'-'
    inc word ptr[bp]
   
@@Normal:
    push word ptr[bp+2]
    push word ptr[bp]
    call UWordToStr
    ;
    pop di  
    ;
    pop bp
    ret 4
    
; ------------------------------
; WriteWord
; (N: word)    
; ------------------------------    
WriteWord:
    push bp; save bp
    mov bp,sp
    add bp,4
    ;---
    sub sp,7; get mem
    push bx
    mov bx,sp; array [7]
    
    ; convert
    push word ptr[bp]
    push bx
    call WordToStr
   
    ; print
    push bx
    call WriteLn
  
    pop bx
    add sp,7; free mem
    ;---
    pop bp; load bp
    ret 4

; ------------------------------
; WriteUWord
; (N: word)    
; ------------------------------    
WriteUWord:
    push bp; save bp
    mov bp,sp
    add bp,4
    ;---
    sub sp,6; get mem
    push bx
    mov bx,sp; array [7]
    
    ; convert
    push word ptr[bp]
    push bx
    call UWordToStr
   
    ; print
    push bx
    call WriteLn
  
    pop bx
    add sp,6; free mem
    ;---
    pop bp; load bp
    ret 4
    
.startup   
jjj:
    ;jmp jjj
    mov ax,@data
    mov ds,ax
    
    push offset HelloMessage
    call WriteLn
    push offset HelloMessage
    call WriteLn
    push offset HelloMessage
    call WriteLn
    push offset HelloMessage
    call WriteLn
    
    push conv_word
    push -1010
    call WriteWord
    push -1010
    call WriteUWord
    ;ret
    mov ah,4ch
    int 21h

end

