; 2017 error(c)
.model small
.stack 100h
locals

.const
	screenWidth = 320
	screenHeight = 200
	screenSize = (screenWidth*screenHeight)

.data
	sRedScreen equ 'Red screen'
	sGreenScreen equ 'Green screen'
	sBlueScreen equ 'Blue screen'
	sWhiteScreen equ 'White screen'
	sHorizontalLines equ 'Horizontal lines'
	sVerticalLines equ 'Vertical lines'
	sGrayGradient equ 'Gray gradient'
	sColorGradient equ 'Color gradient'
	    
    menuText db\
'+----------------------+',13,10,\
'|      Screen Test     |',13,10,\
'|     2017 by Error    |',13,10,\
'+----------------------+',13,10,\
13,10,\
'Please select mode:',13,10,13,10,\
'1) ',sRedScreen,13,10,\
'2) ',sGreenScreen,13,10,\
'3) ',sBlueScreen,13,10,\
'4) ',sWhiteScreen,13,10,\
'5) ',sHorizontalLines,13,10,\
'6) ',sVerticalLines,13,10,\
'7) ',sGrayGradient,13,10,\
'8) ',sColorGradient,13,10,\
'E) Exit',13,10,'$'
	
	redScreenText db sRedScreen,13,10,'$'
	greenScreenText db sGreenScreen,13,10,'$'
	blueScreenText db sBlueScreen,13,10,'$'
	whiteScreenText db sWhiteScreen,13,10,'$'
	horizontalLinesText db sHorizontalLines,13,10,'$'
	verticalLinesText db sVerticalLines,13,10,'$'
	grayGradientText db sGrayGradient,13,10,'$'
	colorGradientText db sColorGradient,13,10,'$'
	
	exitText db 13,10,'Press [esc] to exit','$'
	
.code

; clear screen: [color]
cls:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2+2; ret + color arg
    ; save registers
    push ax
    push cx
    push di
    ; work
    mov ax,[bp]; load [color] to ax
    mov di,0; 0 to di
@@loop:
	mov es:byte ptr[di],al; save byte to video ram
	inc di
	cmp di,screenSize
	jnz @@loop; if di < screenSize then goto loop
    ; restore registers
    pop di
    pop cx
    pop ax
    ; return
    pop bp; load bp
    ret 2

; print test name on screen: [@text]
printName:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2+2; ret + text arg
    ; save registers
    push ax
    push bx
    push cx
    push dx
    ; clear screen (set videomode)
    mov ax,13h
    int 10h
    ; set cursor pos
    mov ah,2h
    mov bh,0h; x
    mov dh,25/2-2; y
    mov dl,13
    int 10h; bios int
    ; print text
    mov ah,9
    mov dx,[bp]; [@text]
    int 21h; dos int
    mov ah,9
    mov dx,offset exitText
    int 21h; dos int
    ; sleep 1 second
    mov ah,86h
    mov cx,10
    mov dx,00
    int 15h; dos int
    ; restore registers
    pop dx
    pop cx
    pop bx
    pop ax
    ; return
    pop bp; load bp
    ret 2
    
redScreen:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2; ret
    ; print name
	push offset redScreenText
	call printName
	; test
    push 40; red color in std palette
    call cls
    ; return
    pop bp; load bp
    ret
    
greenScreen:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2; ret
    ; print name
	push offset greenScreenText
	call printName
	; test
    push 48; green color in std palette
    call cls
    ; return
    pop bp; load bp
    ret
    
blueScreen:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2; ret
    ; print name
	push offset blueScreenText
	call printName
	; test
    push 32; blue color in std palette
    call cls
    ; return
    pop bp; load bp
    ret
    
whiteScreen:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2; ret
    ; print name
	push offset whiteScreenText
	call printName
	; test
    push 15; white color in std palette
    call cls
    ; return
    pop bp; load bp
    ret
   
horizontalLines:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2
    ; save registers
    push ax
    push bx
    push cx
    push di
    push dx
    ; print name
	push offset horizontalLinesText
	call printName
	; clear screen
    push 0; black color
    call cls
    ; draw
    ; y loop
    mov cx,0
@@LoopY:
	; get offset for y -> di
	mov ax,cx
	mov dx,screenWidth
	mul dx
	mov di,ax
	; x loop
    mov bx,0
@@LoopX:
	; draw point
	mov es:byte ptr[di+bx],15
	inc bx
	cmp bx,screenWidth
	jnz @@LoopX
	; end x loop
	add cx,8
	cmp cx,screenHeight
	jl @@LoopY
	; end y loop
	; load registers
	pop dx
	pop di
	pop cx
	pop bx
	pop ax
    ; return
    pop bp; load bp
    ret
    
vertiacalLines:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2
    ; save registers
    push di
    ; print name
	push offset verticalLinesText
	call printName
	; clear screen
    push 0; black color
    call cls
    ; draw
    mov di,0
@@Loop:
	; draw point
	mov es:byte ptr[di],15
	add di,8
	cmp di,screenSize
	jbe @@Loop
    ; load registers
	pop di
    ; return
    pop bp; load bp
    ret
    
grayGradient:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2
    ; save registers
    push ax
    push bx
    push cx
    push dx
    push di
    ; print name
	push offset grayGradientText
	call printName
    ; draw
    mov di,0
    ; y loop
    mov di,0
@@LoopY:
	; x loop
    mov bx,0
@@LoopX:
	; get offset [0..15] -> al
	mov ax,bx
	mov dx,20
	div dl
	; al + 16 -> al - gray colors offset in std color table
	add al,16
	; draw point
	mov es:byte ptr[di+bx],al
	inc bx
	cmp bx,screenWidth
	jnz @@LoopX
	; end x loop
	add di,screenWidth
	cmp di,screenSize
	jbe @@LoopY
	; end y loop
	; load registers
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	; return
    pop bp; load bp
    ret
    
colorGradient:
	; enter
    push bp; save bp
    mov bp,sp
    add bp,2
    ; save registers
    push ax
    push bx
    push cx
    push dx
    push di
    ; print name
	push offset grayGradientText
	call printName
    ; draw
    mov di,0
    ; y loop
    mov di,0
@@LoopY:
	; x loop
    mov bx,0
@@LoopX:
	; get offset [0..15] -> al
	mov ax,bx
	mov dx,20
	div dl
	; draw point
	mov es:byte ptr[di+bx],al
	inc bx
	cmp bx,screenWidth
	jnz @@LoopX
	; end x loop
	add di,screenWidth
	cmp di,screenSize
	jbe @@LoopY
	; end y loop
	; load registers
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	; return
    pop bp; load bp
    ret
        
.data
	testProc dw redScreen, greenScreen, blueScreen, whiteScreen,\
	horizontalLines, vertiacalLines, grayGradient, colorGradient

.code

; enter point
.startup
	; std setup
    mov ax,@data
    mov ds,ax

	; screen ram -> es
	mov ax,0a000h
	mov es,ax

	; set video mode 10
    mov ax, 13h
    int 10h    
    
@@loop:
    ; clear screen
    mov ax,13h
    int 10h
    ; print menu
    mov ah,9
    mov dx,offset menuText
    int 21h
   	; getkey
	mov ah,08h
	int 21h
	
	; exit
	cmp al,'e'
	jz @@exit
	
	; select screen test proc
	cmp al,'1'
	jl @@endCase
	cmp al,'8'
	jg @@endCase
	; al - '0' -> ax
	mov ah,'1'
	sub al,ah
	mov ah,0
	mov cx,ax
@@run:
	; ax * 2 -> bx
	mov dl,2
	mul dl
	mov bx,ax
	; []
	mov bx,[bx+testProc]
	; call
	call bx

@@getKey:
   	; getkey
	mov ah,08h
	int 21h
	; ex keys
	cmp al,0
	jnz @@endCase
	mov ah,08h
	int 21h
    ; ->
	cmp al,77
	jnz @@test2
	cmp cx,7
	jz @@getKey	
	inc cx
	mov ax,cx
	jmp @@run
@@test2:
	; <-
	cmp al,75
	jnz @@endCase
	cmp cx,0
	jz @@getKey	
	dec cx
	mov ax,cx
	jmp @@run

@@endCase:
	jmp @@loop
	
@@exit:
    ;set text mode
    mov ax, 2h;
    int 10h 
    ; exit 
    mov ah,4ch
    int 21h
end
