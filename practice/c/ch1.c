#include <stdio.h>

// // Exercise 1-1. Run the "hello, world" program on your system. Experiment
// // with leaving out parts of the program, to see what error messages you get.

// main()
// {
//   printf("hello, world\n");
// }


// // Exercise 1-2. Experiment to find out what happens when printf's argument
// // string contains \c, where c is some character not listed above.

// main() 

// {
//   printf("hello, world\n");
// }

// // format specifiers: https://www.tutorialspoint.com/format-specifiers-in-c

// main() {
//   float fahr, celsius;
//   int lower, upper, step;

//   lower = 0;
//   upper = 300;
//   step = 20;

//   fahr = lower;
//   while (fahr <= upper) {
//     celsius = (5.0/9.0) * (fahr-32.0);
//     printf("%3.0f %6.1f\n", fahr, celsius);
//     fahr = fahr + step;
//   }
// }

// // Exercise 1-7. Write a program to print the value of EOF
// // reference code:
// main() {
// 	int c, nl;
// 	while ((c = getchar()) != EOF)
//     if (c == '\n')
//       ++nl;
// 		// putchar(c);
//   printf("%d\n", nl);
// }

// main() {
//   printf("%3d", EOF);
// }



// - Exercise 1.8. Write a program to count blanks, tabs, and newlines.
int main(void) {
  int c, blank, tab, newline;
  blank = 0;
  tab = 0;
  newline = 0;
  printf("%10s %10s %10s\n", "Blanks", "Tabs", "Newlines"); 
  while((c = getchar()) != EOF) {
    if(c == ' ')
      ++blank;
    if(c == '\t')
      ++tab;
    if(c == '\n')
      ++newline;
    printf("%10d %10d %10d\n", blank, tab, newline);
  }

  return 0;
}

// - Exercise 1-9. Write a program to copy its input to its output, replacing each
// string of one or more blanks by a single blank.

// - Exercise 1-10. Write a program to copy its input to its output, replacing each
// tab by \ t, each backspace by \b, and each backslash by \ \. This makes tabs
// and backspaces visible in an unambiguous way.

// // 1.13:
// #define SIZE 5    /* size of lengths array */
// #define SCALE 1   /* adjust to accommodate large input */
// #define OUT  1    /* outside of a word */
// #define IN   0    /* inside of a word */

// int main(void)
// {
// 	int c, i, j, count, state;
// 	int lengths[SIZE]; /* words length ranges */

// 	for (i = 0; i <= SIZE; ++i)
// 		lengths[i] = 0;

// 	state = OUT;
// 	count = 0;
// 	while ((c = getchar()) != EOF) {

// 		if (c == ' ' || c == '\t' || c == '\n')
// 			state = OUT;
// 		else
// 			state = IN;

// 		if (state == IN)
// 			++count;

// 		if (state == OUT) {
// 			if (count < 4)
// 				++lengths[0];
// 			else if (count >= 4 && count < 8)
// 				++lengths[1];
// 			else if (count >= 8 && count < 12)
// 				++lengths[2];
// 			else if (count >= 12 && count < 14)
// 				++lengths[3];
// 			if (count >= 14)
// 				++lengths[4];
// 			count = 0;
// 		}
// 	}	

// 	printf("\nHorizontal Histogram\n");
// 	for (i = 0; i < SIZE; ++i) {
// 		printf(" %i\t", lengths[i]);
// 		for (j = 0; j < lengths[i] / SCALE; ++j)
// 			printf(" *");
// 		printf("\n");
// 	}

// 	return 0;
// }

