// Exercise 1-21. Write a program entab that replaces strings of blanks by the minimum 
// number of tabs and blanks to achieve the same spacing. Use the same tab stops as for detab. 
// When either a tab or a single blank would suffice to reach a tab stop, which should be given 
// preference?

# include <stdio.h>

# define MAX_LENGTH 1000
# define TAB_WIDTH 4

int getLine(char[], int);
void entab(char[], char[]);

int main(void) {
  int len;
  char line[MAX_LENGTH];
  char modifiedLine[MAX_LENGTH];
  while((len = getLine(line, MAX_LENGTH)) > 0) {
    entab(line, modifiedLine);
    printf("%s\n", modifiedLine);
  }
}

/* getline: read a line into s, return length */ 
int getLine(char s[],int lim) { 
  int c, i; 
  for (i=0; i < lim-1 && (c=getchar())!=EOF && c!='\n'; ++i) {
    s[i] = c; 
  }

  if (c == '\n') { 
    s[i] = c; 
    ++i; 
  }

  s[i] = '\0'; 
  return i; 
} 

void entab(char in[], char out[]) {
  int i, j;
  int charCounter, spaceStrengthLength, widthEquivalentCounter;
  charCounter = spaceStrengthLength = widthEquivalentCounter = 0;
  for(i = j = 0; in[i] != '\0'; ++i) {
    if(in[i] == ' ') {
      if(spaceStrengthLength == TAB_WIDTH) {
        ++widthEquivalentCounter;
        spaceStrengthLength = 0;
      }
      ++spaceStrengthLength;

    } else if(in[i] != ' ') {
      if(widthEquivalentCounter > 0) {
        for(j; j < widthEquivalentCounter + j; ++j) {
          out[j] = '\t';
        }
      }
      if(spaceStrengthLength > 0) {
        for(j; j < spaceStrengthLength + j; ++j) {
          out[j] = ' ';
        }
      }

      out[j] = in[i];
      ++j;

    }
  }
}