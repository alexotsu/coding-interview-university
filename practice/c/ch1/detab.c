// Exercise 1-20. Write a program detab that replaces tabs in the input with the proper number 
// of blanks to space to the next tab stop. Assume a fixed set of tab stops, say every n columns. 
// Should n be a variable or a symbolic parameter? 

# include <stdio.h>

# define TAB_WIDTH 4

int main(void) {
  int c; // char input
  int i; // incrementor
  int charCounter;

  i = 0;

  while((c = getchar()) != EOF) {

    if(charCounter == TAB_WIDTH) {
      charCounter = 0;
    }

    if(c == '\t') {
      charCounter = TAB_WIDTH - charCounter;
      for(i = 0; i < charCounter; ++i) {
        putchar(' ');
      }
      charCounter = 0;
    } else {
      putchar(c);
      ++charCounter;
    }

  }
}