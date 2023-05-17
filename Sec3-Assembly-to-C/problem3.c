/********************************************************
 * file name   : problem3.c                             *
 * author      : 
 * description : C program to call LC4-Assembly TRAP_PUTC
 *               the TRAP is called through the wrapper 
 *               lc4putc() (located in lc4_stdio.asm)   *
 ********************************************************
*
*/

int main() {

	char a;

	// while enter is not pressed
	while (a != '\n'){
	// get the char
	a = lc4_getc();
	// put the char into display
	lc4_putc(a);
	}
	
	return (0) ;

}
