;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : factorial_sub.asm                      ;
;  author      : 
;  description : LC4 Assembly subroutine to compute the ;
;                factorial of a number                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

;; CIT 593 TO-DO:
;; 1) Open up the codio assignment where you created the factorial subroutine (in a separate browswer window)
;; 2) In that window, open up your working factorial_sub.asm file:
;;    -select everything in the file, and "copy" this content (Conrol-C) 
;; 3) Return to the current codio assignment, paste the content into this factorial_sub.asm 
;;    -now you can use the factorial_sub.asm from your last HW in this HW
;; 4) Save the updated factorial_sub.asm file

;; SUB_FACTORIAL             ; your subroutine goes here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : factorial_sub.asm                      ;
;  author      : 
;  description : LC4 Assembly program to compute the    ;
;                factorial of a number                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;; pseudo-code of factorial_sub algorithm
;MAIN
; A = 6;               
; B = sub_factorial(A); 
;
;
; if (A <= 0){ 
;     B = C - 1;
; }
; // Since CMPI # with IMM7(7 bits), with one bit sign
; // so the largest signed number that the CMPI can process will be 2^6-1 = 63
; // However, when considering the 4 bit hex code, the largest signed number 4-bit hex can hold is 32767
; // 7! = 5040 < 32767 <8! = 40320, therefore, A cannot exceed 7
; if (A > 7){ 
;     B = C - 1;
; }
; // 
; else{
;     def sub_factorial(A){
;         while (A > 1) {
;             A = A - 1 ;
;     	      B = B * A ;
;         }
;     }   
; }
;
;;; TO-DO: Implement the factorial algorithm above using LC4 Assembly instructions
; register allocation: R0=A, R1=B

.FALIGN
SUB_FACTORIAL

;; prologue
    STR R7, R6, #-2	    ;; save return address
	STR R5, R6, #-3	    ;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	    ;; allocate stack space for 1 local variables

    LDR R0, R5, #3      ; load int a on the stack and copy it into R0
    ADD R1, R0, #0      ; R1 = R0
    STR R1, R5, #-1     ; store R1 back to stack

    ;; check the boundary 0 < A <= 7
    CMPI R0, #0         ; sets NZP (A - 0)
    BRnz END_OOB        ; tests NZP (was A <= 0?, if yes, go to END_OOB)
    CMPI R0, #7         ; sets NZP (A - 7)
    BRp END_OOB         ; tests NZP (was A > 7?, if yes, go to END_OOB)

;; function body
    WHILE
        CMPI R0, #1      ; loop condition, sets NZP (A - 1)
        BRnz END_SUB     ; tests NZP (was A <= 1?, if yes, end the function)
        ADD R0, R0, #-1  ; A = A - 1
        MUL R1, R1, R0   ; B = B * A
        STR R1, R5, #-1  ; store R1 back to stack
        BRnzp WHILE      ; goto WHILE
        END_SUB          ; end the loop
    RET

    END_OOB
    CONST R1, #-1        ; out of boundary, set B to -1
    STR R1, R5, #-1      ; store R1 back to stack

;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
    LDR R7, R6, #-2	;; restore return address
	RET