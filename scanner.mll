(* Ocamllex scanner for MicroC *)

{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ']'	   { RBRACK } (*numnum*)
| '['	   { LBRACK } (*numnum*)
| ';'      { SEMI } 
| ':'      { COLON }  (*numnum*)
| ','      { COMMA } 
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '='      { ASSIGN }
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| "&&"     { AND }
| "||"     { OR }
| "!"      { NOT }
| "if"     { IF }
| "else"   { ELSE }
| "elif"   { ELIF } (*numnum*)
| "for"    { FOR }
| "while"  { WHILE }
| "return" { RETURN }
| "break"  { BREAK } (*numnum*)
| "int"    { INT }
| "bool"   { BOOL }
| "void"   { VOID }
| "byte"   { BYTE } (*numnum*)
| "float"  { FLOAT } (*numnum*)
| "string" { STRING } (*numnum*)
| "true"   { TRUE }
| "false"  { FALSE }
| "shape"  { SHAPE } (*numnum*)
| "dims"   { DIMS } (*numnum*)
| "func"   { FUNC } (*numnum*)
| "bc_"("add" "sub" "mul" "div") as lxm { BC_MAT_CALL(lxm) } (*numnum*)
| ['0'-'9']+ as lxm { LITERAL(int_of_string lxm) }
| ['0'-'9']*'.'['0'-'9']+ as lxm { FLITERAL(float_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| '"'(([^'"'])*  as lxm)'"' { SLITERAL(lxm)}
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }
