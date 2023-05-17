;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  file name   : os.asm                                 ;
;  author      : 
;  description : LC4 Assembly program to serve as an OS ;
;                TRAPS will be implemented in this file ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;   OS - TRAP VECTOR TABLE   ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.OS
.CODE
.ADDR x8000
  ; TRAP vector table
  JMP TRAP_GETC           ; x00
  JMP TRAP_PUTC           ; x01
  JMP TRAP_GETS           ; x02
  JMP TRAP_PUTS           ; x03
  JMP TRAP_TIMER          ; x04
  JMP TRAP_GETC_TIMER     ; x05
  JMP TRAP_RESET_VMEM	  ; x06
  JMP TRAP_BLT_VMEM	      ; x07
  JMP TRAP_DRAW_PIXEL     ; x08
  JMP TRAP_DRAW_RECT      ; x09
  JMP TRAP_DRAW_SPRITE    ; x0A

  ;
  ; TO DO - add additional vectors as described in homework 
  ;
  
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;   OS - MEMORY ADDRESSES & CONSTANTS   ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; these handy alias' will be used in the TRAPs that follow
  USER_CODE_ADDR .UCONST x0000	; start of USER code
  OS_CODE_ADDR 	 .UCONST x8000	; start of OS code

  OS_GLOBALS_ADDR .UCONST xA000	; start of OS global mem
  OS_STACK_ADDR   .UCONST xBFFF	; start of OS stack mem

  OS_KBSR_ADDR .UCONST xFE00  	; alias for keyboard status reg
  OS_KBDR_ADDR .UCONST xFE02  	; alias for keyboard data reg

  OS_ADSR_ADDR .UCONST xFE04  	; alias for display status register
  OS_ADDR_ADDR .UCONST xFE06  	; alias for display data register

  OS_TSR_ADDR .UCONST xFE08 	; alias for timer status register
  OS_TIR_ADDR .UCONST xFE0A 	; alias for timer interval register

  OS_VDCR_ADDR	.UCONST xFE0C	; video display control register
  OS_MCR_ADDR	.UCONST xFFEE	; machine control register
  OS_VIDEO_NUM_COLS .UCONST #128
  OS_VIDEO_NUM_ROWS .UCONST #124


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; OS DATA MEMORY RESERVATIONS ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DATA
.ADDR xA000
OS_GLOBALS_MEM	.BLKW x1000
;;;  LFSR value used by lfsr code
LFSR .FILL 0x0001

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; OS VIDEO MEMORY RESERVATION ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.DATA
.ADDR xC000
OS_VIDEO_MEM .BLKW x3E00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;   OS & TRAP IMPLEMENTATIONS BEGIN HERE   ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.CODE
.ADDR x8200
.FALIGN
  ;; first job of OS is to return PennSim to x0000 & downgrade privledge
  CONST R7, #0   ; R7 = 0
  RTI            ; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_GETC   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Get a single character from keyboard
;;; Inputs           - none
;;; Outputs          - R0 = ASCII character from ASCII keyboard

.CODE
TRAP_GETC
    LC R0, OS_KBSR_ADDR  ; R0 = address of keyboard status reg
    LDR R0, R0, #0       ; R0 = value of keyboard status reg
    BRzp TRAP_GETC       ; if R0[15]=1, data is waiting!
                             ; else, loop and check again...

    ; reaching here, means data is waiting in keyboard data reg

    LC R0, OS_KBDR_ADDR  ; R0 = address of keyboard data reg
    LDR R0, R0, #0       ; R0 = value of keyboard data reg
    RTI                  ; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_PUTC   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Put a single character out to ASCII display
;;; Inputs           - R0 = ASCII character to write to ASCII display
;;; Outputs          - none

.CODE
TRAP_PUTC
  LC R1, OS_ADSR_ADDR 	; R1 = address of display status reg
  LDR R1, R1, #0    	; R1 = value of display status reg
  BRzp TRAP_PUTC    	; if R1[15]=1, display is ready to write!
		    	    ; else, loop and check again...

  ; reaching here, means console is ready to display next char

  LC R1, OS_ADDR_ADDR 	; R1 = address of display data reg
  STR R0, R1, #0    	; R1 = value of keyboard data reg (R0)
  RTI			; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_GETS   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Get a string of characters from the ASCII keyboard
;;; Inputs           - R0 = Address to place characters from keyboard
;;; Outputs          - R1 = Lenght of the string without the NULL

.CODE
TRAP_GETS

  ;;
  ;; TO DO: complete this trap
  ;;
  
  ;; check if the address is out of range
  CONST R3, x00
  HICONST R3, x20
  CONST R4, x00
  HICONST R4, x80

  CMP R0, R3    ; R0 >= x2000
  BRn END_LOOP
  CMPU R0, R4    ; R0 < x8000
  BRzp END_LOOP

WHILE_LOOP
	LC R2, OS_KBSR_ADDR   ; R2 = address of keyboard status reg 
	LDR R2, R2, #0		    ; R2 = value of keyboard status reg
	BRzp WHILE_LOOP		    ; if R2[15] = 1, data is waiting

	LC R5, OS_KBDR_ADDR   ; R5 = address of keyboard data reg
	LDR R5, R5, #0		    ; load the input into R5
	CMPI R5, x0A		      ; set NZP R5-x0A
	BRz END_LOOP          ; if R5-x0A == 0 (enter), end the loop
	STR R5, R0, #0  	    ; store key data back into r0
	ADD R1, R1, #1		    ; add the lenth by 1
  ADD R0, R0, #1		    ; move to next address
	BRnzp WHILE_LOOP 		  ; goto WHILE_LOOP

END_LOOP
  CONST R6 x00 		; let R4 be NULL
  STR R6, R0, #0	; store NULL back to R0
RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_PUTS   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Put a string of characters out to ASCII display
;;; Inputs           - R0 = Address for first character
;;; Outputs          - none

.CODE
TRAP_PUTS

;;
;; TO DO: complete this trap
;; check the value of R0, is it a valid address in User Data memory
;; the user data memory for LC4 is from x2000 to x7FFF
;IF_DATAMEM 
  CONST R3, x00
  HICONST R3, x20
  CONST R4, x00
  HICONST R4, x80

  CMP R0, R3    ; R0 >= x2000
  BRn END_DATAMEM
  CMPU R0, R4    ; R0 < x8000
  BRzp END_DATAMEM

  WHILE
    ;; load the ASCII character from the address held in R0
    LDR R2, R0, #0

    CMPI R2, x00      ; hex code for null character is x00
    BRz END_DATAMEM   ; test R0 - x00 = 0? If yes, end the loop

    PUTC
      LC R1, OS_ADSR_ADDR   ; loop while ADSR[15] == 0
      LDR R1, R1, #0
      BRzp PUTC
      
      LC R1, OS_ADDR_ADDR
      STR R2, R1, #0        ; write R2 to ASCII display
      ADD R0, R0, #1        ; add the address by 1 
      BRnzp WHILE

  END_DATAMEM
  RTI 


;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_TIMER   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function:
;;; Inputs           - R0 = time to wait in milliseconds
;;; Outputs          - none

.CODE
TRAP_TIMER
  LC R1, OS_TIR_ADDR 	; R1 = address of timer interval reg
  STR R0, R1, #0    	; Store R0 in timer interval register

COUNT
  LC R1, OS_TSR_ADDR  	; Save timer status register in R1
  LDR R1, R1, #0    	; Load the contents of TSR in R1
  BRzp COUNT    	; If R1[15]=1, timer has gone off!

  ; reaching this line means we've finished counting R0

  RTI       		; PC = R7 ; PSR[15]=0



;;;;;;;;;;;;;;;;;;;;;;;   TRAP_GETC_TIMER   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Get a single character from keyboard
;;; Inputs           - R0 = time to wait
;;; Outputs          - R0 = ASCII character from keyboard (or NULL)

.CODE
TRAP_GETC_TIMER

  ;;
  ;; TO DO: complete this trap
  ;;

  RTI                  ; PC = R7 ; PSR[15]=0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TRAP_RESET_VMEM ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; In double-buffered video mode, resets the video display
;;; DO NOT MODIFY this trap, it's for future HWs
;;; Inputs - none
;;; Outputs - none
.CODE	
TRAP_RESET_VMEM
  LC R4, OS_VDCR_ADDR
  CONST R5, #1
  STR R5, R4, #0
  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TRAP_BLT_VMEM ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TRAP_BLT_VMEM - In double-buffered video mode, copies the contents
;;; of video memory to the video display.
;;; DO NOT MODIFY this trap, it's for future HWs
;;; Inputs - none
;;; Outputs - none
.CODE
TRAP_BLT_VMEM
  LC R4, OS_VDCR_ADDR
  CONST R5, #2
  STR R5, R4, #0
  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_DRAW_PIXEL   ;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Draw point on video display
;;; Inputs           - R0 = row to draw on (y)
;;;                  - R1 = column to draw on (x)
;;;                  - R2 = color to draw with
;;; Outputs          - none

.CODE
TRAP_DRAW_PIXEL
  LEA R3, OS_VIDEO_MEM       ; R3=start address of video memory
  LC  R4, OS_VIDEO_NUM_COLS  ; R4=number of columns

  CMPIU R1, #0    	         ; Checks if x coord from input is > 0
  BRn END_PIXEL
  CMPIU R1, #127    	     ; Checks if x coord from input is < 127
  BRp END_PIXEL
  CMPIU R0, #0    	         ; Checks if y coord from input is > 0
  BRn END_PIXEL
  CMPIU R0, #123    	     ; Checks if y coord from input is < 123
  BRp END_PIXEL

  MUL R4, R0, R4      	     ; R4= (row * NUM_COLS)
  ADD R4, R4, R1      	     ; R4= (row * NUM_COLS) + col
  ADD R4, R4, R3      	     ; Add the offset to the start of video memory
  STR R2, R4, #0      	     ; Fill in the pixel with color from user (R2)

END_PIXEL
  RTI       		         ; PC = R7 ; PSR[15]=0
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_DRAW_RECT   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: Draw a rectangle
;;; Inputs    R0: “x coordinate” of upper-left corner of the rectangle
;             R1: “y coordinate” of upper-left corner of the rectangle.
;             R2: length of the rectangle (in number of pixels across the display).
;             R3: width of the side of the rectangle (in number of pixels down the display).
;             R4: the color of the rectangle
;;; Outputs   none (just a picture)

.CODE
TRAP_DRAW_RECT

  ;;
  ;; TO DO: complete this trap
  ;;

;; boundary checking 
LC R5, OS_VIDEO_NUM_COLS  ; R5 = number of columns

CMPU R2, R5       ; check if length > 128
BRp END_DRAW
CMPIU R3, #123    ; check if width > 124
BRp END_DRAW

;; EC--
CMPIU R0, #0      ; check x coordinate >= 0
BRn RESET_COORD
CMPIU R0, #127    ; check x coordinate <= 127
BRp RESET_COORD

CMPIU R1, #0      ; check y coordinate >= 0
BRn RESET_COORD
CMPIU R1, #123    ; check y coordinate <= 123
BRp RESET_COORD

ADD R2, R2, R0    ; add the length
ADD R5, R2, #0    
CMPIU R2, #127    ; test the length
BRp CORRECT_HORI
;; EC--


CONTINUE  
ADD R3, R3, R1    ; R3 = R3 + R1
CMPIU R3, #124    ; test the width
BRzp END_DRAW

CONST R5, x20     ; set R5 to x2020
HICONST R5, x20
STR R0, R5, #0


;; pseudocode:
;; loop through each pixel in row (y)
;;    loop through each pixel in column (x) in this row
;;  row += 1

ROW_OUTER_LOOP
  CONST R5, x20
  HICONST R5, x20
  CMPU R1, R3               ; check if R1 > R3
  BRzp END_ROW_OUTER_LOOP   ; end the loop when R1 >= R3
  LDR R0, R5, #0            ; load R5 to R0
  
  COLUMN_INNER_LOOP
    CMPU R0, R2               ; check if R0 > R2
    BRzp END_COLUMN_INNER_LOOP; end the inner loop when R0 >= R2
    LC R5, OS_VIDEO_NUM_COLS  ; set R5 to 128 for further calculation
    CONST R6, x00             ; set R6 to xC000 for further calculation
    HICONST R6, xC0

    MUL R5, R5, R1     ; R5 = 128*y
    ADD R5, R5, R0     ; R5 = (128*y)+x
    ADD R5, R5, R6     ; R5 = (128*y)+x + xC000
    STR R4, R5, #0     ; give the color
    ADD R0, R0, #1     ; add x by 1
    BRnzp COLUMN_INNER_LOOP
  END_COLUMN_INNER_LOOP

  ADD R1, R1, #1       ; add y by 1
  BRnzp ROW_OUTER_LOOP

END_ROW_OUTER_LOOP

JMP END_DRAW

;;EC--
RESET_COORD
  CONST R0, #0    ; reset the x-coord to 0
  CONST R1, #0    ; reset the y-coord to 0
  JMP CONTINUE

CORRECT_HORI
  LC R5, OS_VIDEO_NUM_COLS
  ADD R5, R5, #-1
  SUB R5, R2, R5    ; R5 = R2 - 127 (the part that exceeds the boundary [0,127])
  ADD R1, R5, #0    ; R1 = R5

  CONST R5, #0
  ADD R0, R5, #0    ; R0 = 0 (starting from the very start)
  JMP CONTINUE
;;EC--

END_DRAW
  RTI


;;;;;;;;;;;;;;;;;;;;;;;;;;;   TRAP_DRAW_SPRITE   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Function: EDIT ME!
;;; Inputs    EDIT ME!
;;; Outputs   EDIT ME!

.CODE
TRAP_DRAW_SPRITE

  ;;
  ;; TO DO: complete this trap
  ;;

  RTI


;; TO DO: Add TRAPs in HW