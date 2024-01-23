.model small
.stack 100h
.data
  msg1 db "ENTER ANY STRING: $"
  msg2 db 0dh, 0ah, " Got it. Now what do you want to do?$"
  msgup db 0dh, 0ah, " 1=UPPERCASE$"
  msglo db 0dh, 0ah, " 2=lowercase$"
  msgre db 0dh, 0ah, " 3=Reverse$"
  msgsl db 0dh, 0ah, " 4=String's Length$"
  msgpa db 0dh, 0ah, " 5=Palindrome Check$"
  msgas db 0dh, 0ah, " 6=ASCII Version(10=: , 11=; , 12=<)$" 
  msgua db 0dh, 0ah, " 7=UPPERCASE ASCII$"
  msgla db 0dh, 0ah, " 8=lowercase ASCII$"
  msg3 db 0dh, 0ah, " THE RESULT IS: $"
  msg4 db 0dh, 0ah, " Invalid choice. Please enter again: $"
  msg5 db 0dh, 0ah, " 0=EXIT$"
  msgcon db 0dh, 0ah, " Do you want to continue?(y/n): $"
  msgconinv db 0dh, 0ah, " Invalid. Do you want to continue?(y/n): $"
  msgyes db 0dh, 0ah, " YES your string is palindrome$" 
  msgno db 0dh, 0ah, " NO your string is not palindrome$" 
  input db 20 dup("$")
  output db 20 dup("$")
.code
  main proc
    mov ax, @data
    mov ds, ax
    mov ah, 0bh  
    mov bh, 01h
    int 10h
    mov ah, 02h 
    mov bh, 00h
    mov dh, 01h
    mov dl, 01h
    int 10h
    mov ah, 09h  
    lea dx, msg1
    int 21h
    mov ah, 0ah  
    lea dx, input
    int 21h
    mov ah, 09h 
    lea dx, msg2
    int 21h
    lea dx, msgup
    int 21h
    lea dx, msglo
    int 21h
    lea dx, msgre  
    int 21h
    lea dx, msgsl  
    int 21h
    lea dx, msgpa 
    int 21h
    lea dx, msgas 
    int 21h
    lea dx, msgua
    int 21h
    lea dx, msgla
    int 21h
    lea dx, msg5 
    int 21h
    mov ah, 02h 
    mov bh, 00h
    mov dh, 0Dh 
    mov dl, 01h 
    int 10h
    
  choice:
    mov ah, 01h  
    int 21h
    cmp al, '1'  
    je upper
    cmp al, '2'  
    je lower
    cmp al, '3'  
    je reverse
    cmp al, '4'  
    je lengthfirst
    cmp al, '5' 
    je palindromefirst 
    cmp al, '6' 
    je asciifirst
    cmp al, '7'
    je uafirst
    cmp al, '8'
    je lafirst
    cmp al, '0' 
    je exitto
    jmp invalid 
  invalid:
    mov ah, 09h
    lea dx, msg4
    int 21h
    jmp choice
  exitto:
    jmp exit
  palindromefirst:
    jmp palindrome
  asciifirst:
    jmp ascii
  lengthfirst:
    jmp length
  uafirst:
    jmp uppercase_ascii
  lafirst:
    jmp lowercase_ascii
    
  upper:
    mov si, offset input + 2 
    mov di, offset output  
    mov cl, input + 1  
    mov ch, 00h
  convert1:
    mov al, [si] 
    cmp al, 'a' 
    jb next1
    cmp al, 'z'
    ja next1
    sub al, 20h  
    next1:
    mov [di], al 
    inc si  
    inc di  
    loop convert1  
    jmp display 
    
  lower:
    mov si, offset input + 2  
    mov di, offset output 
    mov cl, input + 1  
    mov ch, 00h
  convert2:
    mov al, [si]  
    cmp al, 'A' 
    jb next2
    cmp al, 'Z'
    ja next2
    add al, 20h 
    next2:
    mov [di], al  
    inc si 
    inc di 
    loop convert2 
    jmp display
    
  reverse:
    mov si, offset input + 2  
    mov di, offset output 
    mov cl, input + 1  
    mov ch, 00h
    add si, cx 
    dec si  
  convert3:
    mov al, [si] 
    mov [di], al  
    dec si  
    inc di 
    loop convert3 
    jmp display

  length:
    mov si, offset input + 3
    mov cx, 00h
  count:
    mov al, [si]
    cmp al, '$'
    je print
    inc cx
    inc si
    jmp count
  print:
    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ax, cx
    call display_num
    mov ah, 4ch
    int 21h
  display_num proc
    mov bx, 10
    mov si, offset output
  repeat:
    xor dx, dx
    div bx
    add dl, 30h
    mov [si], dl
    inc si
    cmp ax, 0
    jne repeat
    dec si
  print_num:
    mov dl, [si]
    mov ah, 02h
    int 21h
    dec si
    cmp si, offset output - 1
    jne print_num
    jmp ask_to_continue
  display_num endp
  
  display:
    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ah, 09h
    lea dx, output
    int 21h
  ask_to_continue:  
    mov ah, 09h  
    lea dx, msgcon
    int 21h
  ask_again:
    mov ah, 01h  
    int 21h
    cmp al, 'Y'  
    je clear_and_continue  
    cmp al, 'y'
    je clear_and_continue
    cmp al, 'N'
    je exitto2
    cmp al, 'n'
    je exitto2
    mov ah, 09h  
    lea dx, msgconinv
    int 21h
    jmp ask_again
  exitto2:
    jmp exit  
  clear_and_continue:  
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184fh
    int 10h
    jmp main
    
  palindrome:
    mov si, offset input + 2
    mov di, offset input + 2 
    mov cl, input + 1 
    mov ch, 00h
    add di, cx 
    dec di 
    shr cx, 1 
    cld 
  check:
    mov al, [si] 
    cmp al, [di] 
    jne notpal 
    inc si
    dec di 
    loop check 
    stc 
    jmp display_pal 
  notpal:
    clc 
  display_pal:
    mov ah, 09h
    lea dx, msg3
    int 21h
    jc yes 
    jnc no 
  yes:
    mov ah, 09h
    lea dx, msgyes
    int 21h
    jmp ask_to_continue
  no:
    mov ah, 09h
    lea dx, msgno 
    int 21h
    jmp ask_to_continue
    
  ascii:
    mov si, offset input + 2
    mov di, offset output
    mov cl, input + 1
    mov ch, 00h
    mov bx, 10
    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ah, 09h
    lea dx, output
    int 21h
  repeat6:
    mov al, [si]  
    mov ah, 0   
    mov bl, 10  
    div bl    
    add al, 30h 
    add ah, 30h
    push ax  
    pop dx      
    mov ah, 02h 
    int 21h     
    xchg dl, dh 
    int 21h     
    mov dl, ' '  
    mov ah, 02h 
    int 21h
    inc si  
    loop repeat6
    jmp ask_to_continue 
    
  uppercase_ascii:
    mov si, offset input + 2
    mov di, offset output
    mov cl, input + 1
    mov ch, 00h
    mov bx, 16  
    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ah, 09h
    lea dx, output
    int 21h
  repeat62:
    mov al, [si]  
    mov ah, 0   
    cmp al, 61h  
    jb skip 
    sub al, 20h 
  skip:
    mov bl, 10 
    div bl    
    add al, 30h 
    add ah, 30h
    push ax  
    pop dx      
    mov ah, 02h 
    int 21h     
    xchg dl, dh
    cmp dl, 39h  
    ja add7  
    jmp conti  
  add7:
    add dl, 7 
  conti:
    int 21h     
    mov dl, ' '  
    mov ah, 02h 
    int 21h
    inc si  
    loop repeat62
    jmp ask_to_continue
    
  lowercase_ascii:
    mov si, offset input + 2
    mov di, offset output
    mov cl, input + 1
    mov ch, 00h
    mov bx, 16  
    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ah, 09h
    lea dx, output
    int 21h
  repeat63:
   mov al, [si]  
    mov ah, 0   
    cmp al, 97  
    jae skip2 
    add al, 20h 
  skip2:
    mov bl, 10 
    div bl    
    add al, 30h 
    add ah, 30h
    push ax  
    pop dx      
    mov ah, 02h 
    int 21h     
    xchg dl, dh
    cmp dl, 39h  
    ja add72  
    jmp conti2  
  add72:
    add dl, 7 
  conti2:
    int 21h     
    mov dl, ' '  
    mov ah, 02h 
    int 21h
    inc si  
    loop repeat63
    jmp ask_to_continue

  exit:
    mov ah, 4ch
    int 21h
  main endp
  end main
end
