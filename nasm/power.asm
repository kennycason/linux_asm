;PURPOSE: Program to illustrate how functions work
; This program will compute the value of
; 2^3 + 5^2
;
;Everything in the main program is stored in registers,
;so the data section doesn’t have anything.

SECTION  .data

SECTION  .text

GLOBAL _start

_start: 
        push  dword 3           ; push second argument
        push  dword 2           ; push first argument
        call power              ; call the function
        add  esp,8      ; move the stack pointer back
        push  eax               ; save the first answer before
                                        ; calling the next function
        push  dword 2           ; push second argument
        push  dword 5           ; push first argument
        call power              ; call the function
        add  esp,8      ; move the stack pointer back
        pop  ebx                ; The second answer is already
                                        ; in %eax. We saved the
                                        ; first answer onto the stack,
                                        ; so now we can just pop it
                                        ; out into %ebx
        add  ebx,eax    ; add them together
                                        ; the result is in %ebx
        mov  eax,1      ; exit (%ebx is returned)
        int 080h

;PURPOSE: This function is used to compute
; the value of a number raised to
; a power.
;
;INPUT: First argument - the base number
; Second argument - the power to
; raise it to
;OUTPUT: Will give the result as a return value
;NOTES: The power must be 1 or greater
;VARIABLES:
; %ebx - holds the base number
; %ecx - holds the power
;
; -4(%ebp) - holds the current result
; %eax is used for temporary storage
;
GLOBAL power:function
power: 
        push  ebp                       ; save old base pointer
        mov  ebp,esp            ; make stack pointer the base pointer
        sub  esp,4              ; get room for our local storage
        mov  ebx, [ebp+8]   ; put first argument in %eax
        mov  ecx, [ebp+12]  ; put second argument in %ecx
        mov  [ebp-4],ebx    ; store current result

power_loop_start: 
        cmp  ecx,1              ; if the power is 1, we are done
        je end_power
        mov  eax, [ebp-4]   ; move the current result into %eax
        imul  eax,ebx           ; multiply the current result by
        ;the base number
        mov  [ebp-4],eax    ; store the current result
        dec  ecx                        ; decrease the power
        jmp power_loop_start ; run for the next power

end_power: 
        mov  eax, [ebp-4]   ; return value goes in %eax
        mov  esp,ebp            ; restore the stack pointer
        pop  ebp                        ; restore the base pointer
        ret

