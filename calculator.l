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
({HANGUL}+) {
    int r = decode();
    if (r == NAME_WITH_OBJ_JOSA) {
        yyless(yyleng - strlen("에"));
        strcpy(yylval.name, yytext);
        return NAME;
    }
    if (r == NAME) {
        strcpy(yylval.name, yytext); return NAME;
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
    if (!strcmp(yytext, "더하기")) return PLUS;
    if (!strcmp(yytext, "곱하기")) return MUL;
    if (!strcmp(yytext, "나누기")) return DIV;
    if (!strcmp(yytext, "빼기")) return MINUS;
    if (!strcmp(yytext, "에")) return AT;
    if (!strcmp(yytext, "을")) return OBJ_JOSA;
    if (!strcmp(yytext, "를")) return OBJ_JOSA;
    if (!strcmp(yytext, "대입한다")) return VERB_ASSIGN;
    if (!strcmp(yytext, "출력한다")) return VERB_PRINT;

    char last_char[32];
    if (strlen("에") != strlen("을")) printf("에와 을의 길이는 다릅니다 %lu", strlen("에"));
    strcpy(last_char, &yytext[yyleng - strlen("에")]);
    if (!strcmp(last_char, "을") || !strcmp(last_char, "를") || !strcmp(last_char, "에")) {
        return NAME_WITH_OBJ_JOSA;
    }
    return NAME;
}
