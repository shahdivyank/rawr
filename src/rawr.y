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
%token CONST

%%

prog_start: %empty { printf("prog_start -> epsilon \n"); }
        |   functions { printf("prog_start -> functions \n"); }
        ; 

functions: function functions { printf("functions -> function functions \n"); } 
        | function { printf("functions -> function"); }

function: main { printf("function -> main"); }
        | CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("function -> CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE"); } 

main: CONST INT main L_PAR R PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("main -> CONST INT main L_PAR R PAR L_BRACE statements RET r_var SEMICOLON R_BRACE"); }




// define argumentm, statements

math_operators: ADD {printf ("math_operators -> ADD\n"); } 
    | SUB {printf ("math_operators -> SUB\n");}
    | MULT {printf ("math_operators -> MULTN\n");} 
    | DIV {printf ("math_operators -> DIVN\n");}

logical_op : AND { printf ("logical_op -> AND\n"); }
    | OR { printf ("logical_op -> OR\n"); }

assignment_op : = { printf ("assignment_op ->  EQUALS\n"); }

COMPARISON_OP : EQS_TO = { printf ("COMPARISON_OP -> EQS_TO\n"); }
    | NOT_EQS_TO { printf ("COMPARISON_OP -> NOT_EQS_TO\n"); }
    | G_THAN_EQUALS { printf ("COMPARISON_OP -> G_THAN_EQUALS\n");}
    | L_THAN_EQUALS{ printf ("COMPARISON_OP -> L_THAN_EQUALS\n");}
%%


void main(int argc, char** argv){
    if (argc >= 2)
    {
        yyin = fopen(argv[1], "r"); 
        if (yyin == NULL)
            yyin = stdin; 
    } 
    else {
        yyin = stdin; 
    }
    yyparse();
}

int yyerror () {
   fprintf (stderr, "Invalid Syntax!!! \n");
 }