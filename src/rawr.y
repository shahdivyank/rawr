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
%token INT IF ELSE WHILE BR CONT READ WRITE MAIN RET FUNCT ARRAY NUMBER

%%

prog_start: %empty { printf("prog_start -> epsilon"); }
        |   main { printf("prog_start -> main \n"); }
        ; 

main:       INT MAIN L_PAR R_PAR L_BRACE R_BRACE { printf("main function detected"); } 
        ;

%%

void main(int argc, char** argv){
    if (argc >=2)
    {
        yyin = fopen(argv[1], "r'"); 
        if (yyin == NULL)
            yyin =stdin; 
        else
            yyin = stdin; 
    }
    yyparse();
}
