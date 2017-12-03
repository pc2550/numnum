type token =
  | SEMI
  | LPAREN
  | RPAREN
  | LBRACE
  | RBRACE
  | COMMA
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | ASSIGN
  | NOT
  | EQ
  | NEQ
  | LT
  | LEQ
  | GT
  | GEQ
  | TRUE
  | FALSE
  | AND
  | OR
  | RETURN
  | IF
  | ELSE
  | FOR
  | WHILE
  | INT
  | BOOL
  | VOID
  | RBRACK
  | LBRACK
  | ELIF
  | BREAK
  | FLOAT
  | STRING
  | SHAPE
  | DIMS
  | FUNC
  | LITERAL of (int)
  | FLITERAL of (float)
  | ID of (string)
  | SLITERAL of (string)
  | EOF

open Parsing;;
let _ = parse_error;;
# 4 "parser.mly"
open Ast
# 52 "parser.ml"
let yytransl_const = [|
  257 (* SEMI *);
  258 (* LPAREN *);
  259 (* RPAREN *);
  260 (* LBRACE *);
  261 (* RBRACE *);
  262 (* COMMA *);
  263 (* PLUS *);
  264 (* MINUS *);
  265 (* TIMES *);
  266 (* DIVIDE *);
  267 (* ASSIGN *);
  268 (* NOT *);
  269 (* EQ *);
  270 (* NEQ *);
  271 (* LT *);
  272 (* LEQ *);
  273 (* GT *);
  274 (* GEQ *);
  275 (* TRUE *);
  276 (* FALSE *);
  277 (* AND *);
  278 (* OR *);
  279 (* RETURN *);
  280 (* IF *);
  281 (* ELSE *);
  282 (* FOR *);
  283 (* WHILE *);
  284 (* INT *);
  285 (* BOOL *);
  286 (* VOID *);
  287 (* RBRACK *);
  288 (* LBRACK *);
  289 (* ELIF *);
  290 (* BREAK *);
  291 (* FLOAT *);
  292 (* STRING *);
  293 (* SHAPE *);
  294 (* DIMS *);
  295 (* FUNC *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  296 (* LITERAL *);
  297 (* FLITERAL *);
  298 (* ID *);
  299 (* SLITERAL *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\004\000\009\000\010\000\010\000\
\011\000\006\000\006\000\012\000\012\000\005\000\005\000\005\000\
\005\000\005\000\007\000\007\000\003\000\003\000\008\000\008\000\
\013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
\013\000\013\000\015\000\015\000\017\000\016\000\016\000\014\000\
\014\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
\014\000\014\000\014\000\014\000\014\000\014\000\014\000\014\000\
\014\000\014\000\014\000\014\000\014\000\014\000\018\000\018\000\
\019\000\019\000\000\000"

let yylen = "\002\000\
\002\000\000\000\002\000\002\000\009\000\001\000\001\000\002\000\
\003\000\000\000\001\000\002\000\004\000\001\000\001\000\001\000\
\001\000\001\000\000\000\002\000\003\000\004\000\000\000\002\000\
\002\000\002\000\003\000\003\000\005\000\007\000\006\000\008\000\
\009\000\005\000\001\000\002\000\005\000\000\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\002\000\002\000\003\000\004\000\003\000\000\000\001\000\
\001\000\003\000\002\000"

let yydefred = "\000\000\
\002\000\000\000\067\000\000\000\014\000\015\000\016\000\017\000\
\018\000\001\000\003\000\004\000\000\000\000\000\021\000\000\000\
\000\000\000\000\007\000\000\000\000\000\000\000\006\000\000\000\
\022\000\008\000\012\000\000\000\000\000\009\000\019\000\000\000\
\000\000\013\000\020\000\000\000\000\000\000\000\000\000\023\000\
\005\000\000\000\000\000\043\000\044\000\000\000\000\000\000\000\
\000\000\040\000\041\000\000\000\042\000\024\000\000\000\000\000\
\000\000\058\000\059\000\026\000\000\000\000\000\000\000\000\000\
\000\000\000\000\025\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\062\000\
\028\000\027\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\048\000\049\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\061\000\000\000\000\000\000\000\034\000\000\000\000\000\
\000\000\000\000\035\000\000\000\030\000\000\000\000\000\036\000\
\000\000\000\000\032\000\000\000\000\000\033\000\037\000"

let yydgoto = "\002\000\
\003\000\004\000\011\000\012\000\013\000\021\000\033\000\037\000\
\024\000\018\000\019\000\022\000\054\000\055\000\114\000\085\000\
\115\000\088\000\089\000"

let yysindex = "\005\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\224\254\011\255\000\000\028\255\
\248\254\013\255\000\000\242\254\047\255\055\255\000\000\054\255\
\000\000\000\000\000\000\068\255\028\255\000\000\000\000\036\255\
\028\255\000\000\000\000\046\255\082\255\014\255\220\255\000\000\
\000\000\220\255\220\255\000\000\000\000\040\255\087\255\096\255\
\102\255\000\000\000\000\000\255\000\000\000\000\236\255\221\000\
\091\255\000\000\000\000\000\000\002\000\220\255\220\255\220\255\
\220\255\220\255\000\000\220\255\220\255\220\255\220\255\220\255\
\220\255\220\255\220\255\220\255\220\255\220\255\220\255\000\000\
\000\000\000\000\237\000\029\001\106\255\253\000\029\001\109\255\
\107\255\029\001\057\255\057\255\000\000\000\000\072\001\072\001\
\119\255\119\255\119\255\119\255\060\001\045\001\193\255\220\255\
\193\255\000\000\220\255\239\254\050\000\000\000\029\001\193\255\
\114\255\240\254\000\000\220\255\000\000\220\255\193\255\000\000\
\116\255\013\001\000\000\193\255\193\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\117\255\
\000\000\000\000\000\000\000\000\000\000\118\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\133\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\032\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\129\255\000\000\
\136\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\018\255\000\000\000\000\041\255\000\000\
\137\255\117\000\072\000\094\000\000\000\000\000\188\000\205\000\
\116\000\138\000\160\000\182\000\070\255\048\255\000\000\000\000\
\000\000\000\000\000\000\142\255\000\000\000\000\094\255\000\000\
\000\000\184\255\000\000\139\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\103\000\000\000\245\255\000\000\000\000\108\000\
\000\000\000\000\125\000\000\000\206\255\217\255\000\000\033\000\
\037\000\000\000\000\000"

let yytablesize = 602
let yytable = "\056\000\
\010\000\065\000\058\000\059\000\020\000\001\000\061\000\112\000\
\119\000\014\000\066\000\015\000\016\000\025\000\015\000\113\000\
\113\000\032\000\039\000\023\000\039\000\036\000\083\000\084\000\
\086\000\087\000\090\000\027\000\091\000\092\000\093\000\094\000\
\095\000\096\000\097\000\098\000\099\000\100\000\101\000\102\000\
\060\000\039\000\017\000\065\000\017\000\017\000\065\000\042\000\
\057\000\028\000\057\000\043\000\108\000\057\000\110\000\005\000\
\006\000\007\000\044\000\045\000\029\000\117\000\008\000\009\000\
\109\000\070\000\071\000\111\000\123\000\057\000\056\000\031\000\
\056\000\126\000\127\000\056\000\084\000\034\000\122\000\050\000\
\051\000\052\000\053\000\039\000\030\000\040\000\041\000\038\000\
\062\000\042\000\056\000\056\000\039\000\043\000\040\000\081\000\
\066\000\063\000\042\000\066\000\044\000\045\000\043\000\064\000\
\046\000\047\000\104\000\048\000\049\000\044\000\045\000\106\000\
\107\000\046\000\047\000\118\000\048\000\049\000\124\000\010\000\
\011\000\050\000\051\000\052\000\053\000\068\000\069\000\070\000\
\071\000\038\000\050\000\051\000\052\000\053\000\023\000\035\000\
\023\000\023\000\063\000\064\000\023\000\038\000\026\000\029\000\
\023\000\029\000\029\000\057\000\121\000\029\000\120\000\023\000\
\023\000\029\000\000\000\023\000\023\000\000\000\023\000\023\000\
\029\000\029\000\000\000\000\000\029\000\029\000\000\000\029\000\
\029\000\000\000\000\000\000\000\023\000\023\000\023\000\023\000\
\000\000\000\000\000\000\000\000\000\000\029\000\029\000\029\000\
\029\000\031\000\000\000\031\000\031\000\000\000\000\000\031\000\
\000\000\000\000\039\000\031\000\040\000\000\000\000\000\000\000\
\042\000\000\000\031\000\031\000\043\000\000\000\031\000\031\000\
\000\000\031\000\031\000\044\000\045\000\000\000\000\000\046\000\
\047\000\000\000\048\000\049\000\000\000\039\000\000\000\031\000\
\031\000\031\000\031\000\042\000\000\000\000\000\000\000\043\000\
\050\000\051\000\052\000\053\000\067\000\000\000\044\000\045\000\
\000\000\000\000\068\000\069\000\070\000\071\000\000\000\000\000\
\072\000\073\000\074\000\075\000\076\000\077\000\000\000\000\000\
\078\000\079\000\082\000\050\000\051\000\052\000\053\000\000\000\
\068\000\069\000\070\000\071\000\000\000\000\000\072\000\073\000\
\074\000\075\000\076\000\077\000\000\000\000\000\078\000\079\000\
\000\000\000\000\000\000\000\000\005\000\006\000\007\000\000\000\
\045\000\000\000\045\000\008\000\009\000\045\000\045\000\045\000\
\045\000\045\000\000\000\000\000\045\000\045\000\045\000\045\000\
\045\000\045\000\116\000\000\000\045\000\045\000\000\000\000\000\
\068\000\069\000\070\000\071\000\000\000\000\000\072\000\073\000\
\074\000\075\000\076\000\077\000\000\000\000\000\078\000\079\000\
\046\000\000\000\046\000\000\000\000\000\046\000\046\000\046\000\
\000\000\000\000\000\000\000\000\046\000\046\000\046\000\046\000\
\046\000\046\000\000\000\000\000\046\000\046\000\047\000\000\000\
\047\000\000\000\000\000\047\000\047\000\047\000\000\000\000\000\
\000\000\000\000\047\000\047\000\047\000\047\000\047\000\047\000\
\000\000\000\000\047\000\047\000\052\000\060\000\052\000\060\000\
\000\000\052\000\060\000\000\000\000\000\000\000\000\000\000\000\
\052\000\052\000\052\000\052\000\052\000\052\000\000\000\000\000\
\052\000\052\000\053\000\000\000\053\000\000\000\000\000\053\000\
\000\000\000\000\000\000\000\000\000\000\000\000\053\000\053\000\
\053\000\053\000\053\000\053\000\000\000\000\000\053\000\053\000\
\054\000\000\000\054\000\000\000\000\000\054\000\000\000\000\000\
\000\000\000\000\000\000\000\000\054\000\054\000\054\000\054\000\
\054\000\054\000\000\000\000\000\054\000\054\000\055\000\000\000\
\055\000\000\000\000\000\055\000\050\000\000\000\050\000\000\000\
\000\000\050\000\055\000\055\000\055\000\055\000\055\000\055\000\
\050\000\050\000\055\000\055\000\000\000\051\000\000\000\051\000\
\050\000\050\000\051\000\000\000\000\000\000\000\000\000\000\000\
\000\000\051\000\051\000\000\000\000\000\000\000\000\000\080\000\
\000\000\051\000\051\000\068\000\069\000\070\000\071\000\000\000\
\000\000\072\000\073\000\074\000\075\000\076\000\077\000\103\000\
\000\000\078\000\079\000\068\000\069\000\070\000\071\000\000\000\
\000\000\072\000\073\000\074\000\075\000\076\000\077\000\105\000\
\000\000\078\000\079\000\068\000\069\000\070\000\071\000\000\000\
\000\000\072\000\073\000\074\000\075\000\076\000\077\000\125\000\
\000\000\078\000\079\000\068\000\069\000\070\000\071\000\000\000\
\000\000\072\000\073\000\074\000\075\000\076\000\077\000\000\000\
\000\000\078\000\079\000\068\000\069\000\070\000\071\000\000\000\
\000\000\072\000\073\000\074\000\075\000\076\000\077\000\000\000\
\000\000\078\000\079\000\068\000\069\000\070\000\071\000\000\000\
\000\000\072\000\073\000\074\000\075\000\076\000\077\000\000\000\
\000\000\078\000\068\000\069\000\070\000\071\000\000\000\000\000\
\072\000\073\000\074\000\075\000\076\000\077\000\068\000\069\000\
\070\000\071\000\000\000\000\000\000\000\000\000\074\000\075\000\
\076\000\077\000"

let yycheck = "\039\000\
\000\000\002\001\042\000\043\000\016\000\001\000\046\000\025\001\
\025\001\042\001\011\001\001\001\002\001\001\001\001\001\033\001\
\033\001\029\000\001\001\028\001\003\001\033\000\062\000\063\000\
\064\000\065\000\066\000\042\001\068\000\069\000\070\000\071\000\
\072\000\073\000\074\000\075\000\076\000\077\000\078\000\079\000\
\001\001\002\001\032\001\003\001\032\001\032\001\006\001\008\001\
\001\001\003\001\003\001\012\001\103\000\006\001\105\000\028\001\
\029\001\030\001\019\001\020\001\006\001\112\000\035\001\036\001\
\104\000\009\001\010\001\107\000\119\000\022\001\001\001\004\001\
\003\001\124\000\125\000\006\001\116\000\042\001\118\000\040\001\
\041\001\042\001\043\001\002\001\031\001\004\001\005\001\042\001\
\002\001\008\001\021\001\022\001\002\001\012\001\004\001\005\001\
\003\001\002\001\008\001\006\001\019\001\020\001\012\001\002\001\
\023\001\024\001\001\001\026\001\027\001\019\001\020\001\003\001\
\006\001\023\001\024\001\002\001\026\001\027\001\003\001\003\001\
\003\001\040\001\041\001\042\001\043\001\007\001\008\001\009\001\
\010\001\001\001\040\001\041\001\042\001\043\001\002\001\033\000\
\004\001\005\001\003\001\003\001\008\001\003\001\018\000\002\001\
\012\001\004\001\005\001\040\000\116\000\008\001\114\000\019\001\
\020\001\012\001\255\255\023\001\024\001\255\255\026\001\027\001\
\019\001\020\001\255\255\255\255\023\001\024\001\255\255\026\001\
\027\001\255\255\255\255\255\255\040\001\041\001\042\001\043\001\
\255\255\255\255\255\255\255\255\255\255\040\001\041\001\042\001\
\043\001\002\001\255\255\004\001\005\001\255\255\255\255\008\001\
\255\255\255\255\002\001\012\001\004\001\255\255\255\255\255\255\
\008\001\255\255\019\001\020\001\012\001\255\255\023\001\024\001\
\255\255\026\001\027\001\019\001\020\001\255\255\255\255\023\001\
\024\001\255\255\026\001\027\001\255\255\002\001\255\255\040\001\
\041\001\042\001\043\001\008\001\255\255\255\255\255\255\012\001\
\040\001\041\001\042\001\043\001\001\001\255\255\019\001\020\001\
\255\255\255\255\007\001\008\001\009\001\010\001\255\255\255\255\
\013\001\014\001\015\001\016\001\017\001\018\001\255\255\255\255\
\021\001\022\001\001\001\040\001\041\001\042\001\043\001\255\255\
\007\001\008\001\009\001\010\001\255\255\255\255\013\001\014\001\
\015\001\016\001\017\001\018\001\255\255\255\255\021\001\022\001\
\255\255\255\255\255\255\255\255\028\001\029\001\030\001\255\255\
\001\001\255\255\003\001\035\001\036\001\006\001\007\001\008\001\
\009\001\010\001\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\001\001\255\255\021\001\022\001\255\255\255\255\
\007\001\008\001\009\001\010\001\255\255\255\255\013\001\014\001\
\015\001\016\001\017\001\018\001\255\255\255\255\021\001\022\001\
\001\001\255\255\003\001\255\255\255\255\006\001\007\001\008\001\
\255\255\255\255\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\255\255\255\255\021\001\022\001\001\001\255\255\
\003\001\255\255\255\255\006\001\007\001\008\001\255\255\255\255\
\255\255\255\255\013\001\014\001\015\001\016\001\017\001\018\001\
\255\255\255\255\021\001\022\001\001\001\001\001\003\001\003\001\
\255\255\006\001\006\001\255\255\255\255\255\255\255\255\255\255\
\013\001\014\001\015\001\016\001\017\001\018\001\255\255\255\255\
\021\001\022\001\001\001\255\255\003\001\255\255\255\255\006\001\
\255\255\255\255\255\255\255\255\255\255\255\255\013\001\014\001\
\015\001\016\001\017\001\018\001\255\255\255\255\021\001\022\001\
\001\001\255\255\003\001\255\255\255\255\006\001\255\255\255\255\
\255\255\255\255\255\255\255\255\013\001\014\001\015\001\016\001\
\017\001\018\001\255\255\255\255\021\001\022\001\001\001\255\255\
\003\001\255\255\255\255\006\001\001\001\255\255\003\001\255\255\
\255\255\006\001\013\001\014\001\015\001\016\001\017\001\018\001\
\013\001\014\001\021\001\022\001\255\255\001\001\255\255\003\001\
\021\001\022\001\006\001\255\255\255\255\255\255\255\255\255\255\
\255\255\013\001\014\001\255\255\255\255\255\255\255\255\003\001\
\255\255\021\001\022\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\003\001\
\255\255\021\001\022\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\003\001\
\255\255\021\001\022\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\003\001\
\255\255\021\001\022\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\255\255\
\255\255\021\001\022\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\255\255\
\255\255\021\001\022\001\007\001\008\001\009\001\010\001\255\255\
\255\255\013\001\014\001\015\001\016\001\017\001\018\001\255\255\
\255\255\021\001\007\001\008\001\009\001\010\001\255\255\255\255\
\013\001\014\001\015\001\016\001\017\001\018\001\007\001\008\001\
\009\001\010\001\255\255\255\255\255\255\255\255\015\001\016\001\
\017\001\018\001"

let yynames_const = "\
  SEMI\000\
  LPAREN\000\
  RPAREN\000\
  LBRACE\000\
  RBRACE\000\
  COMMA\000\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIVIDE\000\
  ASSIGN\000\
  NOT\000\
  EQ\000\
  NEQ\000\
  LT\000\
  LEQ\000\
  GT\000\
  GEQ\000\
  TRUE\000\
  FALSE\000\
  AND\000\
  OR\000\
  RETURN\000\
  IF\000\
  ELSE\000\
  FOR\000\
  WHILE\000\
  INT\000\
  BOOL\000\
  VOID\000\
  RBRACK\000\
  LBRACK\000\
  ELIF\000\
  BREAK\000\
  FLOAT\000\
  STRING\000\
  SHAPE\000\
  DIMS\000\
  FUNC\000\
  EOF\000\
  "

let yynames_block = "\
  LITERAL\000\
  FLITERAL\000\
  ID\000\
  SLITERAL\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    Obj.repr(
# 36 "parser.mly"
            ( _1 )
# 403 "parser.ml"
               : Ast.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 39 "parser.mly"
                 ( [], [] )
# 409 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 40 "parser.mly"
               ( (_2 :: fst _1), snd _1 )
# 417 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decls) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'fdecl) in
    Obj.repr(
# 41 "parser.mly"
               ( fst _1, (_2 :: snd _1) )
# 425 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 8 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 7 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 5 : 'formals_opt) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'vdecl_list) in
    let _8 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 45 "parser.mly"
     ( { typ = _1;
	 fname = _2;
	 formals = _4;
	 locals = List.rev _7;
	 body = List.rev _8 } )
# 440 "parser.ml"
               : 'fdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 53 "parser.mly"
      (Int)
# 446 "parser.ml"
               : 'matrix_size))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'matrix_params) in
    Obj.repr(
# 56 "parser.mly"
                ( [_1] )
# 453 "parser.ml"
               : 'matrix_plist))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'matrix_plist) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'matrix_params) in
    Obj.repr(
# 57 "parser.mly"
                               (_2 :: _1)
# 461 "parser.ml"
               : 'matrix_plist))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'matrix_size) in
    Obj.repr(
# 60 "parser.mly"
                            (_2)
# 468 "parser.ml"
               : 'matrix_params))
; (fun __caml_parser_env ->
    Obj.repr(
# 63 "parser.mly"
                  ( [] )
# 474 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'formal_list) in
    Obj.repr(
# 64 "parser.mly"
                  ( List.rev _1 )
# 481 "parser.ml"
               : 'formals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 67 "parser.mly"
                             ( [(_1,_2)] )
# 489 "parser.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'formal_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 68 "parser.mly"
                             ( (_3,_4) :: _1 )
# 498 "parser.ml"
               : 'formal_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "parser.mly"
        ( Int )
# 504 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 72 "parser.mly"
         ( Bool )
# 510 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 73 "parser.mly"
         ( Void )
# 516 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 74 "parser.mly"
          ( Float )
# 522 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
           ( String)
# 528 "parser.ml"
               : 'typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 78 "parser.mly"
                     ( [] )
# 534 "parser.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'vdecl_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'vdecl) in
    Obj.repr(
# 79 "parser.mly"
                     ( _2 :: _1 )
# 542 "parser.ml"
               : 'vdecl_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 82 "parser.mly"
               ( (_1, _2) )
# 550 "parser.ml"
               : 'vdecl))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'matrix_plist) in
    Obj.repr(
# 83 "parser.mly"
                            ( (_1, _2))
# 559 "parser.ml"
               : 'vdecl))
; (fun __caml_parser_env ->
    Obj.repr(
# 86 "parser.mly"
                   ( [] )
# 565 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 87 "parser.mly"
                   ( _2 :: _1 )
# 573 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 90 "parser.mly"
              ( Expr _1 )
# 580 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 91 "parser.mly"
                ( Return Noexpr )
# 586 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 92 "parser.mly"
                     ( Return _2 )
# 593 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 93 "parser.mly"
                            ( Block(List.rev _2) )
# 600 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 94 "parser.mly"
                                            ( If(_3, _5, Block([])) )
# 608 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 95 "parser.mly"
                                            ( If(_3, _5, _7) )
# 617 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'stmt) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'elif_list) in
    Obj.repr(
# 96 "parser.mly"
                                                      ( Elif((_3 :: fst _6), (_5 :: snd _6)) )
# 626 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 3 : 'stmt) in
    let _6 = (Parsing.peek_val __caml_parser_env 2 : 'elif_list) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 97 "parser.mly"
                                                   ( Elif((_3 :: fst _6), (_8 :: (_5 :: snd _6))) )
# 636 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 6 : 'expr_opt) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'expr_opt) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 99 "parser.mly"
     ( For(_3, _5, _7, _9) )
# 646 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 100 "parser.mly"
                                  ( While(_3, _5) )
# 654 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'elif) in
    Obj.repr(
# 103 "parser.mly"
         ([fst _1],[snd _1])
# 661 "parser.ml"
               : 'elif_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'elif_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'elif) in
    Obj.repr(
# 104 "parser.mly"
                   ((fst _2 :: fst _1 ), (snd _2 :: snd _1 ))
# 669 "parser.ml"
               : 'elif_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 107 "parser.mly"
                                (_3,_5)
# 677 "parser.ml"
               : 'elif))
; (fun __caml_parser_env ->
    Obj.repr(
# 110 "parser.mly"
                  ( Noexpr )
# 683 "parser.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 111 "parser.mly"
                  ( _1 )
# 690 "parser.ml"
               : 'expr_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 114 "parser.mly"
                     ( Literal(_1) )
# 697 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 115 "parser.mly"
                     ( FLiteral(_1) )
# 704 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 116 "parser.mly"
               ( SLiteral(_1) )
# 711 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 117 "parser.mly"
                     ( BoolLit(true) )
# 717 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 118 "parser.mly"
                     ( BoolLit(false) )
# 723 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 119 "parser.mly"
                     ( Id(_1) )
# 730 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 120 "parser.mly"
                     ( Binop(_1, Add,   _3) )
# 738 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 121 "parser.mly"
                     ( Binop(_1, Sub,   _3) )
# 746 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 122 "parser.mly"
                     ( Binop(_1, Mult,  _3) )
# 754 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 123 "parser.mly"
                     ( Binop(_1, Div,   _3) )
# 762 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 124 "parser.mly"
                     ( Binop(_1, Equal, _3) )
# 770 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 125 "parser.mly"
                     ( Binop(_1, Neq,   _3) )
# 778 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 126 "parser.mly"
                     ( Binop(_1, Less,  _3) )
# 786 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 127 "parser.mly"
                     ( Binop(_1, Leq,   _3) )
# 794 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 128 "parser.mly"
                     ( Binop(_1, Greater, _3) )
# 802 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 129 "parser.mly"
                     ( Binop(_1, Geq,   _3) )
# 810 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 130 "parser.mly"
                     ( Binop(_1, And,   _3) )
# 818 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 131 "parser.mly"
                     ( Binop(_1, Or,    _3) )
# 826 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 132 "parser.mly"
                         ( Unop(Neg, _2) )
# 833 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 133 "parser.mly"
                     ( Unop(Not, _2) )
# 840 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 134 "parser.mly"
                     ( Assign(_1, _3) )
# 848 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'actuals_opt) in
    Obj.repr(
# 135 "parser.mly"
                                 ( Call(_1, _3) )
# 856 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 136 "parser.mly"
                       ( _2 )
# 863 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 139 "parser.mly"
                  ( [] )
# 869 "parser.ml"
               : 'actuals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'actuals_list) in
    Obj.repr(
# 140 "parser.mly"
                  ( List.rev _1 )
# 876 "parser.ml"
               : 'actuals_opt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 143 "parser.mly"
                            ( [_1] )
# 883 "parser.ml"
               : 'actuals_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'actuals_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 144 "parser.mly"
                            ( _3 :: _1 )
# 891 "parser.ml"
               : 'actuals_list))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.program)
