%{
#include <stdio.h>
%}

DIGIT [0-9]
ALPHA [a-zA-Z]

%%
{DIGIT}+   { printf("NUMBER: %s\n", yytext); }
{ALPHA}+   { printf("WORD:   %s\n", yytext); }

"+"        { printf("ADD\n"); }
"-"        { printf("SUB\n"); }
" "        {} // don't print anything
"*"        { printf("MULT\n"); }
"/"        { printf("DIV\n"); }
"("        { printf("L_PAR\n"); }
")"        { printf("R_PAR\n"); }
"{"        { printf("L_BRACE\n"); }
"}"        { printf("R_BRACE\n"); }
"["        { printf("L_BRACKET\n"); }
"]"        { printf("R_BRACKET\n"); }
"="        { printf("EQUALS\n"); }
"=="       { printf("EQS_TO\n"); }
"!="       { printf("NOT_EQS_TO\n"); }
">"        { printf("G_THAN\n"); }
">="       { printf("G_THAN_EQUALS\n"); }
"<"        { printf("L_THAN\n"); }
"<="       { printf("L_THAN_EQUALS\n"); }
"&&"       { printf("AND\n"); }
"||"       { printf("OR\n"); }
";"        { printf("SEMICOLON\n"); }
":"        { printf("COLON\n"); }
","        { printf("COMMA\n"); }
"if"       { printf("IF\n"); }
"else"       { printf("ELSE\n"); }
"while"       { printf("WHILE\n"); }
"break"       { printf("BR\n"); }
"continue"       { printf("CONT\n"); }
"rin"       { printf("READ\n"); }
"rout"       { printf("WRITE\n"); }
"main"       { printf("MAIN\n"); }
"return"       { printf("RET\n"); }
"const"       { printf("FUNCT\n"); }
"continue"       { printf("CONT\n"); }


.          { printf("**Error. Unidentified token '%s'\n", yytext); }



%%

int main(void) {
  printf("Ctrl+D to quit\n");
  yylex();
}