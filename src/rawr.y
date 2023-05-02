// BISON FILE 

%{ 
#include <stdio.h> 
extern FILE* yyin;   
%}

%start prog_start

%token ADD SUB MULT DIV EQUALS
%token L_PAR R_PAR L_BRACE R_BRACE L_BRACKET R_BRACKET
%token EQS_TO NOT_EQS_TO G_THAN G_THAN_EQUALS L_THAN L_THAN_EQUALS AND OR
%token SEMICOLON COLON COMMA
%token INT IF ELSE WHILE BR CONT READ WRITE MAIN RET FUNCT ARRAY NUMBER VARIABLE

%%

prog_start: %empty { printf("prog_start -> epsilon"); }
        |   function { printf("prog_start -> function \n"); }
        ; 

function: main { printf("function -> main \n"); }

main: %empty ;

statements: %empty ;

%%

void main(int argc, char** argv){
    if (argc >= 2)
    {
        yyin = fopen(argv[1], "r"); 
        if (yyin == NULL)
            yyin = stdin; 
    } else {
        yyin = stdin; 
    }
    yyparse();
}

int yyerror () {
   fprintf (stderr, "Invalid Syntax!!!");
 }