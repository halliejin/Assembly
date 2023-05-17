;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_string.asm                          ;
;  author      : Zihan Jin
;  description : read characters from the data memory     ;
;	             then echo them back to the ASCII display ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; "I love CIT 593"

.DATA
.ADDR x4000
global_array
.FILL x49		; I
.FILL x20		; space
.FILL x6C		; l 
.FILL x6F 		; o 
.FILL x76		; v 
.FILL x65       ; e
.FILL x20		; space
.FILL x43		; C
.FILL x49		; I 
.FILL x54		; T
.FILL x20		; space
.FILL x35		; 5
.FILL x39		; 9
.FILL x33		; 3
.FILL x00		; NULL

.CODE
.ADDR x0000
LEA R0, global_array
TRAP x03

END


