;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  description : LC4 Assembly program to compute the    ;
;                factorial of a number                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;;; pseudo-code of dmem_fact algorithm
;MAIN
; A = 6;               
; B = sub_factorial(A); 
; C = 0;
; D = 5
;
;while (D > 0){
; load the address
; if (A <= 0){ 
;     B = C - 1;
; }
;
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
; store the data to its original address
; read next address
; D = D - 1
;}
;;; TO-DO: Implement the factorial algorithm above using LC4 Assembly instructions
; register allocation: R0=A, R1=B, R2=C, R3=global_array, R4=5
.DATA
.ADDR x4020
global_array
.FILL #6
.FILL #5
.FILL #8
.FILL #10
.FILL #-5

.code
.ADDR x0000
INIT
  LEA R3, global_array        ; load starting address of data to R3
  CONST R4, #5                ; set as a counter for 5 numbers waiting for processing

WHILE_LOOP
  CMPI R4, #0                 ; sets NZP (5 - 0)
  BRnz END_FINAL              ; if the counter is neg or zero, end the program

  LDR R0, R3, #0              ; offset 0 and load R0 with DATA from x4020
  ADD R1, R0, #0              ; B = A  
  CONST R2, #0                ; C = 0 (for A <= 0 or A > 7)
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
      JMP END                 ; jumps over subroutine
        .FALIGN               ; aligns the subroutine
        SUB_FACTORIAL
          CMPI R0, #1         ; while loop sets NZP (A - 1)
          BRnz END_SUB        ; tests NZP (was A - 1 neg or zero?, if yes, goto END_SUB)
          ADD R0, R0, #-1     ; A = A - 1
          MUL R1, R1, R0      ; B = B * A
          BRnzp SUB_FACTORIAL ; end loop
        END_SUB
        RET                   ; end subroutine
      
    END
    STR R1, R3, #0            ; store B in original location            
    ADD R3, R3, #1            ; advance to next address
    ADD R4, R4, #-1           ; subtract counter by 1
    BRnzp WHILE_LOOP          ; always goto WHILE_LOOP

END_FINAL                     ; end program
