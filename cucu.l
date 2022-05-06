%{
    #include<stdlib.h>
    #include<stdio.h>
    #define YYSTYPE char*
    #include"cucu.tab.h"
%}

DIGIT [0-9]
IDENTIFIER [a-zA-Z][a-zA-Z0-9_]*

%%
[ \t\n]+ {}; /*blank, tab, new line: eat up whitespace */
\/\*(.|\n)*\*\/ ;
\/\/.* ;
(^while|while) { fprintf(yyout, "WHILE : %s\n", yytext); return(WHILE); }
(^if|if) { fprintf(yyout, "IF : %s\n", yytext); return(IF); }
(^else|else) { fprintf(yyout, "ELSE : %s\n", yytext); return(ELSE); }
(^return|return) { fprintf(yyout, "RETURN : %s\n", yytext); return(RETURN); }
(^int|int) { fprintf(yyout, "TYPE : %s\n", yytext); return(TYPE); }
(^c|c)har" *" { fprintf(yyout, "TYPE : %s\n", yytext); return(TYPE); }
"=" { fprintf(yyout, "ASSIGN : %s\n", yytext); return(ASSIGN); }
[0-9]+ { fprintf(yyout, "NUM : %s\n", yytext); yylval = yytext; return(NUM); }
[a-zA-Z][a-zA-Z0-9_]* { fprintf(yyout, "ID : %s\n", yytext); yylval = strdup(yytext); return(ID); }
";" { fprintf(yyout, "SEMI : %s\n", yytext); return(SEMI); }
"," { fprintf(yyout, "COMMA : %s\n", yytext); return(COMMA); }
"+" { fprintf(yyout, "PLUS : %s\n", yytext); return(PLUS); }
"-" { fprintf(yyout, "MINUS: %s\n", yytext); return(MINUS); }
"*" { fprintf(yyout, "PROD : %s\n", yytext); return(PROD); }
"/" { fprintf(yyout, "DIV : %s\n", yytext); return(DIV); }
"(" { fprintf(yyout, "CIRCULAR_LEFT : %s\n", yytext); return(CIRCULAR_LEFT); }
")" { fprintf(yyout, "CIRCULAR_RIGHT : %s\n", yytext); return(CIRCULAR_RIGHT); }
"[" { fprintf(yyout, "SQUARE_LEFT : %s\n", yytext); return(SQUARE_LEFT); }
"]" { fprintf(yyout, "SQUARE_RIGHT : %s\n", yytext); return(SQUARE_RIGHT); }
"{" { fprintf(yyout, "CURLY_LEFT : %s\n", yytext); return(CURLY_LEFT); }
"}" { fprintf(yyout, "CURLY_RIGHT : %s\n", yytext); return(CURLY_RIGHT); }
"==" { fprintf(yyout, "EQUAL : %s\n", yytext); return(EQUAL); }
"!=" { fprintf(yyout, "NOT_EQUAL: %s\n", yytext); return(NOT_EQUAL); }
">" { fprintf(yyout, "GREATER_THAN: %s\n", yytext); return(GREATER_THAN); }
"<" { fprintf(yyout, "LESS_THAN: %s\n", yytext); return(LESS_THAN); }
">=" { fprintf(yyout, "GREATER_THAN_EQUAL: %s\n", yytext); return(GREATER_THAN_EQUAL); }
"<=" { fprintf(yyout, "LESS_THAN_EQUAL: %s\n", yytext); return(LESS_THAN_EQUAL); }
(\S)+ { fprintf(yyout, "LEXICAL ERROR : %s\n", yytext); }
%%
 
int yywrap()
{ 
   return 1;
} 
