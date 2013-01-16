
.equ RECORD_FIRSTNAME, 0
.equ RECORD_LASTNAME, 40
.equ RECORD_ADDRESS, 80
.equ RECORD_AGE, 320
.equ RECORD_SIZE, 324

#PURPOSE: This function writes a record to
# the given file descriptor
#
#INPUT: The file descriptor and a buffer
#
#OUTPUT: This function produces a status code
#
#STACK LOCAL VARIABLES
.equ ST_WRITE_BUFFER, 8
.equ ST_FILEDES, 12
.section .text
.globl write_record
.type write_record, @function
write_record:
pushl %ebp
movl %esp, %ebp
pushl %ebx
movl $SYS_WRITE, %eax
movl ST_FILEDES(%ebp), %ebx
movl ST_WRITE_BUFFER(%ebp), %ecx
movl $RECORD_SIZE, %edx
int $LINUX_SYSCALL
#NOTE - %eax has the return value, which we will
# give back to our calling program
popl %ebx
movl %ebp, %esp
popl %ebp
ret

# descriptor
#
#INPUT: The file descriptor and a buffer
#
#OUTPUT: This function writes the data to the buffer
# and returns a status code.
#
#STACK LOCAL VARIABLES
.equ ST_READ_BUFFER, 8
.equ ST_FILEDES, 12
.section .text
.globl read_record
.type read_record, @function
read_record:
pushl %ebp
movl %esp, %ebp
pushl %ebx
movl ST_FILEDES(%ebp), %ebx
movl ST_READ_BUFFER(%ebp), %ecx
movl $RECORD_SIZE, %edx
movl $SYS_READ, %eax
int $LINUX_SYSCALL
#NOTE - %eax has the return value, which we will
# give back to our calling program
popl %ebx
movl %ebp, %esp
popl %ebp
ret


#PURPOSE: Count the characters until a null byte is reached.
#
#INPUT: The address of the character string
#
#OUTPUT: Returns the count in %eax
#
#PROCESS:
# Registers used:
# %ecx - character count
# %al - current character
# %edx - current character address
.type count_chars, @function
.globl count_chars
#This is where our one parameter is on the stack
.equ ST_STRING_START_ADDRESS, 8
count_chars:
pushl %ebp
movl %esp, %ebp
#Counter starts at zero
movl $0, %ecx
#Starting address of data
movl ST_STRING_START_ADDRESS(%ebp), %edx
count_loop_begin:
#Grab the current character
movb (%edx), %al
#Is it null?
cmpb $0, %al
#If yes, we’re done
je count_loop_end
#Otherwise, increment the counter and the pointer
incl %ecx
incl %edx
#Go back to the beginning of the loop
jmp count_loop_begin
count_loop_end:
#We’re done. Move the count into %eax
#and return.
movl %ecx, %eax
popl %ebp
ret

.globl write_newline
.type write_newline, @function
.section .data
newline:
.ascii "\n"
.section .text
.equ ST_FILEDES, 8
write_newline:
pushl %ebp
movl %esp, %ebp
movl $SYS_WRITE, %eax
movl ST_FILEDES(%ebp), %ebx
movl $newline, %ecx
movl $1, %edx
int $LINUX_SYSCALL
movl %ebp, %esp
popl %ebp
ret

