.model tiny
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.data
;&&&&&&&&&&&&&&&&&&&&&&&& MESSAGES &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
mgs1: db 13,10, 'Please enter the number of elements in the range of[1-25] : $'
mgs2: db 13,10, 'Please enter the elements of the array to be sorted in the range of[0-65535] : $ '
mgs3: db 13,10, 'Please enter "a" for ascending sort or "d" for deascending sort : $'
mgs5: db 13,10, 'Please enter suitable number in the range of [1 - 25]: $'
mgs6: db 13,10, 'Please enter suitable number : $' 
over: db 13,10, 'ERROR: overflow, please repeat the element! $'
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;/\////////////////////////////////////////////////////////////////\
arr db 5 dup (?)
;array elements must be 2 digits in asciis as 'byte' and not shifted !
;/\////////////////////////////////////////////////////////////////\
array dw 25 dup(?)
;array elements in decimal to be sorted
;/\////////////////////////////////////////////////////////////////\ 
num dw ?
;must be in ascii as 'word'
;/\////////////////////////////////////////////////////////////////\ 
count dw ?
;this will hold the decimal of num       
;/\////////////////////////////////////////////////////////////////\ 
sort db ?
; it must be 'd'/'D'/'a'/'A'
;/\////////////////////////////////////////////////////////////////\
index dw 0
; it holds the array of decimal index
;/\////////////////////////////////////////////////////////////////\
shift dw ?
; this will hold number of zero's before shifting
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.code
;************************************************************************************************************
msg1:                        ; show msg1 for take number of element
   mov ah , 9
   mov dx , offset mgs1    
   int 21h     
;************************************************************************   

input1:          ; take frist input from user it must be from [1-25]
    
   mov ah,1  
   int 21h
   cmp al,30h    ;/////////////////////////
   jb error      ;compare if user entered any thing not number 
   cmp al,39h    ;it will jump to error massage if the user doesnot enter number
   ja error      ;//////////////////////////////////////////////         
   
   cmp al,30h    ;compare if user enter zero
   je ending_the_program    ; it will jump to label 'ending the program'  to end the program
   mov bh,al                ;move frist value in bh
   int 21h                  ;make interrupt for second value of element 
   cmp al,0Dh               ;ckeck if user made a enter press 
   jnz continuee             ; if user doesnot enter a enter press it willnot jump to continue label to store the second digit
   mov bl,bh                ;move first value in bl from bh                                                                                 
   mov bh,30h               ; put in bh zero
   mov num,bx               ;store the number of element in variable called 'num'
   jmp mgs                  ;jump to show mgs and take element of arr
continuee:                   ;if user  enter a enter press it will jump to continue label to store the second digit
   mov bl,al                ;move al to bl
   
   cmp bx , 00h             ;//////////////////////////////////////////////////////
                            ; check if user enter a number not from 1 to 25
   jb error                 ;it will jump to error massage if user enter wrong number 
   cmp bx , 3235h
   ja error                 ;////////////////////////////////////////////////////
   mov num,bx               ;store the number of element in variable called 'num'
   
   jmp mgs                  ;jump to show mgs and take element of arr
;**********-_***********************************************************************
error:
   mov ah,9                 ;///////////////////////////////////////////////////
   mov dx,offset mgs5       ;show to the user the error massage
   int 21h                  ;//////////////////////////////////////////////////// 
     
   jmp input1               ;then jump to input1 to take the correct number of elements
;*****************************************************************************
;*********** massage of elements of array to be sorted************************   
mgs:    
                                       
    
    mov ah,9
    mov dx,offset mgs2 
    int 21h
    mov ah,2h           ;start of printing
    mov Dl,013          ;go to first position
    int 21h             ;show it 
    mov Dl,010          ;new line
    int 21h
;*********************************************************************************
;************************take the elements of array ******************************  
input2:            
    mov si,0000h        ;put in si zero
    mov cx,num          ;make cx as a counter contianing the number of element for entering elements of array
    sub cx,3030h        ;convert cx to decimal number
    cmp ch,01h          ;compare if ch has 01h 
    jz edit_the_value   ;if ch has 01h it will jump to edit_the_value of counter
    cmp ch,02h          ;compare if ch has 02h
    jz edit_value       ;if ch has 01h it will jump to edit_value of counter
    mov bx,0000h        ;move bx zero
    mov bl,06h          ; use bl as a counter for entering 5 digits for one element of array
;**********************************************************************************************
;************************take the  element of array which consisted of 5 digits***************
   
arr_input:              

                        
   sub bl,01h           ;subatrate from bl 01h to make bl =5 and take frist element of array 5  digits   
   cmp bl,00h           ;check if bl = 0 
   jz go_for_shifiting  ;if bl=0 it means  element of array if finished
   call input           ;call input fot take the element
;*******************************************************************************************
;****************take a or d for ascending sort or descending sort *************************    
   
input3:
   mov ah,1             ;start take the char            
   int 21h              ;take it
   
   cmp al,61h           ;check if input is 'a' 
   mov sort,al          ;move char in a variable called 'sort'
   
   jz ascending_sort    ;if the char is 'a' jump for ascending sort
   cmp al,64h           ;check if input is 'd'
   
   jz ascending_sort    ;if the char is 'd' jump for descending sort
   cmp al,30h           ;//////////////////////////////////////////
   ja msg3              ; check if user not enter 'a' or 'd' or enter number
   cmp al,39h           ; will jump to show mgs3 and take new input
   jb msg3              ;//////////////////////////////////////////////
   cmp al,0Dh
   jz msg3
new_line:               
    mov ah,2h           ;new line
    mov Dl,013          ;start of printing
    int 21h             ;go to first position 
    mov Dl,010          ;show it
    int 21h             ;new line
    mov bl,06h          ;move bl=6 to use it as a counter for next element
    mov si,0000h        ;move si zero
    mov arr,0           ; clean arr
    loop arr_input      ;jump to arr_input to take next element and sub from cl,1
;*************************************************************************************
;*******************    show massage    **********************************************
msg3:
   mov ah,9             ;mov ah= 9 to show the msg3
   mov dx,offset mgs3   ; store the offset of msg3 in dx
   int 21h              ; show it
   jmp input3           ;then jump to take the input3
;**************************************************************************************
;******************** end program ****************************************************    
      
ending_the_program:     ;label to end the  program if user entered at frist zero

 
   ret 
;**************************************************************************************
;********************* edit value of counter 'cx'*************************************   
edit_the_value:
   mov bx,0000h         ; let bx=0
   mov bl,06h           ;move bl=6 to be counter
   add cl,0ah           ;add cl = cl(old)+10 
   mov ch,00h           ;put ch=0

  jmp arr_input         ;jump to take input
           
edit_value:
    mov bx,0000h 
    mov bl,06h
    add cl,14h          ;add cl = cl(old)+20
    mov ch,00h
    
    jmp arr_input       ;jump to take input
;****************************************************************************************
;************** procdure of input for digits of one element of array *******************   
proc input
    pop bp              ;pop adress in stack
    
    mov ah,1
    int 21h             ;take input
    cmp al,0Dh          ;check if user press enter 
    mov shift,bx        ;if user press enter store bx in variable called 'shift' bx= number of zeroes to be shifted
    jz  put_zero        
    cmp al,30h          ;///////////////////////////////////////////////
    jb arr_zero             ;compare if input is not number
    cmp al,39h          ;then jmp to msg6
    ja arr_zero             ;///////////////////////////////////////////////
    
    mov arr[si],al      ;move al at the index of si in arr
    inc si              ; put si=si+1
    push bp             ; push adress from stack
    jmp arr_input       ; return to next instruction
    ret
;********************************************************************************************
;*************** functoin for fixing the number *********************************************                     
go_for_shifiting:
     mov shift,bx
     
     jmp check_or_shift  ;check if the user has inputted a number in the range and store it
 
;***********************************************************************    
 put_zero:
   cmp bl,5             ;when user press enter when he enter frist digit of the element
   jz msg6
   mov arr[si],'0'      ;when user press enter when he enter after frist digit of the element put index of si in arr =0
   inc si               ; si = si+1
   sub bl,01h
   cmp bl,00h           ;check if bl !=0
   jnz put_zero         ;jump and repeat 
   
   jmp check_or_shift   ;check if the user has inputted a number in the range and store it
    
 

  
  arr_zero:
  mov di,0000h
label:  
  mov arr[di],0
  inc di
  cmp di,5
  jnz label 
msg6:  
  mov si,0000h
 
  mov ah,9
  mov dx,offset mgs6
  int 21h
  mov ah,2h           ;new line
  mov Dl,013          ;start of printing
  int 21h             ;go to first position 
  mov Dl,010          ;show it
  int 21h
  mov bl,06h
  call arr_input
;************************************************************************************************************
;*******************Shifting function***************************************
; next function shift the non 5-digits elements


proc asci_shifting
    
    pop bp
    
    jmp start_shift
    
    swap_shifting: 
            mov arr[si],dl
    
            mov arr[di],al
    
            jmp continue_shifting
    
    
    
    start_shift:
            mov bx,shift      ;bx holds the number of zeros ====> number of shifting 
    
            mov cx,5
            sub cx,bx         ;cx holds the number of digits
    
            mov si,0          ;initialize si
            mov si,cx         
            sub si,1          ;start from the last digit
    
            mov di,0          ;initialize di
            mov di,bx         
            add di,si         ;di will point to a place which equal the last digit + number of shifting
    shifting:
        mov al,arr[si]    
        mov dl,arr[di]    
        
        jmp swap_shifting   ;swapping 
        continue_shifting:
            dec si          ;continue to the previous digit 
            dec di          ;continue to the previous place
            loop shifting
    
    
    push bp
    ret

;************************************************************************************************************

;************************************************************************************************************

;**************** Operation of printing ended ***************************************************************
; this function called only after printing


operation_finished:               ;Take the next input but first initialize all registers and variables
    mov ax,0000
    mov bx,0000
    mov cx,0000
    mov dx,0000
    mov si,0000
    mov di,0000
    mov index ,ax
    mov count ,ax
    
    
    jmp msg1    ; start again
    
    
;************************************************************************************************************

;***********************Converting Array*********************************************************************
; This function convert the array of asciis to decimal word array
; This function called before start ascend_sort
proc convert_digits
    pop bp
    mov si,0         ; si is a pointer to arr elements(byte)
    mov di,index     ; di is a pinter to array elements(word)
    ;******** 5 digits element**********
    every_digit:
        mov dx,0000 ; dx,will hold the remainder & hold the tenth factor
        mov bx,0000 ; bx,will hold the decimal value of the element
        
        ;----- first digit (x....)
        mov ax,0000        ;ax must be empty[ah=0]
        mov al,arr[si]     ;first ascii digit
        sub al,30h         ;convert to decimal
        mov dx,10000       ;get the 10000 factor
        mul dx             ;multiply ax[ah=0] by 10000 and put the result in ax
        add bx,ax          ;add the result to bx
        ;----- second digit (.x...) 
        mov ax,0000        ;ax must be empty[ah=0]
        mov al,arr[si+1]   ;first ascii digit
        sub al,30h         ;convert to decimal
        mov dx,1000        ;get the 1000 factor
        mul dx             ;multiply ax[ah=0] by 1000 and put the result in ax
        add bx,ax          ;add the result to bx
        ;----- third digit (..x..)
        mov ax,0000        ;ax must be empty[ah=0]
        mov al,arr[si+2]   ;first ascii digit
        sub al,30h         ;convert to decimal
        mov dx,100         ;get the 100 factor
        mul dx             ;multiply ax[ah=0] by 100 and put the result in ax
        add bx,ax          ;add the result to bx
        ;----- fourth digit (...x.)
        mov ax,0000        ;ax must be empty[ah=0]
        mov al,arr[si+3]   ;first ascii digit
        sub al,30h         ;convert to decimal
        mov dx,10          ;get the 10 factor
        mul dx             ;multiply ax[ah=0] by 10 and put the result in ax
        add bx,ax          ;add the result to bx
        ;----- fifth digit (....x)
        mov ax,0000        ;ax must be empty[ah=0]
        mov al,arr[si+4]   ;first ascii digit
        sub al,30h         ;convert to decimal
        mov dx,1           ;get the 1 factor
        mul dx             ;multiply ax[ah=0] by 1 and put the result in ax
        add bx,ax          ;add the result to bx
        ;-----
        
        mov array[di],bx   ; store the element in the array(word)
        add di,2           ; continue to the next element in the array
        mov index,di
    
    
    
    ;------------------------------
    push bp
    ret
;************************************************************************************************************
;******** convert 'num' which in asciis to decimal and put it in 'count'*******

proc convert_count
    
    pop bp
    mov ax,0000  ;initialize used registers
    mov bx,0000
    mov dx,0000
    
    mov dx,num    ; move the 2-digits ascii number to dx
    sub dx,3030h  ; convert dh,dl to decimal           

    mov bl,dl     ; move the decimal value of the 1's to bl

    mov al,dh     ; move the decimal  value of dh to al to multiply by 10

    mov dl,10     ; mov decimal 10 to dl
                  
    mul dl        ; multiply al by dl and put the result in ax

    add bx,ax     ; add the 10's value to 1's value
    mov count,bx  ; move the result to count
    
    push bp
    
    ret
;***********************************************************************************************************
;*********************** Push the ascii digits of the decimal value ************************   
proc get_element_digits         ;number of digits of an integer stored in SI + every digit sored in stack
     pop bp             ;save return address
     mov si,0           ;number of digits=0 
     mov ax,bx          ;move the number from bx to ax
     digit:
        mov dx,00       ;because dx store the reminder we have to make dx=00 every loop
        mov bx,10       ;bx=10 to divide the number by 10
        div bx          ;divide DX,AX/10
        INC SI          ;digits++
        push dx         ;store the reminder in stack
        cmp ax,00h      ;quotient==0 ?
        jnz digit       ;while(quotient != 0) loop   
     push bp
     ret
;***********************************************************************************************************

;************************ Pop & print the ascii digits of the decimal value ***********************    
proc print_element_digits               ;print an integers (SI)times
    pop bp              
    mov ah,2h           ;intilaize printing
    prin:
       pop dx           ;take the integer from stack
       add dl,48        ;correct its position
       int 21h
       DEC si           ;SI--
       cmp si,0         ;SI==0 ?
       jnz prin         ;while (SI != 0) loop
    push bp             
    ret
;***********************************************************************************************************
 
;********* Defining Print function*************
start_print:

    mov cx,count ; print 'num' of elements
    mov di,0     ; start from zero

    printing:
        mov bx,array[di]           ; move the element to register bx to get it's digits
        call get_element_digits    ; get the element digits and push it in the stack
        call print_element_digits  ; pop the element digits and print it
        
        cmp cx,1                   ; check if this is the last element
        je operation_finished      ; if yes ===> terminate printing and don't print comma
        
        mov ah,2                   ;printing the comma
        mov dl,','
        int 21h
        
        add di,2                   ; the next element
        loop printing              ; continue printing
        
        jmp operation_finished
;***********************************************************************************************************
;********* Defining swap procedure*************

 ; this function swap the arr[si] & arr[di] while arr[si],arr[di] is loaded in ax,dx
proc swap
    pop bp 
    mov array[si],dx
    
    mov array[di],ax
    
    inc bx             ; mark that there is a swapping operation happend
    
    push bp
    ret
;***********************************************************************************************************
;********* Defining continue browsing**********

; this function is used to continue browsing the array 
; this function is used inside the ascending_sort fuction only
continue:
    add si,2
    add di,2
    
    loop browsing                ; if cx != 0 continue browsing
    jmp is_sort_has_finished?    ; else  jump to is_sort_has_finished?

;***********************************************************************************************************
;********* Defining swap and continue *********

; this function call the call procedure and then continue browsing
; this function is used inside ascending sort only
swapping:
    
    call swap
    
    jmp continue
;***********************************************************************************************************
;********* Defining reversing array************ 
    
proc reverse
    push bp
    
    mov ax,count
    mov dx,0000
    mov bx,2
    div bx
    mov cx,ax     ;we will swap num of times = count of elements//2
    
    mov si,0      ; fisrt element
    mov di,count  ; note that count is in decimal  
    add di,di     ; let the di point to the last element+1
    sub di,2      ; let the di point to the last element
    reversing:
        mov ax,array[si]     ;put the arr[si]&arr[di] at ax,dx
        
        mov dx,array[di]
        
        call swap         ;swapping arr[si] & arr[di]

        add si,2            ; let si point to the next element
        sub di,2            ; let di point to the previous element
        loop reversing
    pop bp
    ret
    
;************************************************************************************************************
;********* Defining Descending sort************

; in our program we already sorted the array ascending , now we want it descending , just reverse it !!!
; this function will be called only if the user input is 'd'or'D'
    
descending_sort:
    
    call reverse        ;reverse the array    
    jmp start_print     ;print it :)


;************************************************************************************************************
;********* Defining ascending sort*************

; this is main function of the code it won't be called if the user has inputted 0 elements
; this algorithm 'called smart bubble sort'
; it compares every 2 elements step by step
ascending_sort:
    mov ah,2h           ;start of printing
    mov Dl,013          ;go to first position
    int 21h             ;show it 
    mov Dl,010          ;new line
    int 21h
    call convert_count  ;convert 'num' from ascii to decimal
    
    ascend_sorting:
        mov bx,0  ; this register still zero only if there is no swapping operation happend !
    
        mov cx,count
        
        cmp cx,1        ; check if the number of elements = 1
        je start_print  ; if yes , print directly
        
        sub cx,1        ; we will check every 2 elements , num of check operations = num of elements-1
     
    
        mov si,0        ;start from first element
        mov di,2        ;start from second element
    
    
        browsing:             ; this loop browses the elements and do checks
 
            mov ax,array[si]  ;load first element at ax
           
            mov dx,array[di]  ;load second element at dx
        
            cmp ax,dx
            jb continue    
            je continue
            ja swapping   ; swap elements only if the first<second
             
            ; note that the swapping make the swap, then it jumps to continue
            ; note that the continue function is looping to browsing or jump to is_sort_has_finished?
    
        is_sort_has_finished?:    
            cmp bx,0            ; this register still zero if there is no swapping happend
            jne ascend_sorting  ; if there is swapping operations, then the array maybe hasn's completly sorted
                            ; if bx==0 ====> then the array has sorted , then continue the code :)


stop_sorting:               ; the array has sorted ascending
    cmp sort,'d'
    je descending_sort      ; if the user input is 'd' or 'D' ==> jump to descending_sort
    
    cmp sort,'D'
    je descending_sort
    
    jmp start_print         ;else ===> start printing directly !
    
;***********************************************************************************************************    
        

        
check_or_shift:
                              ; check if the input is 5 digits
    mov ax,shift
    cmp ax,0
    jne convert_it            ; if no, convert it directly
    
    mov ax,0000               ; if yes , make sure that it's equal or below 65535(word)
                              
                               
    mov al,36h                ;check if the first digit is above or below 6
    cmp arr[0],al
    jb convert_it             ;if below, start converting
    ja over_flow              ;if yes, error
                              ;if equal, continue checking
    mov al,35h
    cmp arr[1],al
    jb convert_it             ; the same with second digit,5
    ja over_flow
    
    mov al,35h                ; the same with third digit,5
    cmp arr[2],al
    jb convert_it
    ja over_flow
    
    mov al,33h                ; the same with fourth digit,3
    cmp arr[3],al
    jb convert_it
    ja over_flow
    
    mov al,35h                ; the same with last digit,5
    cmp arr[4],al
    ja over_flow
                              ; if else , convert it
    
    
    convert_it: 
     ;---------------------
        push ax            ;/////////////////////////////////
        push bx            ;/////////////////////////////////
        push cx            ; for saving the values of registers
        push dx
        push si            ;///////////////////////////////////
        push di            ;////////////////////////////////////
        call asci_shifting   ;call function
        call convert_digits
        pop di             ;///////////////////////////////////
        pop si             ;//////////////////////////////////
        pop dx             ; pop the values of registers
        pop cx
        pop bx             ;///////////////////////////////////
        pop ax             ;//////////////////////////////////////// 
        jmp new_line
     ;---------------------
        
        
    
over_flow:
    
    mov dx,offset over          ; show error message
    mov ah,9
    int 21h
    
    jmp arr_zero                ; retake the input
        
        
        
    