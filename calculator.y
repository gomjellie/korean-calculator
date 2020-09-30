%{
#include <stdio.h>
#include "y.tab.h"
#include "variable.h"

extern int yylex();
extern void yyerror(char *s);
extern FILE *yyin, *yyout;

%}
/* %token NAME NUMBER */

%union  {
    double dval;
    char name[64];
}
%token    <name> NAME
%token    <dval> NUMBER
%token PLUS MINUS MUL DIV
%token AT OBJ_JOSA
%token VERB_ASSIGN
%token VERB_PRINT
%token NAME_WITH_OBJ_JOSA

%left MINUS PLUS
%left MUL DIV
%nonassoc UMINUS /* no associativity: unary minus */
%type <dval> expression

%%
statement_list: statement '\n'
          |         statement_list statement '\n'
          ;
statement:        NAME AT expression OBJ_JOSA VERB_ASSIGN { hash_add(var_new($1, $3)); }
          |   expression OBJ_JOSA NAME AT VERB_ASSIGN { hash_add(var_new($3, $1)); }
          |   expression OBJ_JOSA VERB_PRINT { printf(">> %g\n", $1); }
          |   expression
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
           |       NAME       { var_t *search = hash_find($1); 
                                if (search == NULL) $$ = 0; else $$ = search->val;  }
           ;
%%

int main(int argc, char *argv[]) {
    ++argv, --argc;  /* skip over program name */
    if (argc > 0)
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;
    
    printf("hangul size: %lu\n", strlen("한"));
    
    yyparse();
}
