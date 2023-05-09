// BISON FILE 

%{ 
#include <stdio.h> 
extern FILE* yyin;   

int integers = 0, operators = 0, parentheses = 0, equals = 0;
%}

%start prog_start

%token ADD SUB MULT DIV EQUALS
%token L_PAR R_PAR L_BRACE R_BRACE L_BRACKET R_BRACKET
%token EQS_TO NOT_EQS_TO G_THAN G_THAN_EQUALS L_THAN L_THAN_EQUALS AND OR
%token SEMICOLON COLON COMMA
%token INT IF ELSE WHILE BR CONT READ WRITE MAIN RET FUNCT ARRAY NUMBER VARIABLE CONST

%%

prog_start: functions { printf("prog_start -> functions \n"); }
        ; 

functions: function functions { printf("functions -> function functions \n"); } 
        | function { printf("functions -> function \n"); }
        ;

function: main { printf("function -> main \n"); }
        | CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("function -> CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE \n"); } 
        ;

main: CONST INT MAIN L_PAR R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("main -> CONST INT MAIN L_PAR R PAR L_BRACE statements RET r_var SEMICOLON R_BRACE \n"); }
        ;

arguments: argument COMMA arguments { printf("arguments -> argument COMMA arguments \n"); }
        | argument { printf ("arguments -> argument \n"); }
        ;

argument: INT VARIABLE { printf("argument -> INT VARIABLE \n"); }
        | INT ARRAY L_BRACKET r_var R_BRACKET { printf("argument -> INT ARRAY L_BRACKET r_var R_BRACKET \n"); }
        ;

statements: statement statements { printf ("statements -> statement statements \n"); }
        | statement { printf("statements -> statement \n"); }
        ;


statement: conditional { printf("statement -> conditional \n"); }
        | loop { printf("statement -> loop \n"); }
        | read { printf("statement -> read \n"); }
        | write { printf("statement -> write \n"); }
        | BR SEMICOLON { printf("statement -> BR SEMICOLON \n"); }
        | assignment { printf("statement -> assignment \n"); }
        | initialization { printf("statement -> initialization \n"); }
        ;

read: READ L_PAR r_var R_PAR SEMICOLON { printf("read -> READ L_PAR r_var R_PAR SEMICOLON \n"); }
    ;

write: WRITE L_PAR r_var R_PAR SEMICOLON { printf("write -> WRITE L_PAR r_var R_PAR SEMICOLON \n"); }
    ;

conditional: IF L_PAR conditions R_PAR L_BRACE statements R_BRACE SEMICOLON { printf("conditional -> IF L_PAR conditions R_PAR L_BRACE statements R_BRACE SEMICOLON \n"); }
        | IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE SEMICOLON { printf("conditional -> IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE SEMICOLON \n"); }
        ;

loop: WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE SEMICOLON { printf("loop -> WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE SEMICOLON \n"); }
    ;

conditions: condition { printf("conditions -> condition \n"); }
        | condition OR conditions { printf("conditions -> condition OR conditions \n"); }
        | condition AND conditions { printf("conditions -> condition AND conditions \n"); }
        ;

condition: r_var EQS_TO r_var { printf("condition -> r_var EQS_TO r_var \n"); }
        | r_var G_THAN_EQUALS r_var { printf("condition -> r_var G_THAN_EQUALS r_var \n"); }
        | r_var L_THAN_EQUALS r_var { printf("condition -> r_var L_THAN_EQUALS r_var \n"); }
        | r_var G_THAN r_var { printf("condition -> r_var G_THAN r_var \n"); }
        | r_var L_THAN r_var { printf("condition -> r_var L_THAN r_var \n"); }
        | r_var NOT_EQS_TO r_var { printf("condition -> r_var NOT_EQS_TO r_var \n"); }
        ;

r_var: NUMBER { printf("r_var -> NUMBER \n"); integers++ ;} 
    | VARIABLE { printf("r_var -> VARIABLE \n"); }
    | ARRAY L_BRACKET NUMBER R_BRACKET { printf("r_var -> ARRAY L_BRACKET NUMBER R_BRACKET \n"); }
    | ARRAY L_BRACKET VARIABLE R_BRACKET { printf("r_var -> ARRAY L_BRACKET VARIABLE R_BRACKET \n"); }
    ;

assignment: INT VARIABLE EQUALS r_var SEMICOLON { printf("assignment -> INT VARIABLE EQUALS r_var SEMICOLON \n"); } 
        | INT VARIABLE EQUALS expressions SEMICOLON { printf("assignment -> INT VARIABLE EQUALS expressions SEMICOLON \n"); } 
        | VARIABLE EQUALS r_var SEMICOLON { printf("assignment -> VARIABLE EQUALS r_var SEMICOLON \n"); } 
        | VARIABLE EQUALS expressions SEMICOLON { printf("assignment -> VARIABLE EQUALS expressions SEMICOLON \n"); } 
        | ARRAY L_BRACKET r_var R_BRACKET EQUALS r_var SEMICOLON { printf("assignment -> ARRAY L_BRACKET r_var R_BRACKET EQUALS r_var SEMICOLON \n"); } 
        | ARRAY L_BRACKET r_var R_BRACKET EQUALS expressions SEMICOLON { printf("assignment -> ARRAY L_BRACKET r_var R_BRACKET EQUALS expressions \n"); } 
        ;

initialization: INT VARIABLE SEMICOLON { printf("initialization -> INT VARIABLE SEMICOLON \n"); } 
        | INT ARRAY L_BRACKET r_var R_BRACKET SEMICOLON { printf("initialization -> INT ARRAY L_BRACKET r_var R_BRACKET SEMICOLON \n"); } 
        ; 

expressions: expression op expressions { printf("expressions -> expression op expressions \n"); } 
        | expression { printf("expressions -> expression \n"); } 
        ;

op: ADD { printf("op -> ADD \n"); } 
    | SUB { printf("op -> SUB \n"); } 
    | DIV { printf("op -> DIV \n"); } 
    | MULT { printf("op -> MULT \n"); } 
    ;

expression: r_var op r_var { printf("expression -> r_var op r_var \n"); } 
    ;

%%


int yyerror (const char *mssg) {
    extern int yylineno;
   fprintf (stderr, "Invalid Syntax! On Line: %d \n", yylineno);
   return 1; 
 }

int main(int argc, char** argv){
    if (argc >= 2)
    {
        yyin = fopen(argv[1], "r"); 
        if (yyin == NULL)
            yyin = stdin; 
    } 
    else {
        yyin = stdin; 
    }
    if (yyparse() != 0){
        fprintf(stderr, "failed\n"); 
        return 1; 
    }

    printf("Total Count of Variables: %d Integers, %d Operators, %d Parentheses, %d Equal Signs \n", integers, operators, parentheses, equals);

    return 0;
}
