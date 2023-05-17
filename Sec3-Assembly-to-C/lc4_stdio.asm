;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : lc4_stdio.asm                          ;
;  author      : 
;  description : LC4 Assembly subroutines that call     ;
;                call the TRAPs in os.asm (the wrappers);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; WRAPPER SUBROUTINES FOLLOW ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
.CODE
.ADDR x0010    ;; this code should be loaded after line 10
               ;; this is done to preserve "USER_START"
               ;; subroutine that calls "main()"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_PUTC Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_putc

	;; PROLOGUE ;;
        ; CIT 593 TODO: write prologue code here
		STR R7, R6, #-2	;; save return address
		STR R5, R6, #-3	;; save base pointer
		ADD R6, R6, #-3
		ADD R5, R6, #0
		
	;; FUNCTION BODY ;;
		; CIT 593 TODO: write code to get arguments to the trap from the stack
		;  and copy them to the register file for the TRAP call
	LDR R0, R5, #3		; load c into R0
	TRAP x01        ; R0 must be set before TRAP_PUTC is called
	
	;; EPILOGUE ;; 
		; TRAP_PUTC has no return value, so nothing to copy back to stack
		ADD R6, R5, #0	;; pop locals off stack
		ADD R6, R6, #3	;; free space for return address, base pointer, and return value
		STR R7, R6, #-1	;; store return value
		LDR R5, R6, #-3	;; restore base pointer
		LDR R7, R6, #-2	;; restore return address
	
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TRAP_GETC Wrapper ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.FALIGN
lc4_getc

	;; PROLOGUE ;;
        ; CIT 593 TODO: write prologue code here
		STR R7, R6, #-2	;; save return address
		STR R5, R6, #-3	;; save base pointer
		ADD R6, R6, #-3
		ADD R5, R6, #0
	;; FUNCTION BODY ;;
		; CIT 593 TODO: TRAP_GETC doesn't require arguments!
		
	TRAP x00        ; Call's TRAP_GETC 
                    ; R0 will contain ascii character from keyboard
                    ; you must copy this back to the stack
	ADD R7, R0, #0  ; R7 = R0
	;; EPILOGUE ;; 
		; TRAP_GETC has a return value, so make certain to copy it back to stack
		ADD R6, R5, #0	;; pop locals off stack
		ADD R6, R6, #3	;; free space for return address, base pointer, and return value
		STR R7, R6, #-1	;; store return value
		LDR R5, R6, #-3	;; restore base pointer
		LDR R7, R6, #-2	;; restore return address
	RET




.FALIGN
lc4_puts
;; PROLOGUE ;;
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0


;; FUNCTION BODY ;;
	LDR R0, R5, #3		; load c into R0
	TRAP x03			; call TRAP_PUTS

	
;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET