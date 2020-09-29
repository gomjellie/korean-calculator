%{
#include  "y.tab.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern double vbltable[333];
%}

%%
([0-9]+|([0-9]*\.[0-9]+))  { yylval.dval = atof(yytext); return NUMBER; }
[ \t]   ;
(더하기|\+) { return PLUS; }
(빼기|\-) { return MINUS; }
(곱하기|\*) { return MUL; }
(나누기|\/) { return DIV; }
(에) { return AT; }
(을|를) { return OBJ_JOSA; }
(대입한다|넣는다) { return VERB_ASSIGN; }
[a-z]    {      yylval.vblno = yytext[0] - 'a'; return NAME; }
"$"      { return 0; }
\n |
. return  yytext[0];
%%

/**
을를 목적격조사

 */
void yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}
