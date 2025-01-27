%{
#include <stdio.h>
#include "y.tab.h"
int row = 1, col = 1;
%}

%option yylineno

DIGIT [0-9]
SINGLE_COMMENT "//".*"\n"
MULTI_COMMENT "/*".*"*/"
VARIABLE [a-zA-Z]*["_"*"-"*]*[a-zA-Z0-9]+

%%

{SINGLE_COMMENT}  { row++; col = 0; } 
{MULTI_COMMENT}   {}
" "               { col++; } 
"\n"              { row++; col = 0; } 
"+"               { col++; return ADD; }
"-"               { col++; return SUB; }
"*"               { col++; return MULT; }
"/"               { col++; return DIV; }
"("               { col++; return L_PAR; }
")"               { col++; return R_PAR; }
"{"               { col++; return L_BRACE; }
"}"               { col++; return R_BRACE; }
"["               { col++; return L_BRACKET; }
"]"               { col++; return R_BRACKET; }
"="               { col++; return EQUALS; }
"=="              { col += 2; return EQS_TO; }
"!="              { col += 2; return NOT_EQS_TO; }
">"               { col++; return G_THAN; }
">="              { col += 2; return G_THAN_EQUALS; }
"<"               { col++; return L_THAN; }
"<="              { col += 2; return L_THAN_EQUALS; }
"&&"              { col += 2; return AND; }
"||"              { col += 2; return OR; }
";"               { col++; return SEMICOLON; }
","               { col++; return COMMA; }
"int"             { col += 3; return INT; }
"if"              { col += 2; return IF; }
"else"            { col += 4; return ELSE; }
"while"           { col += 5; return WHILE; }
"break"           { col += 5; return BR; }
"continue"        { col += 8; return CONTINUE; }
"rin"             { col += 3; return READ; }
"rout"            { col += 4; return WRITE;}
"main"            { col += 4; return MAIN;}
"return"          { col += 6; return RET; }
"const"           { col += 5; return CONST; }
{DIGIT}+          { col += yyleng; 
    char * token = new char[yyleng];
    strcpy(token, yytext);
    yylval.character = token;
    return NUMBER; 
}
[0-9]{VARIABLE}  { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT START WITH A NUMBER: %s\n", row, col + 1, yytext); }
"_"{VARIABLE}    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT START WITH A UNDERSCORE: %s\n", row, col + 1, yytext); }
{VARIABLE}"-"    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT END WITH A HYPEN: %s\n", row, col + 1, yytext); }
{VARIABLE}"_"    { printf("ERROR: ROW: %d COL: %d. VARIABLE CANNOT END WITH A UNDERSCORE %s\n", row, col + 1, yytext); }
{VARIABLE}       {
    col += yyleng; 
    char * token = new char[yyleng];
    strcpy(token, yytext);
    yylval.character = token;
    return VARIABLE; 
    }
.                 { printf("ERROR: ROW: %d COL: %d. UNRECOGNIZED TOKEN %s\n", row, col + 1, yytext); }

%%