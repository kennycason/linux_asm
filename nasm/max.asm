;VARIABLES: The registers have the following uses:
;
; %edi - Holds the index of the data item being examined
; %ebx - Largest data item found
; %eax - Current data item
;
; The following memory locations are used:
;
; data_items - contains the item data. A 0 is used
; to terminate the data
;
SECTION  .data
data_items:              ; These are the data items
dd    3,67,34,222,45,75,54,34,44,33,22,11,66,0

SECTION  .text

GLOBAL _start

_start: 
        mov  edi,0                      ; move 0 into the index register
        mov  eax, [data_items+edi*4]    ; load the first byte of data
        mov  ebx,eax    ; since this is the first item, %eax is
                                        ; the biggest

start_loop:              ; start loop
        cmp  eax,0      ; check to see if we’ve hit the end
        je loop_exit
        inc  edi                ; load next value
        mov  eax, [data_items+edi*4]
        cmp  eax,ebx    ; compare values
        jle start_loop  ; jump to loop beginning if the new
                                        ; one isn’t bigger
        mov  ebx,eax    ; move the value as the largest
        jmp start_loop  ; jump to loop beginning

loop_exit: 
                                        ; %ebx is the status code for the exit system call
                                        ; and it already has the maximum number
        mov  eax,1      ; 1 is the exit() syscall
        int 080h

