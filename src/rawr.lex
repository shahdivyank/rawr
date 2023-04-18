%{
#include <stdio.h>
int row = 1, col = 1;
%}

DIGIT [0-9]
SINGLE_COMMENT "//".*"\n"
MULTI_COMMENT "/*".*"*/"
VARIABLES [a-zA-Z]*["_"*"-"*]*[a-zA-Z0-9]+

%%
{SINGLE_COMMENT}  {} 
{MULTI_COMMENT}   {}
"\n"              { printf("\n"); row++; } 
"+"               { printf("ADD\n"); col++; }
"-"               { printf("SUB\n"); col++; }
" "               {} // don't print anything
"*"               { printf("MULT\n"); col++; }
"/"               { printf("DIV\n"); col++; }
"("               { printf("L_PAR\n"); col++; }
")"               { printf("R_PAR\n"); col++; }
"{"               { printf("L_BRACE\n"); col++; }
"}"               { printf("R_BRACE\n"); col++; }
"["               { printf("L_BRACKET\n"); col++; }
"]"               { printf("R_BRACKET\n"); col++; }
"="               { printf("EQUALS\n"); col++; }
"=="              { printf("EQS_TO\n"); col += 2; }
"!="              { printf("NOT_EQS_TO\n"); col += 2; }
">"               { printf("G_THAN\n"); col++; }
">="              { printf("G_THAN_EQUALS\n"); col += 2; }
"<"               { printf("L_THAN\n"); col++; }
"<="              { printf("L_THAN_EQUALS\n"); col += 2; }
"&&"              { printf("AND\n"); col += 2; }
"||"              { printf("OR\n"); col += 2; }
";"               { printf("SEMICOLON\n"); col++; }
":"               { printf("COLON\n"); col++; }
","               { printf("COMMA\n"); col++; }
"int"             { printf("INT\n"); col += 3; }
"if"              { printf("IF\n"); col += 2; }
"else"            { printf("ELSE\n"); col += 4; }
"while"           { printf("WHILE\n"); col += 5; }
"break"           { printf("BR\n"); col += 5; }
"continue"        { printf("CONT\n"); col += 8; }
"rin"             { printf("READ\n"); col += 3; }
"rout"            { printf("WRITE\n"); col += 4; }
"main"            { printf("MAIN\n"); col += 4; }
"return"          { printf("RET\n"); col += 6; }
"const"           { printf("FUNCT\n"); col += 5; }
"."               { printf("**Error. Unidentified token '%s'\n", yytext); }
{DIGIT}+          { printf("NUMBER: %s\n", yytext); }
[0-9]{VARIABLES}  { printf("GG BOIS: %s\n", yytext); }
"_"{VARIABLES}    { printf("GG BOIS: %s\n", yytext); }
"-"{VARIABLES}    { printf("GG BOIS: %s\n", yytext); }
{VARIABLES}"-"    { printf("GG BOIS: %s\n", yytext); }
{VARIABLES}"_"    { printf("GG BOIS: %s\n", yytext); }
{VARIABLES}       { printf("VARIABLE: %s\n", yytext); col += yyleng; }

%%

int main(void) {
  printf("Ctrl+D to quit\n");
  yylex();
}