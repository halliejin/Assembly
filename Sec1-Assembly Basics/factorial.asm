;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : factorial.asm                          ;
;  author      : 
;  description : LC4 Assembly program to compute the    ;
;                factorial of a number                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;; pseudo-code of factorial algorithm
;
; A = 5 ;  // example to do 5!
; B = A ;  // B=A! when while loop completes
; C = 0
; // when A = 1, B will be automatically set to 1 based on line 11 and 12
; //and there is no need for an operation to handle when A = 1
;
; if (A = 0){
;    B = B + 1;
; }
; if (A < 0){
;    B = C - 1;
;}
; while (A > 1) {
; 	A = A - 1;
; 	B = B * A;
; }



;;; TO-DO: Implement the factorial algorithm above using LC4 Assembly instructions
; register allocation: R0=A, R1=B, R2=0
	  
  CONST R0, #5         ; A = 5
  ADD R1, R0, #0       ; B = A 
  CONST R2, #0         ; C = 0 (for A < 0)
IF1
    CMPI R0, #0        ; sets NZP (A - 0)
    BRnp END1          ; tests NZP (was A neg or positive?, if yes, goto END1)
    ADD R1, R1, #1     ; B = B + 1 (sets B to 1) [I did ot realize that this can be replaced by CONST R1, #1 until finished the whole assignment...]
    BRnzp END          ; B is set to 1 when A = 0
  END1                 ; A != 0

IF2
    CMPI R0, #0        ; sets NZP (A - 0)
    BRzp END2          ; tests NZP (was A zero or positive? If yes, goto END2)
    ADD R1, R2, #-1    ; B = C - 1 (sets B to -1) [Same here, this can be replaced by CONST R1, #-1]
    BRnzp END          ; B is set to -1 when A < 0
  END2                 ; A > 0   

LOOP                   ; start the loop
    CMPI R0, #1        ; sets NZP (A - 1)
    BRnz END3           ; tests NZP (was A - 1 neg or zero?, if yes, goto END)
    ADD R0, R0, #-1    ; A = A - 1
    MUL R1, R1, R0     ; B = B * A
    BRnzp LOOP         ; always goto LOOP
  END3                 ; end of the loop     
END
