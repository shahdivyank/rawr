# CS152 - Lab Group #8 (rawr)

## Overview

- Experimental Programming Language Name: <b>rawr</b>
- File Extension: <b>rawr</b>
- Compiler Name: <b>rawr-lc</b>

## Features

| Features                                          | Syntax                                                                      |
| :------------------------------------------------ | :-------------------------------------------------------------------------- |
| Integer Scalar Variables                          | int a = 0;                                                                  |
| 1D Arrays                                         | int a[10];                                                                  |
| Assignment Operators                              | a = b;                                                                      |
| Arithmetic Operators (e.g., “+”, “-”, “\*”, “/”)  | a + b; <br> a - b; <br> a \* b; <br> a / b;                                 |
| Relational Operators (e.g., “<”, “==”, “>”, “!=”) | a == b; <br> a < b; <br> a > b; <br> a != b;                                |
| While Loop                                        | while(a > 100) { <br/>// code<br/>}                                         |
| If-then-else statements                           | if (a > 10) {<br/><br/>} else {<br/><br/>}                                  |
| Read and write statements                         | rin(a), rout(a)                                                             |
| Comments                                          | // This is a comment <br/><br/>/* <br> This whole block is a comment <br>*/ |
| Functions                                         | const int add (int a, int b) {<br>return a + b;<br>}                        |

## Additional info on our language

- A comment can be started by using "//". Any characters after the "//" all the way until the end of the current line will count as a single comment. A comment can also be multiple lines as well by starting it with " /* " and ending it with " */ ".
- A valid identifier in this language would be that a variable can not start with a number of any special character. It must start with a lowercase letter first. Any number of upercase or lettercase letters can follow - including any special characters or numbers. There must also be no whitespace.
- Our language "rawr" will be case sensitive.
- Our language will consider a blank space or a newline to be whitespace.

## Symbols

| Symbol in Language              | Token Name                         |
| :------------------------------ | :--------------------------------- |
| int                             | INTEGER                            |
| +                               | ADD                                |
| -                               | SUB                                |
| \*                              | MULT                               |
| /                               | DIV                                |
| =                               | EQUALS                             |
| <                               | L_THAN                             |
| >                               | G_THAN                             |
| <=                              | L_THAN_EQUALS                      |
| >=                              | G_THAN_EQUALS                      |
| ==                              | EQS_TO                             |
| integer number (ex. 0, 1, 2, 3) | NUM X (WHERE IS DENOTES THE VALUE) |
| (                               | L_PAR                              |
| )                               | R_PAR                              |
| {                               | L_BRACE                            |
| }                               | R_BRACE                            |
| [                               | L_BRACKET                          |
| ]                               | R_BRACKET                          |
| \|\|                            | OR                                 |
| &&                              | AND                                |
| ;                               | SEMICOLON                          |
| :                               | COLON                              |
| ,                               | COMMA                              |
| if                              | IF                                 |
| else                            | ELSE                               |
| while                           | WHILE                              |
| break                           | BR                                 |
| continue                        | CONT                               |
| rin                             | READ                               |
| rout                            | WRITE                              |
| main                            | MAIN                               |
| return                          | RET                                |
| const                           | FUNCT                              |
| continue                        | CONT                               |
