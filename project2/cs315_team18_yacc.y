%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
extern int yylineno;
%}

%token MAIN
%token LB
%token RB
%token LP
%token RP
%token COMMA
%token END_STATEMENT
%token SINGLE_COMMENT_LINE
%token MULTIPLE_COMMENT_LINE
%token VAR_TYPE
%token ASSIGN_OP
%token ADDITION_OP
%token SUBTRACTION_OP
%token MULTIPLICATION_OP
%token DIVISION_OP
%token MODULO_OP
%token INCREMENT_OP 
%token DECREMENT_OP 
%token EXPONENTIATION_OP;
%token ADDITION_ASSIGNMENT_OP
%token SUBTRACTION_ASSIGNMENT_OP
%token DIVISION_ASSIGNMENT_OP
%token MULTIPLICATION_ASSIGNMENT_OP
%token EQUAL_OP
%token NOT_EQUAL_OP
%token LESS_THAN_OP
%token GREATER_THAN_OP
%token GREATER_OR_EQUAL_OP
%token LESS_OR_EQUAL_OP
%token NEWLINE
%token IDENTIFIER
%token INTEGER
%token DOUBLE
%token BOOLEAN
%token STRING
%token LOGICAL_OR_OP
%token LOGICAL_AND_OP
%token IF
%token ELSE
%token ELSE_IF
%token INT_TYPE
%token DOUBLE_TYPE
%token STRING_TYPE
%token BOOLEAN_TYPE
%token WHILE
%token FOR
%token RETURN
%token FUNCTION
%token EMPTY
%token READ_HEADING
%token READ_ALTITUDE
%token READ_TEMPERATURE
%token VERTICALLY_CLIMB_UP
%token VERTICALLY_DROP_DOWN
%token VERTICALLY_STOP
%token HORIZONTALLY_MOVE_FORWARD
%token HORIZONTALLY_MOVE_BACKWARD
%token HORIZONTALLY_MOVE_TOWARDS
%token HORIZONTALLY_MOVE_STOP
%token TURN_LEFT
%token TURN_RIGHT
%token SPRAY_ON
%token SPRAY_OFF
%token CONNECT_WITH_COMPUTER
%token CONNECT_WITH_MOBILE_DEVICE
%token INPUT
%token EXIT
%token PRINT
%start program
%%
//————————————RULES————————————
//————————————Types and Constants————————————
null_statement:
        		EMPTY;

arithmetic_operators: 
		ADDITION_OP
		|SUBTRACTION_OP
		|MULTIPLICATION_OP
		|DIVISION_OP
		|MODULO_OP
		|EXPONENTIATION_OP
		;

relational_operators: 
		LESS_THAN_OP
		|LESS_OR_EQUAL_OP
		|GREATER_THAN_OP
		|GREATER_OR_EQUAL_OP
		|EQUAL_OP
		|NOT_EQUAL_OP
		;

assignment_operators: 
		ASSIGN_OP
		|ADDITION_ASSIGNMENT_OP
		|SUBTRACTION_ASSIGNMENT_OP
		|DIVISION_ASSIGNMENT_OP
		|MULTIPLICATION_ASSIGNMENT_OP
		;

relational_types: 
		IDENTIFIER
		|DOUBLE
		|INTEGER
		|STRING
		;

//————————————Program Definition————————————
program:
	main
	;

main:
	MAIN LP RP LB statements RB
	;

statements: statement
		 |statement NEWLINE
		 |statement NEWLINE statements
		 |NEWLINE
		 |NEWLINE statements
		 ;

statement: comment
		|expression END_STATEMENT
		|loop_statement
		|function_statement
		|conditional_statement
		;
 
comment: SINGLE_COMMENT_LINE
	   |MULTIPLE_COMMENT_LINE
	   ;

expression: var_declaration_list
		 |integer_expression
		 |boolean_expression
		 |string_expression
		 |arithmetic_expression
		 |relational_expression
		 |bitwise_expression
		 |assignment_operators
		 |increment_expression
		 |decrement_expression
		 ;

//————————————Blocks and Arguments————————————
args_type: IDENTIFIER
		    |BOOLEAN
		    |INTEGER
		    |STRING
		    ;

block_statements: null_statement
			  |statements RETURN args_type END_STATEMENT
			  |statements RETURN args_type END_STATEMENT NEWLINE
			  |statements
			  ;

//————————————Loop Statements————————————
loop_statement: 
		while_statement
		|for_statement
		;

while_statement: WHILE LP relational_expression RP LB block_statements RB
		|WHILE LP boolean_expression RP LB block_statements RB
		|WHILE LP bitwise_expression RP LB block_statements RB
		;

for_statement:
	FOR LP integer_expression END_STATEMENT relational_expression END_STATEMENT arithmetic_expression RP LB block_statements RB
	|FOR LP integer_expression END_STATEMENT relational_expression END_STATEMENT increment_expression RP LB block_statements RB
	|FOR LP integer_expression END_STATEMENT relational_expression END_STATEMENT decrement_expression RP LB block_statements RB
	;

//————————————Conditional Statements————————————
conditional_statement: 
		if_statement
		;
conditional_expressions:
		relational_expression 
		|boolean_expression 
		|function_call
		|bitwise_expression
		;
if_statement: 
	IF LP conditional_expressions RP LB block_statements RB if_statement
    |IF LP conditional_expressions RP LB block_statements RB else_statement
	|IF LP conditional_expressions RP LB block_statements RB else_if_statement
	;

else_if_statement: 
		ELSE IF LP conditional_expressions RP LB block_statements RB else_if_statement
		|ELSE IF LP conditional_expressions RP LB block_statements RB else_statement
		;

else_statement: 
		ELSE LB block_statements RB
		;

//————————————Function Statements————————————
function_statement: 
		function_declaration
				 |function_call
                 |function_assignment
		;

var_declaration_list: 
		var_declaration COMMA var_declaration_list
		|var_declaration
		;

composite_arguments: 
		args_type COMMA composite_arguments
		|args_type
		;

function_declaration: 
		FUNCTION IDENTIFIER LP var_declaration_list RP LB block_statements RB
		;

function_call: 
		IDENTIFIER LP composite_arguments RP 
		|built_in_function LP RP 
		|built_in_function LP composite_arguments RP 
		|IDENTIFIER LP composite_arguments RP END_STATEMENT
		|built_in_function LP RP END_STATEMENT
		|built_in_function LP composite_arguments RP END_STATEMENT
		;

function_assignment: 
		IDENTIFIER ASSIGN_OP function_call
		|var_declaration ASSIGN_OP function_call
		;

built_in_function: 
		READ_HEADING
		|READ_ALTITUDE
		|READ_TEMPERATURE
		|VERTICALLY_CLIMB_UP
		|VERTICALLY_DROP_DOWN
		|VERTICALLY_STOP
		|HORIZONTALLY_MOVE_FORWARD
		|HORIZONTALLY_MOVE_BACKWARD
		|HORIZONTALLY_MOVE_TOWARDS
		|HORIZONTALLY_MOVE_STOP
		|TURN_LEFT
		|TURN_RIGHT
		|SPRAY_ON
		|SPRAY_OFF
		|CONNECT_WITH_COMPUTER
        |CONNECT_WITH_MOBILE_DEVICE
		|INPUT
		|PRINT
		|EXIT
		;
		
//————————————Expressions————————————
var_declaration: 
		VAR_TYPE IDENTIFIER
		;

integer_expression: 
		IDENTIFIER assignment_operators INTEGER
                 |var_declaration ASSIGN_OP INTEGER
		;

boolean_expression: 
		IDENTIFIER ASSIGN_OP BOOLEAN
                 |var_declaration ASSIGN_OP BOOLEAN
		;

string_expression: 
		IDENTIFIER ASSIGN_OP STRING
                 |var_declaration ASSIGN_OP STRING
		;

arithmetic_expression: 
		INTEGER arithmetic_operators arithmetic_expression
                 |INTEGER
		;

relational_expression: 
		relational_types relational_operators relational_types
		;

bitwise_expression:
		relational_expression LOGICAL_OR_OP relational_expression
		|relational_expression LOGICAL_AND_OP relational_expression 
		|BOOLEAN LOGICAL_OR_OP BOOLEAN
        |BOOLEAN LOGICAL_AND_OP BOOLEAN
		;

increment_expression: 
		preincrement_expression
                 |postincrement_expression
		;

preincrement_expression: 
		INCREMENT_OP INTEGER
		|INCREMENT_OP IDENTIFIER
		;
				 

postincrement_expression: 
			INTEGER INCREMENT_OP
			|IDENTIFIER INCREMENT_OP
			;

decrement_expression: 
		predecrement_expression
		|postdecrement_expression
		;

postdecrement_expression: 
			INTEGER DECREMENT_OP
			|IDENTIFIER DECREMENT_OP
			;

predecrement_expression: 
			DECREMENT_OP INTEGER
			|DECREMENT_OP IDENTIFIER
			;
%%	
void yyerror(char *s) {
	fprintf(stdout, "line %d: %s\n", yylineno,s);
}
int main(void){
 yyparse();
if(yynerrs < 1){
		printf("Parsing: SUCCESSFUL!\n");
	}
 return 0;
}