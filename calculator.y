%{
#include <stdio.h>
#include "y.tab.h"

extern int yylex();
extern void yyerror(char *s);
double vbltable[333];
char var_name;
%}
/* %token NAME NUMBER */

%union  {
    double dval;
    int vblno;
}
%token    <vblno> NAME
%token    <dval> NUMBER
%token PLUS MINUS MUL DIV
%token AT OBJ_JOSA
%token VERB_ASSIGN

%left MINUS PLUS
%left MUL DIV
%nonassoc UMINUS /* no associativity: unary minus */
%type <dval> expression

%%
statement_list: statement '\n'
          |         statement_list statement '\n'
          ;
statement:        NAME AT expression OBJ_JOSA VERB_ASSIGN { vbltable[$1] = $3; }
          |   expression OBJ_JOSA NAME AT VERB_ASSIGN { vbltable[$3] = $1; }
          |   expression               { printf("     는 %g\n", $1); }
          ;
expression: expression PLUS expression  { $$ = $1 + $3;  }
          | expression MINUS expression  { $$ = $1 - $3;  }
          | expression MUL expression  { $$ = $1 * $3;  }
          | expression DIV expression
                    {  if($3 == 0.0)
                             yyerror("divide by zero");
                       else   $$ = $1 /$3;
                    }
           |  '-' expression  %prec UMINUS   { $$ = -$2; } /* The keyword %prec changes the precedence level associated with a particular grammar rule */
           |  '(' expression ')'     { $$ = $2; }
           |       NUMBER     { $$ = $1; }
           |       NAME       { var_name = $1 + 'a'; $$ = vbltable[$1]; }
           ;
%%

int main() {
    yyparse();
}
