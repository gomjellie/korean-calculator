%{
#include  "y.tab.h"
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int decode();
%}

HANGUL [가-힣]
DIGIT  [0-9]

%%
({DIGIT}+|({DIGIT}*\.{DIGIT}+))  { yylval.dval = atof(yytext); return NUMBER; }
[ \t]   ;
(더하기|\+) { return PLUS; }
(빼기|\-) { return MINUS; }
(곱하기|\*) { return MUL; }
(나누기|\/) { return DIV; }
(에) { return AT; }
(을|를) { return OBJ_JOSA; }
(대입한다|넣는다) { return VERB_ASSIGN; }
(출력한다) { return VERB_PRINT; }
(${HANGUL}+) {
    int r = decode();
    if (r == NAME_WITH_OBJ_JOSA) {
        yyless(yyleng - strlen("를"));
        strcpy(yylval.name, yytext);
        return NAME;
    }
    if (r == NAME) {
        strcpy(yylval.name, yytext);
        return NAME;
    }

    return r;
}
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

int decode() {
    char last_char[32];
    strcpy(last_char, &yytext[yyleng - strlen("에")]);
    if (!strcmp(last_char, "을") || !strcmp(last_char, "를") || !strcmp(last_char, "에")) {
        return NAME_WITH_OBJ_JOSA;
    }
    return NAME;
}
