// BISON FILE 

%{ 
#include <stdio.h> 
#include<stdio.h>
#include<string>
#include<vector>
#include<string.h>
#include<stdlib.h>

// Possible Datatypes in Language
enum Type { Integer, Array };

struct CodeNode {
    std::string code; // generated code as a string.
    std::string name;
};

struct Symbol {
  std::string name;
  Type type;
};

struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

Function *get_function() {
  int last = symbol_table.size() - 1;
  if (last < 0) {
    printf("***Error. Attempt to call get_function with an empty symbol table\n");
    printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
    printf("calling 'find' or 'add_variable_to_symbol_table'");
    exit(1);
  }
  return &symbol_table[last];
}

bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}


extern FILE* yyin;   

int integers = 0, operators = 0, parentheses = 0, equals = 0;
%}

%start prog_start

%token ADD SUB MULT DIV EQUALS
%token L_PAR R_PAR L_BRACE R_BRACE L_BRACKET R_BRACKET
%token EQS_TO NOT_EQS_TO G_THAN G_THAN_EQUALS L_THAN L_THAN_EQUALS AND OR
%token SEMICOLON COMMA
%token INT IF ELSE WHILE BR READ WRITE MAIN RET ARRAY NUMBER VARIABLE CONST

%%

// TODO
prog_start: functions main functions { printf("prog_start -> functions main functions \n"); }
        ; 

functions: function functions { 
                CodeNode *function  = $1;
                CodeNode *functions = $2;
                std::string code = function->code + functions->code;
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
        } 
        | %empty { 
                CodeNode *node = new CodeNode;
                $$ = node;
         }
        ;
// TODO
function: CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("function -> CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE \n"); parentheses += 2; } 
        ;
// TODO
arguments: argument COMMA arguments { printf("arguments -> argument COMMA arguments \n"); }
        | argument { printf ("arguments -> argument \n"); }
        | %empty { 
                CodeNode *node = new CodeNode;
                $$ = node;
         }
        ;
// TODO
argument: INT VARIABLE { printf("argument -> INT VARIABLE \n"); }
        | INT ARRAY L_BRACKET r_var R_BRACKET { printf("argument -> INT ARRAY L_BRACKET r_var R_BRACKET \n"); }
        | r_var { printf("argument -> r_var \n"); }
        ;
// TODO
main: INT MAIN L_PAR R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { printf("main -> CONST INT MAIN L_PAR R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE \n"); parentheses+= 2; }
        ;
// TODO
statements: statement statements { printf ("statements -> statement statements \n"); }
         | %empty { 
                CodeNode *node = new CodeNode;
                $$ = node;
          }
        ;
// TODO
statement: initialization { printf("statement -> initialization \n"); }
        | assignment { printf("statement -> assignment \n"); }
        | conditional { printf("statement -> conditional \n"); }
        | loop { printf("statement -> loop \n"); }
        | read { printf("statement -> read \n"); }
        | write { printf("statement -> write \n"); }
        | BR SEMICOLON { printf("statement -> BR SEMICOLON \n"); }
        ;
// TODO
initialization: INT VARIABLE SEMICOLON { printf("initialization -> INT VARIABLE SEMICOLON \n"); }
        | INT ARRAY L_BRACKET r_var R_BRACKET SEMICOLON { printf("initialization -> INT ARRAY L_BRACKET r_var R_BRACKET SEMICOLON \n"); } 
        ; 
// TODO
assignment: INT VARIABLE EQUALS expressions SEMICOLON { printf("assignment -> INT VARIABLE EQUALS expressions SEMICOLON \n"); equals++; } 
        | VARIABLE EQUALS expressions SEMICOLON { printf("assignment -> VARIABLE EQUALS expressions SEMICOLON \n"); equals++; } 
        | ARRAY L_BRACKET r_var R_BRACKET EQUALS expressions SEMICOLON { printf("assignment -> ARRAY L_BRACKET r_var R_BRACKET EQUALS expressions \n"); equals++; } 
        ;
// TODO
r_var: NUMBER { printf("r_var -> NUMBER \n"); integers++; } 
        | VARIABLE L_PAR arguments R_PAR { printf("singleTerm -> VARIABLE L_PAR arguments R_PAR \n"); parentheses += 2; }
        | VARIABLE { printf("r_var -> VARIABLE \n"); }
        | ARRAY L_BRACKET NUMBER R_BRACKET { printf("r_var -> ARRAY L_BRACKET NUMBER R_BRACKET \n"); integers++; }
        | ARRAY L_BRACKET VARIABLE R_BRACKET { printf("r_var -> ARRAY L_BRACKET VARIABLE R_BRACKET \n"); }
        ;
// TODO
expressions: expressions op singleTerm { printf("expressions -> expressions op singleTerm \n"); }
        | singleTerm { printf("expressions -> singleTerm \n"); }
        ;
// TODO
singleTerm: op r_var { printf("singleTerm -> op r_var \n"); }
        | r_var { printf("singleTerm -> r_var \n"); }
        | L_PAR expressions R_PAR  { printf("singleTerm -> L_PAR expressions R_PAR \n"); parentheses += 2; }
        ;
// TODO
op: ADD { printf("op -> ADD \n"); operators++; } 
    | SUB { printf("op -> SUB \n"); operators++; } 
    | DIV { printf("op -> DIV \n"); operators++; } 
    | MULT { printf("op -> MULT \n"); operators++; } 
    ;
// TODO
read: READ L_PAR r_var R_PAR SEMICOLON { printf("read -> READ L_PAR r_var R_PAR SEMICOLON \n"); parentheses += 2; }
    ;
// TODO
write: WRITE L_PAR r_var R_PAR SEMICOLON { printf("write -> WRITE L_PAR r_var R_PAR SEMICOLON \n"); parentheses += 2; }
    ;
// TODO
conditional: IF L_PAR conditions R_PAR L_BRACE statements R_BRACE { printf("conditional -> IF L_PAR conditions R_PAR L_BRACE statements R_BRACE \n"); parentheses += 2; }
        | IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE { printf("conditional -> IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE \n"); parentheses += 2;}
        ;
// TODO
loop: WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE { printf("loop -> WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE \n"); parentheses += 2; }
    ;
// TODO
conditions: condition { printf("conditions -> condition \n"); }
        | condition OR conditions { printf("conditions -> condition OR conditions \n"); }
        | condition AND conditions { printf("conditions -> condition AND conditions \n"); }
        ;
// TODO
condition: r_var EQS_TO r_var { printf("condition -> r_var EQS_TO r_var \n"); }
        | r_var G_THAN_EQUALS r_var { printf("condition -> r_var G_THAN_EQUALS r_var \n"); }
        | r_var L_THAN_EQUALS r_var { printf("condition -> r_var L_THAN_EQUALS r_var \n"); }
        | r_var G_THAN r_var { printf("condition -> r_var G_THAN r_var \n"); }
        | r_var L_THAN r_var { printf("condition -> r_var L_THAN r_var \n"); }
        | r_var NOT_EQS_TO r_var { printf("condition -> r_var NOT_EQS_TO r_var \n"); }
        ;
%%

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
        return 1; 
    }

    printf("Total Count of Variables: %d Integers, %d Operators, %d Parentheses, %d Equal Signs \n", integers, operators, parentheses, equals);

    return 0;
}

int yyerror (const char *mssg) {
    extern int yylineno;
    fprintf (stderr, "Invalid Syntax! On Line: %d \n", yylineno);
    return 1; 
 }