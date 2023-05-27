%{ 
#include<stdio.h>
#include<string>
#include<vector>
#include<string.h>
#include<stdlib.h>
#include <sstream>

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
int tempVariableCount = 0;

std::string generateTemp() {
        std::stringstream temp;
        temp << std::string("temp_") << tempVariableCount;
        tempVariableCount++;
        return temp.str();
}

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

// helper functions for semantic errors :D

// 1. using a variable w/o having first declared it
void checkVarDeclar(std::string valOfVar) {
        if(!find(valOfVar)) {
                std::string errorMsg = "ERROR! - variable of the name '" + valOfVar + "' isn't declared!";
                yyerror(errorMsg.c_str());
        }
}



// other functions =================================

extern FILE* yyin;   

int integers = 0, operators = 0, parentheses = 0, equals = 0;
%}

%union {
  char *character;
  struct CodeNode *node;
}

%start prog_start

%token ADD SUB MULT DIV EQUALS
%token L_PAR R_PAR L_BRACE R_BRACE L_BRACKET R_BRACKET
%token EQS_TO NOT_EQS_TO G_THAN G_THAN_EQUALS L_THAN L_THAN_EQUALS AND OR
%token SEMICOLON COMMA
%token INT IF ELSE WHILE BR READ WRITE MAIN RET CONST

%token <character> VARIABLE
%token <character> NUMBER
%type  <node>   functions function main statements statement arguments initialization assignment r_var expressions
%type  <node>   expression op read write conditional loop conditions condition function_call parameters argument parameter


%%

prog_start: functions main { 
        CodeNode *functions = $1;
        CodeNode *main = $2;

        std::string code = functions->code + main->code;
        
        CodeNode *node = new CodeNode;
        node->code = code;
        printf("Generated code:\n");
        printf("%s\n", code.c_str());
 }; 

functions: function functions { 
                CodeNode *function = $1;
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

function: CONST INT VARIABLE L_PAR parameters R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE { 
                CodeNode *node = new CodeNode;
                node->code = std::string("func ") + $3 + std::string("\n");
                node->code += $5->code;
                node->code += $8->code;
                node->code += std::string("ret ") + $10->code + std::string("\nendfunc\n\n");
                $$ = node;

                // symbol table
                std::string funcName = $3;
                // add_function_to_symbol_table(funcName);
                // console.log("Function added to symbol table");
        }
        ;

parameters: parameter COMMA parameters{
                CodeNode *node = new CodeNode;
                node->code = $1->code + $3->code;
                $$ = node;
        } 
        | parameter {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | %empty { 
               CodeNode *node = new CodeNode;
               $$ = node;
         }
        ;

parameter: INT VARIABLE {
        // Add to symbol table
        std::string varName = $2;
        Type t = Integer;
        add_variable_to_symbol_table(varName, t);
        
        CodeNode *node = new CodeNode;
        node->code = std::string(". " ) + $2 + std::string("\n");
        $$ = node;

                
        }
        ;

arguments: argument COMMA arguments { 
                CodeNode *node = new CodeNode;
                node->code = $1->code + $3->code;
                $$ = node;
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

argument: 
        r_var { 
                CodeNode *node = new CodeNode;
                node->code = std::string("param ") + $1->name + std::string("\n");
                $$ = node;
        }
        | 
        VARIABLE L_BRACKET r_var R_BRACKET {
                CodeNode *node = new CodeNode;
                std::string temp = generateTemp();
                node->code = ". " + temp + "\n";
                node->code += std::string("=[] ") + temp + ", " + $1 + ", " + $3->code + "\n";
                node->code += std::string("param ") + temp + std::string("\n");
                $$ = node;
        }
        ;

main: MAIN L_PAR R_PAR L_BRACE statements R_BRACE { 
                CodeNode *stmts = $5;
                std::string code = std::string("func main \n");
                code += stmts->code;
                code += std::string("endfunc\n");

                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
                parentheses += 2; 
        }
        ;

statements: statement statements { 
                CodeNode *statement  = $1;
                CodeNode *statements = $2;

                std::string code = statement->code + statements->code;

                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
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
        | function_call {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                $$ = node;
        }
        | BR SEMICOLON {
                CodeNode *node = new CodeNode;
                node->code = "BREAK";
                $$ = node;
        }
        ;

function_call: VARIABLE EQUALS VARIABLE L_PAR arguments R_PAR SEMICOLON {
                CodeNode *node = new CodeNode;
                node->code = $5->code;
                node->code += std::string("call " ) + $3 + std::string(", ") + $1 + std::string("\n");
                $$ = node;
        }

initialization: INT VARIABLE SEMICOLON {
                CodeNode *node = new CodeNode;
                node->code = std::string(". " ) + $2 + std::string("\n");
                $$ = node;

                // Add symbol table 
                Type t = Integer;
                std::string varName = $2;
                // add_variable_to_symbol_table(varName, t);
        }
        | INT VARIABLE L_BRACKET r_var R_BRACKET SEMICOLON {
                CodeNode *node = new CodeNode;
                node->code = std::string(".[] " ) + $2 + std::string(", ") + $4->name + std::string("\n");
                $$ = node;

                // Add symbol table
                Type t = Array;
                std::string arrName = $2;
                add_variable_to_symbol_table(arrName, t);
        } 
        ; 

assignment: VARIABLE EQUALS expressions SEMICOLON {
                CodeNode* node = new CodeNode();
                node->code = $3->code;
                node->code += std::string("= ") + $1 + std::string(", ") + $3->name + std::string("\n");
                $$ = node;
        } 
        | VARIABLE L_BRACKET r_var R_BRACKET EQUALS expressions SEMICOLON {
                CodeNode* node = new CodeNode();
                node->code = $6->code;
                node->code += std::string("[]= ") + $1 + std::string(", ") + $3->name + std::string(", ") + $6->name + std::string("\n");
                $$ = node; 
        } 
        | VARIABLE EQUALS VARIABLE L_BRACKET r_var R_BRACKET SEMICOLON {
                CodeNode* node = new CodeNode();
                node->code = std::string("=[] ") + $1 + std::string(", ") + $3 + std::string(", ") + $5->name + std::string("\n");
                $$ = node; 
        }
        ;

r_var: NUMBER {
                CodeNode *node = new CodeNode;
                node->name = $1;
                $$ = node; 
                integers++;
        } 
        | VARIABLE { 
                CodeNode *node = new CodeNode;
                node->name = $1;
                $$ = node; 
         }
        ;

expressions: expression op expressions {
                CodeNode* node = new CodeNode();
                std::string temp = generateTemp();
                node->name = temp;
                node->code = $1->code;
                node->code += $3->code;

                node->code += std::string(". ") + temp + std::string("\n");
                node->code += std::string($2->name) + std::string(" ") + temp + std::string(", ") + $1->name + std::string(", ") + $3->name + std::string("\n");
                $$ = node;
        } 
        | L_PAR expression op expressions R_PAR {
                CodeNode* node = new CodeNode();
                std::string temp = generateTemp();
                node->name = temp;
                node->code = $2->code;
                node->code += $4->code;

                node->code += std::string(". ") + temp + std::string("\n");
                node->code += std::string($3->name) + std::string(" ") + temp + std::string(", ") + $2->name + std::string(", ") + $4->name + std::string("\n");
                $$ = node;
        } 
        | expression {}
        ;

expression:  r_var {
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                node->name = $1->name;
                $$ = node;
        } 
        | VARIABLE L_BRACKET r_var R_BRACKET {
                CodeNode *node = new CodeNode;
                std::string temp = generateTemp();
                node->code = ". " + temp + "\n";
                node->code += std::string("=[] ") + temp + ", " + $1 + std::string(", ") + $3->name + std::string("\n");
                node->name = temp;
                $$ = node;
        }
        ;

op: ADD { 
                CodeNode *node = new CodeNode;
                node->name = "+";
                $$ = node;
                operators++; 
        } 
    | SUB { 
                CodeNode *node = new CodeNode;
                node->name = "-";
                $$ = node;
                operators++; 
        }
    | MULT { 
                CodeNode *node = new CodeNode;
                node->name = "*";
                $$ = node;
                operators++; 
        }
    | DIV { 
                CodeNode *node = new CodeNode;
                node->name = "/";
                $$ = node;
                operators++; 
        }
    ;

read: READ L_PAR r_var R_PAR SEMICOLON { 
                CodeNode *node = new CodeNode;
                node->code = ".< " + $3->name + "\n";
                $$ = node;
                parentheses += 2; 
        }
        | READ L_PAR VARIABLE L_BRACKET r_var R_BRACKET R_PAR SEMICOLON { 
                CodeNode *node = new CodeNode;
                node->code = std::string(".[]< ") + $3 + std::string(", ") + $5->name + std::string("\n");
                $$ = node;
                parentheses += 2; 
        }
    ;

write: WRITE L_PAR r_var R_PAR SEMICOLON { 
                CodeNode *node = new CodeNode;
                node->code = std::string(".> ") + $3->name + std::string("\n");
                $$ = node;
                parentheses += 2; 
        }
        | WRITE L_PAR VARIABLE L_BRACKET r_var R_BRACKET R_PAR SEMICOLON { 
                CodeNode *node = new CodeNode;
                node->code = std::string(".[]> ") + $3 + std::string(", ") + $5->name + std::string("\n");
                $$ = node;
                parentheses += 2; 
        }
    ;

conditional: IF L_PAR conditions R_PAR L_BRACE statements R_BRACE { 
                // CodeNode *conditions  = $3;
                // CodeNode *statements = $6;
                // std::string code = "IF" + conditions->code + "\n" + statements->code + "\nENDIF";
                // CodeNode *node = new CodeNode;
                // node->code = code;
                // parentheses += 2; 
        }
        | IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE {
                // CodeNode *conditions  = $3;
                // CodeNode *if_statements = $6;
                // CodeNode *else_statements = $10;
                // std::string code = "IF" + conditions->code + "\n" + if_statements->code + "\nENDIF\nELSE\n" + else_statements->code + "ENDELSE";
                // CodeNode *node = new CodeNode;
                // node->code = code;
                // parentheses += 2;
        }
        ;

loop: WHILE L_PAR conditions R_PAR L_BRACE statements R_BRACE { 
                // CodeNode *conditions  = $3;
                // CodeNode *statements = $6;
                // std::string code = "WHILE" + conditions->code + "\n" + statements->code + "\nENDWHILE";
                // CodeNode *node = new CodeNode;
                // node->code = code;
                // parentheses += 2; 
        }
    ;

conditions: condition { 
                // CodeNode *node = new CodeNode;
                // node->code = $1->code;
                // $$ = node;
        }
        | condition OR conditions { 
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + " OR " + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        | condition AND conditions { 
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + " AND " + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        ;

condition: r_var EQS_TO r_var {
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + "==" + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        | r_var G_THAN_EQUALS r_var {
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + ">=" + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        | r_var L_THAN_EQUALS r_var {
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + "<=" + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        | r_var G_THAN r_var {
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + ">" + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        | r_var L_THAN r_var {
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + "<" + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
        }
        | r_var NOT_EQS_TO r_var {
                // CodeNode *left  = $1;
                // CodeNode *right = $3;
                // std::string code = left->code + "!=" + right->code;
                // CodeNode *node = new CodeNode;
                // node->code = code;
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