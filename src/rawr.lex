%{
#include <stdio.h>
#include "y.tab.h"
int row = 1, col = 1;
%}

DIGIT [0-9]
SINGLE_COMMENT "//".*"\n"
MULTI_COMMENT "/*".*"*/"
VARIABLES [a-zA-Z]*["_"*"-"*]*[a-zA-Z0-9]+

%%

{SINGLE_COMMENT}  { row++; col = 0; } 
{MULTI_COMMENT}   {}
" "               { col++; } 
"\n"              { row++; col = 0; } 
"+"               { col++; }
"-"               { col++; }
"*"               { col++; }
"/"               { col++; }
"("               { col++; }
")"               { col++; }
"{"               { col++; }
"}"               { col++; }
"["               { col++; }
"]"               { col++; }
"="               { col++; }
"=="              { col += 2; }
"!="              { col += 2; }
">"               { col++; }
">="              { col += 2; }
"<"               { col++; }
"<="              { col += 2; }
"&&"              { col += 2; }
"||"              { col += 2; }
";"               { col++; }
":"               { col++; }
","               { col++; }
"int"             { col += 3; }
"if"              { col += 2; }
"else"            { col += 4; }
"while"           { col += 5; }
"break"           { col += 5; }
"continue"        { col += 8; }
"rin"             { col += 3; }
"rout"            { col += 4; return WRITE;}
"main"            { col += 4; return MAIN;}
"return"          { col += 6; }
"const"           { col += 5; }
"arr"             { col += 3; }
{DIGIT}+          { col += yyleng; }
[0-9]{VARIABLES}  { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT START WITH A NUMBER: %s\n", row, col + 1, yytext); }
"_"{VARIABLES}    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT START WITH A UNDERSCORE: %s\n", row, col + 1, yytext); }
"-"{VARIABLES}    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT START WITH A HYPHEN: %s\n", row, col + 1, yytext); }
{VARIABLES}"-"    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT END WITH A HYPEN: %s\n", row, col + 1, yytext); }
{VARIABLES}"_"    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT END WITH A UNDERSCORE %s\n", row, col + 1, yytext); }
{VARIABLES}       { printf("VARIABLE: %s\n", yytext); col += yyleng; }
.                 { printf("ERROR: ROW: %d COL: %d. UNRECOGNIZED TOKEN %s\n", row, col + 1, yytext); }

%%