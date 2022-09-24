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

// // Exercise 1-15. Rewrite the temperature conversion program of Section 1.2 to
// // use a function for conversion

// # define LOWER 0
// # define UPPER 300
// # define STEP 20

// float fahrToCel(int fahr);

// int main(void) {
//   float fahr, cel;
//   fahr = LOWER;

//   while(fahr <= UPPER) {
//     cel = fahrToCel(fahr);
//     printf("%3.0f %6.1f\n", fahr, cel);
//     fahr = fahr + STEP;
//   }

// }

// float fahrToCel(int fahr) {
//   float cel = (5.0/9.0) * (fahr-32.0);
//   return cel;
// }

// // Exercise 1-16. Revise the main routine of the longest-line program so it will
// // correctly print the length of arbitrarily long input lines, and as much as possible
// // of the text. 

// #define MAXLEN 10       /* maximum input line length */

// /* functions */
// int  getLine(char [], int);
// void copy(char [], char []);

// /* getLine function: read a line into s, return length */
// int getLine(char s[], int lim)
// {
// 	int c, i;

// 	for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
// 		s[i] = c;
//   }

// 	if (c == '\n') {
// 		s[i] = c;
// 		++i;
// 	}

// 	s[i] = '\0';

// 	return i;
// }

// /* copy function: copy 'from' into 'to'; assume to is big enough */
// void copy(char to[], char from[])
// {
// 	int i;

// 	i = 0;
// 	while ((to[i] = from[i]) !='\0') {
// 		++i;
//   }
// }

// int main(void)
// {
// 	int len;                /* current line length */
// 	int nextLen;            /* next line length */
// 	int max;                /* maximum length seen so far */
// 	char line[MAXLEN];      /* current input line */
// 	char nextLine[MAXLEN];  /* next input line */
// 	char longest[MAXLEN];   /* longest line saved here */

// 	max = 0;
// 	while ((len = getLine(line, MAXLEN)) > 0) {
// 		if (len == MAXLEN - 1) { /* is line longer than buffer size? */
// 			line[MAXLEN - 1] = '\n';
// 			nextLen = len;
// 			while (nextLen == MAXLEN - 1) { /* find the line's length */
// 				nextLen = getLine(nextLine, MAXLEN);
// 				len += nextLen;
// 			}
// 		}
// 		if  (len > max) {
// 			max = len;
// 			copy(longest, line);
// 		}

//     if (max > 0) {            /* there was a line */
//       printf("%s -> %i\n", longest, max);
//     }
// 	}

// 	return 0;
// }

// // Exercise 1-17. Write a program to print all input lines that are longer than 80 characters.

// # define MAXLEN 1000
// # define THRESHOLD 80

// int getLine(char[], int);

// int main(void)
// {
// 	int len;                /* current line length */
// 	char line[MAXLEN];      /* current input line */
//   int i;

// 	while ((len = getLine(line, MAXLEN)) > 0) {
//     if (len > THRESHOLD) {
//       for(i = 0; i < len; ++i) {
//         printf("%c", line[i]);
//       }
//     }
// 	}

// 	return 0;
// }


// /* getLine function: read a line into s, return length */
// int getLine(char s[], int lim)
// {
// 	int c, i;

// 	for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
// 		s[i] = c;
//   }

// 	if (c == '\n') {
// 		s[i] = c;
// 		++i;
// 	}

// 	s[i] = '\0';

// 	return i;
// }

// // Exercise 1-18. Write a program to remove trailing blanks and tabs from each line of input, 
// // and to delete entirely blank lines.

// # define MAXLEN 1000
// # define EMPTY 0
// # define NOT_EMPTY 1

// int getLine(char[], int);

// int main(void)
// {
// 	int len;                /* current line length */
// 	char line[MAXLEN];      /* current input line */
//   int i;
//   int nonBlankEOL;
//   int isEmpty = EMPTY;


// 	while ((len = getLine(line, MAXLEN)) > 0) {
//     for(i = len - 1; i >= 0 && isEmpty == EMPTY; --i) {
//       if((line[i] != ' ' && line[i] != '\t' && line[i] != '\n')) {
//         isEmpty = NOT_EMPTY;
//         nonBlankEOL = i + 1;
//       }
//     }

//     if(isEmpty == NOT_EMPTY) {
//       printf("Length: %d\n", nonBlankEOL);
//       for(i = 0; i < nonBlankEOL; ++i) {
//         printf("%c", line[i]);
//       }
//     }

//     isEmpty = EMPTY;

// 	}

// 	return 0;
// }


// /* getLine function: read a line into s, return length */
// int getLine(char s[], int lim)
// {
// 	int c, i;

// 	for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
// 		s[i] = c;
//   }

// 	if (c == '\n') {
// 		s[i] = c;
// 		++i;
// 	}

// 	s[i] = '\0';

// 	return i;
// }

// // Exercise 1-19. Write a function reverse(s) that reverses the character string s. Use it to 
// // write a program that reverses its input a line at a time. 

// # define MAXLEN 1000

// int getLine(char[], int);

// int main(void)
// {
// 	int len;                /* current line length */
// 	char line[MAXLEN];      /* current input line */
//   int i;


// 	while ((len = getLine(line, MAXLEN)) > 0) {
//     for(i = len - 1; i >= 0; --i) {
//       printf("%c", line[i]);
//     }

// 	}

// 	return 0;
// }


// /* getLine function: read a line into s, return length */
// int getLine(char s[], int lim)
// {
// 	int c, i;

// 	for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
// 		s[i] = c;
//   }

// 	if (c == '\n') {
// 		s[i] = c;
// 		++i;
// 	}

// 	s[i] = '\0';

// 	return i;
// }

