/*
Copyright Shayan Technologies Corporation. Horizon Grammar file for NextSketch 2.
Modified from the toml.g4 Grammar previously available at
https://github.com/antlr/grammars-v4/blob/master/toml/toml.g4
*/


/*
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at
  http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
*/

grammar Horizon;

/*
 * Parser Rules
 */

document : (canvas_decl (expression)* canvas_decl_end)* ;

expression : (NEWLINE)* entity_type '(' entity_id ')' '[' (key_value*) ']' (NEWLINE)*;

key_value : key '=' value ',';

value : string ;

string : BASIC_STRING | ML_BASIC_STRING | LITERAL_STRING | ML_LITERAL_STRING ;

key : NORMAL_KEY ;

entity_type: 'Node' | 'Link' | 'Container' | 'NodeRef';

entity_id: DEC_INT;

canvas_id: DEC_INT;

canvas_decl: (NEWLINE)* 'Canvas' '(' canvas_id ')' '{' (NEWLINE)*;

canvas_decl_end: (NEWLINE)* '}' (NEWLINE)*;


/*
 * Lexer Rules
 */


WHITESPACE : [ \t]+ -> skip ;
NEWLINE : '\n'? ;

fragment DIGIT : [0-9] ;
fragment ALPHA : [A-Za-z] ;


// strings
fragment ESC : '\\' (["\\/bfnrt] | UNICODE | EX_UNICODE) ;
fragment ML_ESC : '\\' '\r'? '\n' | ESC ;
fragment UNICODE : 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT ;
fragment EX_UNICODE : 'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT ;
BASIC_STRING : '"' (ESC | ~["\\\n])*? '"' ;
ML_BASIC_STRING : '"""' (ML_ESC | ~["\\])*? '"""' ;
LITERAL_STRING : '\'' (~['\n])*? '\'' ;
ML_LITERAL_STRING : '\'\'\'' (.)*? '\'\'\'';

// integers
fragment HEX_DIGIT : [A-Fa-f] | DIGIT ;
fragment DIGIT_1_9 : [1-9] ;
fragment DIGIT_0_7 : [0-7] ;
fragment DIGIT_0_1 : [0-1] ;
DEC_INT : [+-]? (DIGIT | (DIGIT_1_9 (DIGIT | '_' DIGIT)+)) ;

// keys
NORMAL_KEY : (ALPHA | DIGIT | '-' | '_')+ ;
