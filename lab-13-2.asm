INCLUDE Irvine32.inc
INCLUDE macros.inc
.386
.model flat,stdcall
.stack 4096
BUFFER_SIZE = 5000
.data

buffer BYTE BUFFER_SIZE DUP(?)
filename    BYTE 80 DUP(0)
fileHandle  HANDLE ?
.code
main PROC
; Let user input a filename.
mWrite "Enter an input filename: "
mov edx,OFFSET filename
mov ecx,SIZEOF filename
call ReadString
; Open the file for input.
mov edx,OFFSET filename
call OpenInputFile
mov fileHandle,eax
; Check for errors.
cmp eax,INVALID_HANDLE_VALUE ; error opening file?
jne file_ok
; no: skip
mWrite <"Cannot open file",0dh,0ah>
jmp quit
; and quit
file_ok:
; Read the file into a buffer.
mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size
; error reading?
mWrite "Error reading file. "
; yes: show error message
call WriteWindowsMsg
jmp close_file
check_buffer_size:
cmp eax,BUFFER_SIZE
; buffer large enough?
jb buf_size_ok
; yes
mWrite <"Error: Buffer too small for the file",0dh,0ah>
jmp quit
; and quit
buf_size_ok:
mov buffer[eax],0
; insert null terminator
mWrite "File size: "
call WriteDec
; display file size
call Crlf
; Display the buffer.
mWrite <"Buffer:",0dh,0ah,0dh,0ah>
mov edx,OFFSET buffer
; display the buffer
call WriteString
call Crlf
close_file:
mov eax,fileHandle
call CloseFile
quit:
exit
main ENDP
END main


INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
BUFFER_SIZE = 501
.data
    buffer BYTE BUFFER_SIZE DUP(?)
    stringLength DWORD ?
    str1 BYTE "Write Array [500]",0dh,0ah,0
    str2 BYTE "Palindrome",0dh,0ah,0
    str3 BYTE "Not palindrome",0dh,0ah,0

    filename     BYTE "2328.txt",0
    fileHandle   HANDLE ?
    bytesWritten DWORD ?

.code
main PROC

    mov edx,OFFSET filename
    call OpenInputFile
    mov fileHandle,eax
    mov edx,OFFSET buffer
    mov ecx,BUFFER_SIZE
    call ReadFromFile
    
    ; Create a new text file.
    mov edx,OFFSET filename
    call CreateOutputFile
    mov fileHandle,eax

    
    mov ecx,BUFFER_SIZE
    
    mov edx,OFFSET str1
    call WriteString
    
    mov edx,OFFSET buffer
    call ReadString
    mov stringLength,eax

    mov ecx, stringLength
    mov esi, 0
    L1:
        mov edx, 0
        mov dl, [buffer + esi]
        push edx
        inc esi
        loop L1

    mov eax,fileHandle
    mov edx,OFFSET buffer
    mov ecx,stringLength
    call WriteToFile
    call CloseFile

    exit
main ENDP
END main