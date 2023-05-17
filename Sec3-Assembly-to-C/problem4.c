/********************************************************
 * file name   : problem4.c                             *
 * author      : 
 * description : C program to call LC4-Assembly TRAP_PUTC
 *               the TRAP is called through the wrapper 
 *               lc4putc() (located in lc4_stdio.asm)   *
 ********************************************************
*
*/

int main() {

	char typein[14] = {'I', ' ', 'L', 'O', 'V', 'E', ' ', 'C', 'I', 'T', '5', '9', '3', '\0'};
	//call lc4_puts()
	lc4_puts(typein);
	
	return (0) ;

}
