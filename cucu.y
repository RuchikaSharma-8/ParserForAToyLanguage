%{
    #include<stdio.h>
    #include<stdlib.h>
    int yyparse();
    extern int yylex(void);
    //char *yytext;
    #define YYSTYPE char*
    void yyerror (const char* message);
    FILE *yyin, *yyout, *parser_file;
%}

%token TYPE ID NUM 
%token PLUS MINUS PROD DIV
%token WHILE IF ELSE
%token CIRCULAR_LEFT CIRCULAR_RIGHT SQUARE_LEFT SQUARE_RIGHT CURLY_LEFT CURLY_RIGHT 
%token ASSIGN EQUAL NOT_EQUAL GREATER_THAN LESS_THAN GREATER_THAN_EQUAL LESS_THAN_EQUAL
%token SEMI COMMA RETURN 

%%
program : var_declaration
	| var_definition
	| func_declaration
	| func_definition
	;		
func_definition: TYPE ID {fprintf(parser_file, "identifier: %s\n", yylval);} CIRCULAR_LEFT func_parameters CIRCULAR_RIGHT CURLY_LEFT {fprintf(parser_file, "function body\n");} func_body CURLY_RIGHT;
func_declaration : TYPE ID CIRCULAR_LEFT func_parameters CIRCULAR_RIGHT SEMI;
func_parameters : TYPE ID {fprintf(parser_file, "function parameter: %s\n", yylval);} COMMA func_parameters
	       | TYPE ID {fprintf(parser_file, "function parameter: %s\n", yylval);}
	       ;
func_body : statement func_body
	  | statement
	  ;
statement : var_declaration
	  | var_definition
	  | assignment
	  | func_call
	  | return_statement
	  | compound_statement
	  ;
func_call : ID CIRCULAR_LEFT func_arguments CIRCULAR_RIGHT SEMI {fprintf(parser_file, "FUNC-CALL\n");};
func_arguments : expression {fprintf(parser_file, "FUNC-ARG\n");} COMMA func_arguments
	       | expression {fprintf(parser_file, "FUNC-ARG\n");}
	       ;
assignment : ID ASSIGN expression SEMI;
var_declaration : TYPE var SEMI;
var_definition : TYPE ID {fprintf(parser_file, "local variable: %s\n", yylval);} ASSIGN expression SEMI
	       | TYPE ID SQUARE_LEFT expression SQUARE_RIGHT ASSIGN array_list SEMI
	       ;
array_list : CURLY_LEFT num_list CURLY_RIGHT;
num_list : NUM COMMA num_list
	 | NUM
	 ;
return_statement : RETURN expression SEMI {fprintf(parser_file, "AND RET\n", yylval);};
compound_statement : IF {fprintf(parser_file, "keyword : IF\n");} CIRCULAR_LEFT expression CIRCULAR_RIGHT CURLY_LEFT func_body CURLY_RIGHT
		   | IF {fprintf(parser_file, "keyword : IF\n");} CIRCULAR_LEFT expression CIRCULAR_RIGHT CURLY_LEFT func_body CURLY_RIGHT ELSE CURLY_LEFT func_body CURLY_RIGHT
		   | WHILE {fprintf(parser_file, "keyword : WHILE\n");} CIRCULAR_LEFT expression CIRCULAR_RIGHT CURLY_LEFT func_body CURLY_RIGHT
		   ;
expression: boolean
	  | arithmetic 
	  ;
boolean : expression EQUAL {fprintf(parser_file, "== ");} expression 
        | expression NOT_EQUAL {fprintf(parser_file, "!= ");} expression 
        | expression LESS_THAN {fprintf(parser_file, "< ");} expression 
        | expression LESS_THAN_EQUAL {fprintf(parser_file, "<= ");} expression 
        | expression GREATER_THAN {fprintf(parser_file, "> ");} expression 
        | expression GREATER_THAN_EQUAL {fprintf(parser_file, ">= ");} expression
	;
arithmetic : arithmetic PLUS {fprintf(parser_file, "+ ");} term 
           | arithmetic MINUS {fprintf(parser_file, "- ");} term
           | term
           ;
term : term PROD {fprintf(parser_file, "* ");} expr
     | term DIV {fprintf(parser_file, "\ ");} expr
     | expr
     ;
expr : CIRCULAR_LEFT expr CIRCULAR_RIGHT   
       | ID {fprintf(parser_file, "var-%s ", yylval);}
       | NUM {fprintf(parser_file, "const-%s ", yylval);}
       ;
var : ID {fprintf(parser_file, "identifier: %s\n", yylval);}
    | ID SQUARE_LEFT expression SQUARE_RIGHT {fprintf(parser_file, "[] ");}
    | PROD ID
    ;
%% 

int main(int argc, char *argv[])
{
    if(argc!=2)
    {
        printf("Wrong number of arguments provided.\n");
        exit(0);
    }
    yyin = fopen(argv[1], "r");
    yyout = fopen ("Lexer.text", "w");
    parser_file = fopen("Parser.txt", "w");
    yyparse();
    yylex();
    return 0;
}

void yyerror (const char* message)
{ 
    printf("SYNTAX ERROR : %s\n", message);
    exit(0);
}
