; main.asm для x64
includelib libcmt.lib      ; или msvcrt.lib  статическая C библиотека (C Runtime Library)
includelib kernel32.lib ; системные функции Windows (ExitProcess и др.)
includelib legacy_stdio_definitions.lib  ; важно для x64! ; специальная библиотека для printf/scanf в x64

; Импортируем функции C
extern printf:PROC
extern scanf:PROC
extern exit:PROC

.data
; Форматы для ввода/вывода
fmt byte '%d', 0
msg byte 'Number: %d', 0Ah, 0
result_msg byte 'Patterns "010": %d', 0Ah, 0
number dword 0

.code
main proc
	sub rsp, 28h
	;ввод числа
	lea rdx, number
	lea rcx, fmt
	call scanf
	;вывод числа
	mov edx, number
	lea rcx, msg
	call printf

	;копируем число
	mov eax, number
	mov ecx, 30 ; 30 раз
	xor ebx, ebx  ;счетчик попаданий
	
	mov edx, eax ;копия числа

check_loop:
	mov edx, eax ;копия
	and edx, 7 ;берем посление 3 бита
	cmp edx, 2 ;сравнение с 010
	jne not_equal;если не равны

	inc ebx ;увеличиваем счетчик если равны


not_equal:
	shr eax, 1 ;сдвиг вправо на 1 бит

	;проверка на 3 бита
	dec ecx
    jns check_loop  ; пока ECX >= 0
	
	
	;вывод результата
	mov edx, ebx
	lea rcx, result_msg
	call printf
	xor ecx, ecx


main endp
end