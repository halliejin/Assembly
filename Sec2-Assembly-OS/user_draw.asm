;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : user_draw.asm                            ;
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
;; red box
CONST R0, #50
CONST R1, #5
CONST R2, #10
CONST R3, #5
CONST R4, x00
HICONST R4, x7C

TRAP x09

;; green box
CONST R0, #10
CONST R1, #10
CONST R2, #50
CONST R3, #40
CONST R4, xD0
HICONST R4, x03

TRAP x09

;; yellow box
CONST R0, #120
CONST R1, #100
CONST R2, #27
CONST R3, #10
CONST R4, xE0
HICONST R4, xFF

TRAP x09
END


