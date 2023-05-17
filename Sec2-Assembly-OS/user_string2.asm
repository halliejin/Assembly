;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_string2.asm                            ;
;  author      : Zihan Jin
;  description : read characters from the keyboard,       ;
;	             then echo them back to the ASCII display ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The following CODE will go into USER's Program Memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE
.ADDR x0000


.CODE
	CONST R0, x20	; set R0	
	HICONST R0, x20
	CONST R1, x00	; set R1

	TRAP x02	; call TRAP_GETS
	ADD R5, R1, #0

	
	;; "Length ="
	CONST R0, x4C	; L
	TRAP x01
	CONST R0, x65	; e 
	TRAP x01
	CONST R0, x6E 	; n 
	TRAP x01
	CONST R0, x67	; g 
	TRAP x01
	CONST R0, x74	; t 
	TRAP x01
	CONST R0, x68	; h 
	TRAP x01
	CONST R0, x20	; space 
	TRAP x01
	CONST R0, x3D	; =
	TRAP x01

	
	ADD R0, R5, #15      ; R0 = R1 + 48 for ASCII  
	ADD R0, R0, #15       
	ADD R0, R0, #15
	ADD R0, R0, #3
	TRAP x01	         ; this calls "TRAP_PUTC" in os.asm

	CONST R0, x20	; space 
	TRAP x01

	CONST R0, x20			
	HICONST R0, x20
	TRAP x03				; call "TRAP_PUTS"
 	
END


