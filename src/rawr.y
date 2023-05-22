// BISON FILE 

%{ 
#include <stdio.h> 
#include<stdio.h>
#include<string>
#include<vector>
#include<string.h>
#include<stdlib.h>

extern int yylex(void);
void yyerror(const char *msg);


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

%union {
  char *character;
  int number;
  struct CodeNode *node;
}

%start prog_start

%token ADD SUB MULT DIV EQUALS
%token L_PAR R_PAR L_BRACE R_BRACE L_BRACKET R_BRACKET
%token EQS_TO NOT_EQS_TO G_THAN G_THAN_EQUALS L_THAN L_THAN_EQUALS AND OR
%token SEMICOLON COMMA
%token INT IF ELSE WHILE BR READ WRITE MAIN RET ARRAY CONST

%token <character> VARIABLE 
%token <number> NUMBER
%type  <node>   functions function main statements statement arguments argument initialization assignment r_var expressions
%type  <node>   singleTerm op read write conditional loop conditions condition


%%

prog_start: functions main { 
        CodeNode *function  = $1;
        CodeNode *main = $2;
        std::string code = function->code + main->code;
        CodeNode *node = new CodeNode;
        node->code = code;
        printf("Generated code:\n");
        printf("%s\n", code.c_str());
 }; 

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

function: CONST INT VARIABLE L_PAR arguments R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { 
                std::string func_name = $3;
                CodeNode *params = $5;
                CodeNode *stmts = $8;
                CodeNode *return_value = $10;
                std::string code = std::string("func ") + func_name + std::string("\n");
                code += params->code;
                code += stmts->code;
                code += return_value->code;
                code += std::string("endfunc\n");

                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;

                parentheses += 2; 
        } 
        ;

arguments: argument COMMA arguments { 
                // TODO
        }
        | argument { 
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
         }
        | %empty { 
               CodeNode *node = new CodeNode;
                $$ = node;
         }
        ;

argument: INT VARIABLE { 
                // TODO
        }
        | INT ARRAY L_BRACKET r_var R_BRACKET { 
                // TODO
        }
        | r_var { 
                // TODO
        }
        ;

main: INT MAIN L_PAR R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { 
                CodeNode *stmts = $6;
                CodeNode *return_value = $8;
                std::string code = std::string("func main \n");
                code += stmts->code;
                code += return_value->code;
                code += std::string("endfunc\n");

                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
                parentheses+= 2; 
        }
        ;

statements: statement statements { 
                // TODO
        }
         | %empty { 
                CodeNode *node = new CodeNode;
                $$ = node;
          }
        ;

statement: initialization {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | assignment {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | conditional {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | loop {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | read {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | write {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | BR SEMICOLON {
                // TODO
        }
        ;

initialization: INT VARIABLE SEMICOLON {
                // TODO
        }
        | INT ARRAY L_BRACKET r_var R_BRACKET SEMICOLON {
                // TODO
        } 
        ; 

assignment: INT VARIABLE EQUALS expressions SEMICOLON { 
                // TODO
                equals++; 
        } 
        | VARIABLE EQUALS expressions SEMICOLON { 
                // TODO
                equals++; 
        } 
        | ARRAY L_BRACKET r_var R_BRACKET EQUALS expressions SEMICOLON {
                // TODO 
                equals++; 
        } 
        ;

r_var: NUMBER { 
                int value = $1;
                CodeNode *node = new CodeNode;
                node->name = $1;
                $$ = node; 
                integers++;
        } 
        | VARIABLE L_PAR arguments R_PAR { 
                // TODO
                parentheses += 2; 
        }
        | VARIABLE { 
                // TODO
         }
        | ARRAY L_BRACKET NUMBER R_BRACKET { 
                // TODO
                integers++; 
        }
        | ARRAY L_BRACKET VARIABLE R_BRACKET {
                // TODO
        }
        ;

expressions: expressions op singleTerm {
                // TODO
        }
        | singleTerm {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        ;

singleTerm: op r_var {
                // TODO
        }
        | r_var {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | L_PAR expressions R_PAR  {
                // TODO
                parentheses += 2; 
        }
        ;

op: ADD { 
                // TODO 
                operators++; 
        } 
    | SUB { 
                // TODO 
                operators++; 
        }
    | MULT { 
                // TODO 
                operators++; 
        }
    | DIV { 
                // TODO 
                operators++; 
        }
    ;

read: READ L_PAR r_var R_PAR SEMICOLON { 
                CodeNode *node = new CodeNode;
                node->code = "READ" + $3->code;
                $$ = node;
                parentheses += 2; 
        }
    ;

write: WRITE L_PAR r_var R_PAR SEMICOLON { 
                CodeNode *node = new CodeNode;
                node->code = "WRITE" + $3->code;
                $$ = node;
                parentheses += 2; 
        }
    ;

conditional: IF L_PAR conditions R_PAR L_BRACE statements R_BRACE { 
                CodeNode *conditions  = $3;
                CodeNode *statements = $6;
                std::string code = "IF" + conditions->code + "\n" + statements->code + "\nENDIF";
                CodeNode *node = new CodeNode;
                node->code = code;
                parentheses += 2; 
        }
        | IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE {
                CodeNode *conditions  = $3;
                CodeNode *if_statements = $6;
                CodeNode *else_statements = $10;
                std::string code = "IF" + conditions->code + "\n" + if_statements->code + "\nENDIF\nELSE\n" + else_statements->code + "ENDELSE";
                CodeNode *node = new CodeNode;
                node->code = code;
                parentheses += 2;
        }
        ;

loop: WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE { 
                CodeNode *conditions  = $3;
                CodeNode *statements = $6;
                std::string code = "WHILE" + conditions->code + "\n" + statements->code + "\nENDWHILE";
                CodeNode *node = new CodeNode;
                node->code = code;
                parentheses += 2; 
        }
    ;

conditions: condition { 
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | condition OR conditions { 
                // TODO 
        }
        | condition AND conditions { 
                // TODO 
        }
        ;
// TODO
condition: r_var EQS_TO r_var {
                // TODO 
        }
        | r_var G_THAN_EQUALS r_var {
                // TODO 
        }
        | r_var L_THAN_EQUALS r_var {
                // TODO 
        }
        | r_var G_THAN r_var {
                // TODO 
        }
        | r_var L_THAN r_var {
                // TODO 
        }
        | r_var NOT_EQS_TO r_var {
                // TODO 
        }
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

void yyerror (const char *mssg) {
    extern int yylineno;
    fprintf (stderr, "Invalid Syntax! On Line: %d \n", yylineno);
 }