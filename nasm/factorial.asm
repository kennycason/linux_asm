;PURPOSE - Given a number, this program computes the
; factorial. For example, the factorial of
; 3 is 3 * 2 * 1, or 6. The factorial of
; 4 is 4 * 3 * 2 * 1, or 24, and so on.
;
;This program shows how to call a function recursively.
SECTION  .data
                                        ; This program has no global data
SECTION  .text
GLOBAL _start

GLOBAL factorial        ; this is unneeded unless we want to share
                                        ; this function among other programs
_start: 
        push  dword 4           ; The factorial takes one argument - the
                                        ; number we want a factorial of. So, it
                                        ; gets pushed
        call factorial  ; run the factorial function
        add  esp,4      ; Scrubs the parameter that was pushed on
                                        ; the stack     
        mov  ebx,eax    ; factorial returns the answer in %eax, but
                                        ; we want it in %ebx to send it as our exit
                                        ; status
        mov  eax,1      ; call the kernel’s exit function
        int 080h
                                        ; This is the actual function definition

GLOBAL factorial:function
factorial: 
        push  ebp               ; standard function stuff - we have to
                                        ; restore %ebp to its prior state before
                                        ; returning, so we have to push it
        mov  ebp,esp    ; This is because we don’t want to modify
                                        ; the stack pointer, so we use %ebp.
        mov  eax, [ebp+8]       ; This moves the first argument to %eax
                                                ; 4(%ebp) holds the return address, and
                                                ; 8(%ebp) holds the first parameter
        cmp  eax,1      ; If the number is 1, that is our base
                                        ; case, and we simply return (1 is
                                        ; already in %eax as the return value)
        je end_factorial
        dec  eax                ; otherwise, decrease the value
        push  eax               ; push it for our call to factorial
        call factorial  ; call factorial
        mov  ebx, [ebp+8]       ; %eax has the return value, so we
                                                ; reload our parameter into %ebx
        imul  eax,ebx           ; multiply that by the result of the
                                                ; last call to factorial (in %eax)
                                                ; the answer is stored in %eax, which
                                                ; is good since that’s where return
                                                ; values go.
end_factorial: 
        mov  esp,ebp            ; standard function return stuff - we
        pop  ebp                        ; have to restore %ebp and %esp to where
                                                ; they were before the function started
        ret                             ; return to the function (this pops the

