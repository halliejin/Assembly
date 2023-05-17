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
; C = 0;
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
; register allocation: R0=A, R1=B, R2=0

CONST R0, #6            ; A = 6
ADD R1, R0, #0          ; B = A  
CONST R2, #0            ; C = 0 (for A <= 0 or A > 7)
IF1
    CMPI R0, #0         ; sets NZP (A - 0)
    BRp END1            ; tests NZP (was A positive?, if yes, go to END1)
    ADD R1, R2, #-1     ; B = C - 1 (sets B to -1)
    BRnzp END           ; B is set to -1 when A < 0
  END1

IF2
    CMPI R0, #7         ; sets NZP (A - 7)
    BRnz ELSE           ; tests NZP (was A - 7 neg or zero?, if yes, go to ELSE)
    ADD R1, R2, #-1     ; B = C - 1 (sets B to -1)
    BRnzp END           ; B is set to -1 when A > 7
ELSE

JSR SUB_FACTORIAL       ; call to subroutine
END                     ; end program

  .FALIGN               ; aligns the subroutine
  SUB_FACTORIAL         ; ARGS: R0(A), RET: R2(B)
    CMPI R0, #1         ; while loop sets NZP (A - 1)
    BRnz END_SUB        ; tests NZP (was A - 1 neg or zero?, if yes, goto END_SUB)
    ADD R0, R0, #-1     ; A = A - 1
    MUL R1, R1, R0      ; B = B * A
    BRnzp SUB_FACTORIAL ; end loop
  END_SUB
  RET                   ; end subroutine
