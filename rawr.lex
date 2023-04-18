%{
#include <stdio.h>
%}

DIGIT [0-9]
ALPHA [a-zA-Z]

%%
{DIGIT}+   { printf("NUMBER: %s\n", yytext); }
{ALPHA}+   { printf("WORD:   %s\n", yytext); }
"+"        { printf("PLUS\n"); }
"-"        { printf("MINUS\n"); }
" "        {} // don't print anything
"*"        {}
"/"        {}
"("        {}
")"        {}
"{"        {}
"}"        {}
"["        {}
"]"        {}
"="        {}
"=="       {}
"!="       {}
">"        {}
">="       {}
"<"        {}
"<="       {}
"&&"       {}
"||"       {}
";"        {}
","        {}
"."        {}






.          { printf("**Error. Unidentified token '%s'\n", yytext); }



%%

int main(void) {
  char *number = "1234";
  printf("Ctrl+D to quit\n");
  yylex();
}