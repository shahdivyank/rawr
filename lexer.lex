%{
#include <stdio.h>
%}
DIGIT [0-9]
ALPHA [a-zA-Z]
%%
	// <TAB> Your comment. "1234"
{DIGIT}+   { printf("NUMBER: %s\n", yytext); }
{ALPHA}+   { printf("WORD:   %s\n", yytext); }
"+"        { printf("PLUS\n"); }
"-"        { printf("MINUS\n"); }
" "        {}
.          { printf("**Error. Unidentified token '%s'\n", yytext); }

%%

int main(void) {
  char *number = "1234";
  printf("Ctrl+D to quit\n");
  printf("Hello, My Name is %s\n", "Daniel");
  printf("The Answer to the Universe is: %d\n", 42);
  yylex();
}