%{ 
#include<stdio.h> 
#include<string>
#include<vector>
#include<string.h>
#include<stdlib.h>
#include <sstream>
#include <algorithm>
#include <unordered_set>
#include<string>

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
int labelVariableCount = 0;
int endVariableCount = 0;
int startVariableCount = 0;
int parameterCount = -1;
int loop = 0;

std::string generateTemp() {
        std::stringstream temp;
        temp << std::string("_temp_") << tempVariableCount;
        tempVariableCount++;
        return temp.str();
}

std::string generateLabel() {
        std::stringstream label;
        label << std::string("_label_") << labelVariableCount;
        labelVariableCount++;
        return label.str();
}

std::string generateEnd() {
        std::stringstream end;
        end << std::string("_end_") << endVariableCount;
        endVariableCount++;
        return end.str();
}

std::string generateStart() {
        std::stringstream start;
        start << std::string("_start_") << startVariableCount;
        startVariableCount++;
        return start.str();
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
                if (s->name == value && (s->type == Integer)) {
                        return true;
                }
        }
        
        return false;
}

bool findArray(std::string &value) {
        Function *f = get_function();
        for(int i = 0; i < f->declarations.size(); i++) {
                Symbol *s = &f->declarations[i];

                // checks for both type and value (want array type only here)
                if((s->type == Array) && (s->name == value) ) {
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
        bool varFound = false;
        for(int i=0; i<symbol_table.size(); i++) {
                for(int j=0; j<symbol_table[i].declarations.size(); j++) {
                        if(symbol_table[i].declarations[j].name.c_str() == valOfVar) {
                                varFound = true;
                                // printf("i've been found");
                        }
                }
        }

        if(!varFound) {
                std::string errorMsg = "ERROR! - variable '" + valOfVar + "' isn't declared!\n";
                printf(errorMsg.c_str());
                exit(1);
        }
}

// 2. Calling a function which has not been defined.
void checkFuncDefined(std::string valOfFunc) {
        bool funcFound = false;

        // check if func name exists
        for(int i = 0; i < symbol_table.size(); i++) {
                if(symbol_table[i].name.c_str() == valOfFunc) {
                        funcFound = true;
                        // printf("im found");
                }
        }

        if(!funcFound) {
                std::string errorMsg = "ERROR! - function '" + valOfFunc + "' isn't defined!\n";
                printf(errorMsg.c_str());
                exit(1);
        }
}

// 3. Not defining a main function. - we define w/ syntax level

// 4. array helper functions
// when using a variable as an array --> ERROR
void checkIfVarIsArr(std::string arrVal) {
        if(findArray(arrVal)) {
                std::string errorMsg = "ERROR! - the array '" + arrVal + "' isn't a variable! You need to include brackets.\n";
                printf(errorMsg.c_str());
                exit(1);
        }
}

// when using an array as a variable --> ERROR
void checkIfArrIsVar(std::string varVal) {
        if(find(varVal)) {
                std::string errorMsg = "ERROR! - the variable '" + varVal + "' isn't an array! Don't include brackets!!\n";
                printf(errorMsg.c_str());
                exit(1);
        }
}

void checkFuncDuplicate (std::string funcName){
        for (int i =0; i < symbol_table.size(); i++){
                if (symbol_table.at(i).name == funcName ){
                        std::string errorMsg = "Error: function " + funcName + " is already defined\n"; 
                        printf(errorMsg.c_str()); 
                        exit(1); 
                }
        }
}

void checkVarDuplicate( std::string variableName){
        if (find(variableName)){
                std::string errorMsg = "Error: variable is already declared " + variableName + "\n"; 
                printf(errorMsg.c_str()); 
                exit(1); 
        }
}

void checkNegativeArray(std::string value) {
        std::stringstream stream(value);
        int integer;
        stream >> integer;
        if(integer < 0) {
                std::string errorMsg = "Error: Accessing negative values in arrays is not allowed. Error accessing: " + value + "\n"; 
                printf(errorMsg.c_str()); 
                exit(1);
        }
}

std::vector<std::string> keywordsBank= { "INT", "CONST", 
    "IF", "ELSE", "WHILE", "CONTINUE",  "RIN", "ROUT"
    , "TRUE", "FALSE", "RETURN", "+", "-", "*", "/", "(", ")", "[", "]", "{", "}", "=",
     "int", "const", "if", "else", "while", "continue", "rin", "rout",
"true", "false", "return", "+", "-", "*", "/", "(", ")", "[", "]", "{", "}", "="};

void checkIsKeyword(std::string name){
        if (std::find(keywordsBank.begin(), keywordsBank.end(), name) != keywordsBank.end())
        {       
                std::string errorMsg = "Error: function/variable name is a keyword " + name + "\n"; 
                printf(errorMsg.c_str()); 
                exit(1);
        }
}
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
%token INT IF ELSE WHILE BR CONTINUE READ WRITE MAIN RET CONST

%token <character> VARIABLE
%token <character> NUMBER
%type  <node>   functions function main statements statement arguments initialization assignment r_var expressions
%type  <node>   expression op read write conditional loop conditions condition function_call parameters argument parameter


%%

prog_start: functions {
        std::string funcName = "main";
        // checkVarDuplicate(funcName); 

        add_function_to_symbol_table(funcName);
        } main { 
        CodeNode *functions = $1;
        CodeNode *main = $3;

        

        std::string code = functions->code + main->code;
        
        CodeNode *node = new CodeNode;
        node->code = code;

        print_symbol_table();
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

function: CONST INT VARIABLE {
                std::string funcName = $3;
                checkIsKeyword(funcName); 
                checkFuncDuplicate(funcName);
                add_function_to_symbol_table(funcName);
                 
        } L_PAR parameters R_PAR L_BRACE statements RET r_var SEMICOLON R_BRACE {
                CodeNode *node = new CodeNode;

                node->code = std::string("func ") + $3 + std::string("\n");
                node->code += $6->code;
                node->code += $9->code;
                node->code += std::string("ret ") + $11->name + std::string("\nendfunc\n\n");

                $$ = node;
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
                parameterCount++;
                CodeNode *node = new CodeNode;

                std::string varName = $2;
                Type t = Integer;
                checkIsKeyword(varName); 
                checkVarDuplicate(varName); 
                add_variable_to_symbol_table(varName, t);

                node->code = std::string(". " ) + varName + std::string("\n");
                
                std::stringstream temp;
                temp << std::string("$") << parameterCount;
                node->code += std::string("= ") + varName + ", " + temp.str() + "\n";
               
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
                checkNegativeArray($3->name);
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
                
                parentheses += 2; 
                $$ = node;
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
                if(loop == 0) {
                        std::string errorMsg = "BREAK not in loop statement!\n";
                        printf(errorMsg.c_str());
                        exit(1);
                }
                std::stringstream statement;
                statement << std::string("_end_") << endVariableCount;
                CodeNode *node = new CodeNode;
                node->code = ":= " + statement.str() + "\n";
                // endVariableCount--;
                // startVariableCount--;
                $$ = node;
        }
        | CONTINUE SEMICOLON {
                if(loop == 0) {
                        std::string errorMsg = "CONTINUE not in loop statement!\n";
                        printf(errorMsg.c_str());
                        exit(1);
                }
                std::stringstream statement;
                statement << std::string("_start_") << startVariableCount;
                CodeNode *node = new CodeNode;
                node->code = ":= " + statement.str() + "\n";
                $$ = node;
        }
        ;

function_call: VARIABLE EQUALS VARIABLE L_PAR arguments R_PAR SEMICOLON {
                std::string funcName = $3;
                checkFuncDefined(funcName);

                CodeNode *node = new CodeNode;
                node->code = $5->code;
                node->code += std::string("call " ) + $3 + std::string(", ") + $1 + std::string("\n");
                $$ = node;
        }

initialization: INT VARIABLE SEMICOLON {
                // Add symbol table - DOUBLE CHECK
                Type t = Integer;
                std::string varName = $2;
                checkIsKeyword(varName); 
                checkVarDuplicate(varName); 
                add_variable_to_symbol_table(varName, t);

                CodeNode *node = new CodeNode;
                node->code = std::string(". " ) + $2 + std::string("\n");
                $$ = node;
        }
        | INT VARIABLE L_BRACKET r_var R_BRACKET SEMICOLON {
                checkNegativeArray($4->name);
                CodeNode *node = new CodeNode;
                node->code = std::string(".[] " ) + $2 + std::string(", ") + $4->name + std::string("\n");
                $$ = node;

                // Add symbol table
                Type t = Array;
                std::string arrName = $2;
                checkIsKeyword(arrName); 
                checkVarDuplicate(arrName); 
                add_variable_to_symbol_table(arrName, t);

                // DINO 
                // std::string arrSize = $4->name;
                // checkArrSize(arrSize);
        } 
        ; 

assignment: VARIABLE EQUALS expressions SEMICOLON {
                // checking if variable is declared or not
                std::string varName = $1;
                checkVarDeclar(varName);

                // check if variable is an array
                checkIfVarIsArr(varName);
                
                CodeNode* node = new CodeNode();
                node->code = $3->code;
                node->code += std::string("= ") + $1 + std::string(", ") + $3->name + std::string("\n");
                $$ = node;
        } 
        | VARIABLE L_BRACKET r_var R_BRACKET EQUALS expressions SEMICOLON {
                checkNegativeArray($3->name);
                // checking if array has been declared or not
                std::string arrName = $1;
                checkVarDeclar(arrName);
                checkIfArrIsVar(arrName);

                CodeNode* node = new CodeNode();
                node->code = $6->code;
                node->code += std::string("[]= ") + $1 + std::string(", ") + $3->name + std::string(", ") + $6->name + std::string("\n");
                $$ = node;                 
        } 
        /* | VARIABLE EQUALS VARIABLE L_BRACKET r_var R_BRACKET SEMICOLON {
                checkNegativeArray($5->name);
                CodeNode* node = new CodeNode();
                node->code = std::string("=[] ") + $1 + std::string(", ") + $3 + std::string(", ") + $5->name + std::string("\n");
                $$ = node; 
        } */
        ;

r_var: NUMBER {
                CodeNode *node = new CodeNode;
                node->name = $1;
                $$ = node; 
                integers++;
        } | SUB NUMBER {
                CodeNode *node = new CodeNode;
                node->name = std::string("-") + $2;
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
                checkNegativeArray($3->name);
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
                checkNegativeArray($5->name);
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
                checkNegativeArray($5->name);
                CodeNode *node = new CodeNode;
                node->code = std::string(".[]> ") + $3 + std::string(", ") + $5->name + std::string("\n");
                $$ = node;
                parentheses += 2; 
        }
    ;

conditional: IF L_PAR conditions R_PAR L_BRACE statements R_BRACE { 
                std::string if_label = generateLabel();
                std::string end_label = generateLabel();
                
                CodeNode *node = new CodeNode;
                node->code += $3->code; 
                node->code += "?:= " + if_label + ", " + $3->name + "\n";
                node->code += ":= " + end_label + "\n";
                node->code += ": " + if_label + "\n";
                node->code += $6->code;
                node->code += ": " + end_label + "\n";
                $$ = node;
        }
        | IF L_PAR conditions R_PAR L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE {
                std::string if_label = generateLabel();
                std::string else_label = generateLabel();
                std::string end_label = generateLabel();
                
                CodeNode *node = new CodeNode;
                node->code += $3->code; 
                node->code += "?:= " + if_label + ", " + $3->name + "\n";
                node->code += ":= " + else_label + "\n";
                node->code += ": " + if_label + "\n";
                node->code += $6->code;
                node->code += ":= " + end_label + "\n";
                node->code += ": " + else_label + "\n";
                node->code += $10->code;
                node->code += ": " + end_label + "\n";
                
                $$ = node;
        }
        ;

loop: WHILE { loop = 1; } L_PAR conditions R_PAR L_BRACE statements R_BRACE { 
                std::string start = generateStart();
                std::string body = generateLabel();
                std::string end = generateEnd();

                CodeNode *node = new CodeNode;
                node->code = ": " + start + "\n";
                node->code += $4->code;
                node->code += "?:= " + body + ", " + $4->name + " \n";
                node->code += ":= " + end + "\n";
                node->code += ": " + body + "\n";
                node->code += $7->code;
                node->code += ":= " + start + "\n";
                node->code += ": " + end + "\n";
                
                loop = 0;
                $$ = node;

                // endVariableCount--;
                // startVariableCount--;
        }
    ;

conditions: condition { 
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                node->name = $1->name;
                $$ = node;
        }
        | condition OR conditions { 
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                node->code += $3->code;
                std::string temp = generateTemp();
                node->code += ". " + temp + "\n";
                node->code += std::string("|| ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        | condition AND conditions { 
                CodeNode *node = new CodeNode;
                node->code = $1->code;
                node->code += $3->code;
                std::string temp = generateTemp();
                node->code += ". " + temp + "\n";
                node->code += std::string("&& ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        ;

condition: r_var EQS_TO r_var {
                std::string temp = generateTemp();
                CodeNode *node = new CodeNode;
                node->code = ". " + temp + "\n";
                node->code += std::string("== ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        | r_var G_THAN_EQUALS r_var {
                std::string temp = generateTemp();
                CodeNode *node = new CodeNode;
                node->code = ". " + temp + "\n";
                node->code += std::string(">= ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        | r_var L_THAN_EQUALS r_var {
                std::string temp = generateTemp();
                CodeNode *node = new CodeNode;
                node->code = ". " + temp + "\n";
                node->code += std::string("<= ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        | r_var G_THAN r_var {
                std::string temp = generateTemp();
                CodeNode *node = new CodeNode;
                node->code = ". " + temp + "\n";
                node->code += std::string("> ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        | r_var L_THAN r_var {
                std::string temp = generateTemp();
                CodeNode *node = new CodeNode;
                node->code = ". " + temp + "\n";
                node->code += std::string("< ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
        }
        | r_var NOT_EQS_TO r_var {
                std::string temp = generateTemp();
                CodeNode *node = new CodeNode;
                node->code = ". " + temp + "\n";
                node->code += std::string("!= ") + temp + ", " + $1->name + ", " + $3->name + "\n";
                node->name = temp;
                $$ = node;
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

    return 0;
}

void yyerror (const char *mssg) {
    extern int yylineno;
    fprintf (stderr, "Invalid Syntax! On Line: %d \n", yylineno);
 }