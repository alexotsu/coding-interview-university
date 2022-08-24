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



// // - Exercise 1.8. Write a program to count blanks, tabs, and newlines.
// int main(void) {
//   int c, blank, tab, newline;
//   blank = 0;
//   tab = 0;
//   newline = 0;
//   printf("%10s %10s %10s\n", "Blanks", "Tabs", "Newlines"); 
//   while((c = getchar()) != EOF) {
//     if(c == ' ')
//       ++blank;
//     if(c == '\t')
//       ++tab;
//     if(c == '\n')
//       ++newline;
//     printf("%10d %10d %10d\n", blank, tab, newline);
//   }

//   return 0;
// }

// // - Exercise 1-9. Write a program to copy its input to its output, replacing each
// // string of one or more blanks by a single blank.

// # define BLANK      1
// # define NOTBLANK   0
// int main(void) {
//   int c;
//   int lastChar = NOTBLANK;
//   while((c = getchar()) != EOF) {
//     if(c != ' ')
//       lastChar = NOTBLANK;
//     if(lastChar == NOTBLANK)
//       putchar(c);
//     if(c == ' ')
//       lastChar = BLANK;
//   }

//   return 0;
// }

// // - Exercise 1-10. Write a program to copy its input to its output, replacing each
// // tab by \t, each backspace by \b, and each backslash by \\. This makes tabs
// // and backspaces visible in an unambiguous way.
// // @note wasn't really supposed to use else if but it's ok
// # define BACKSPACE '\b'
// # define TAB '\t'
// # define BACKSLASH '\\'

// int main(void) {
//   int c;
//   while((c = getchar()) != EOF) {
//     if(c == BACKSPACE)
//       printf("%s", "\\b");
//     else if(c == TAB)
//       printf("%s", "\\t");
//     else if(c == BACKSLASH)
//       printf("%s", "\\\\");
//     else
//       putchar(c);
//   }
// }

// #define YES 1
// #define NO  0 

// int main(void)
// {
// 	int c, charReplaced; 

// 	while ((c = getchar()) != EOF) {
// 		charReplaced = NO;
// 		if (c == '\t') {
// 			printf("\\t");
// 			charReplaced = YES;
// 		}
// 		if (c == '\b') {
// 			printf("\\b");
// 			charReplaced = YES;
// 		}
// 		if (c == '\\') {
// 			printf("\\\\");
// 			charReplaced = YES;
// 		}
// 		if (charReplaced == NO)
// 			putchar(c);
// 	}
// 	return 0;
// }


// // Exercise 1-12. Write a program that prints its input one word per line.

// # define IN 1
// # define OUT 0

// int main(void) {
//   int c, nl, nw, nc, state;

//   state = OUT;
//   nl = nw = nc = 0;
//   while((c = getchar()) != EOF) {
//     ++nc;

//     if(c == '\n') {
//       ++nl;
//     }

//     if(c == ' ' || c == '\n' || c == '\t') {
//       state = OUT;
//     } else if (state == OUT) {
//       printf("\n");
//       state = IN;
//       ++nw;
//     }

//     if(state == IN ) {
//       putchar(c);
//     }
    
//   }
// }

// // Exercise 1-13. Write a program to print a histogram of the lengths of words in
// // its input. It is easy to draw the histogram with the bars horizontal; a vertical
// // orientation is more challenging.

// // 1. find word boundaries
// // 2. find word length

// # define IN 1
// # define OUT 0
// # define MAX_LENGTH 8

// int main(void) {
//   int c, i, wordLength, state;
//   int arrayLength = MAX_LENGTH + 1;
//   int wordLengths[MAX_LENGTH + 1];

//   state = IN;
//   wordLength = i = 0;
//   for(i; i < arrayLength; ++i) {
//     wordLengths[i] = 0;
//   }

//   while((c = getchar()) != EOF) {

//     if(c == ' ' || c == '\t' || c == '\n') {
//       state = OUT;
//     }

//     if(state == IN) {
//       ++wordLength;
//     }
    
//     if (state == OUT) {
//       if(wordLength > MAX_LENGTH) {
//         wordLength = MAX_LENGTH;
//       }
//       if(wordLength > 0) {
//         ++wordLengths[wordLength];
//       }
//       wordLength = 0;
//       state = IN;
//     }

//     if(c == '\n'){
//       for(i = 1; i < arrayLength; ++i) {
//         if(i == MAX_LENGTH) {
//           printf("%d+: ", i);  
//         } else {
//           printf("%d:  ", i);
//         }
//         if (wordLengths[i] > 0) {
//           printf("%0*d\n", wordLengths[i], 0);
//         } else {
//           printf("\n");
//         }
//       }
//     }

//   }
// }

// // Exercise 1-14. Write a program to print a histogram of the frequencies of different characters in its input.

// # define CHARS 256

// int main(void) {
//   int charCount[CHARS];
//   int i = 0;
//   int c;
//   for(i = 0; i < CHARS; ++i) {
//     charCount[i] = 0;
//   }

//   while((c = getchar()) != EOF) {
//     ++charCount[c];
//     if(c == '\n'){
//       for(i = 0; i < CHARS; ++i) {
//         if (charCount[i] > 0) {
//           if (i == '\n') {
//             printf("newline:");
//           } else if (i == ' ') {
//             printf("%7s:", "space");
//           } else if (i == '\t') {
//             printf("%7s:", "tab");
//           } else {
//             printf("%7c:", i);
//           }
//           printf("%0*d\n", charCount[i], 0);
//         }
//       }
//     }
//   }

// }

// Exercise 1-15. Rewrite the temperature conversion program of Section 1.2 to
// use a function for conversion

# define LOWER 0
# define UPPER 300
# define STEP 20

float fahrToCel(int fahr);

int main(void) {
  float fahr, cel;
  fahr = LOWER;

  while(fahr <= UPPER) {
    cel = fahrToCel(fahr);
    printf("%3.0f %6.1f\n", fahr, cel);
    fahr = fahr + STEP;
  }

}

float fahrToCel(int fahr) {
  float cel = (5.0/9.0) * (fahr-32.0);
  return cel;
}