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
        ;

function: main { printf("function -> main"); }
        | CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("function -> CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE \n"); } 
        ;

main: CONST INT main L_PAR R PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("main -> CONST INT main L_PAR R PAR L_BRACE statements RET r_var SEMICOLON R_BRACE \n"); }
        ;

arguments: argument COMMA arguments { printf("arguments -> argument COMMA arguments \n"); }
        | argument { printf ("arguments -> argument \n"); }
        ;

argument: INT VARIABLE { printf("argument -> INT VARIABLE \n"); }
        | INT VARIABLE COMMA { printf ("argument -> INT VARIABLE COMMA \n"); }
        ;

statements: statement statements { printf ("statements -> statement statements \n"); }
        | statement { printf("statements -> statement \n"); }
        ;

statement: assignment { printf("statement -> assignment \n"); }
        | conditional { printf("statement -> conditional \n"); }
        | loop { printf(statement -> loop \n"); }
        | read { printf(statement -> read \n"); }
        | write { printf(statement -> write \n"); }
        | BR { printf(statement -> BR \n"); }
        ;

assignment: INT VARIABLE EQUALS NUMBER SEMICOLON { printf("assignment -> INT VARIABLE EQUALS NUMBER SEMICOLON \n"); }
        | VARIABLE EQUALS NUMBER SEMICOLON { printf("assignment -> VARIABLE EQUALS NUMBER SEMICOLON \n"); }
        | INT ARRAY L_BRACKET NUMBER R_BRACKET EQUALS NUMBER { printf("assignment -> INT ARRAY L_BRACKET NUMBER R_BRACKET EQUALS NUMBER \n"); }
        ;

conditional: IF L_PAR conditions R_PAR L_BRACE statements R_BRACE { printf("conditional -> IF L_PAR conditions R_PAR L_BRACE statements R_BRACE \n"); }
        | ELSE L_BRACE statements R_BRACE { printf("ELSE L_BRACE statements R_BRACE \n");}
        ;

conditions: condition { printf("conditions -> condition"); }
        | condition AND L_PAR conditions R_PAR { printf("conditions -> condition AND L_PAR condition R_PAR \n"); }
        | condition OR L_PAR conditions R_PAR { printf("condition OR L_PAR conditions R_PAR \n"); }
        ;

condition: r_var r_op r_var { printf("condition -> r_var r_op r_var \n"); }

r_var: NUMBER { printf("r_var -> NUMBER \n"); } 
    | VARIABLE { printf("r_var -> VARIABLE \n"); }
    ;

r_op: EQS_TO { printf("r_op -> EQS_TO \n"); }
    | L_THAN_EQUALS { printf("r_op -> L_THAN_EQUALS \n"); }
    | L_THAN { printf("r_op -> L_THAN \n"); }
    | G_THAN { printf("r_op -> G_THAN \n"); }
    | G_THAN_EQUALS { printf("r_op -> G_THAN_EQUALS \n"); }
    | NOT_EQS_TO { printf("r_op -> NOT_EQS_TO \n"); }
    ;

loop: WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE { printf("loop -> WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE \n"); }
    ;

write: rin L_PAR vars R_PAR SEMICOLON { printf("write -> rin L_PAR vars R_PAR SEMICOLON \n"); }
    ;

read: rout L_PAR vars R_PAR SEMICOLON { printf("read -> rout L_PAR vars R_PAR SEMICOLON \n"); }
    ;

vars: var COMMA vars { printf("vars -> var COMMA vars \n"); }
    | var { printf("vars -> var \n"); }
    ;


%


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