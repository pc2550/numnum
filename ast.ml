(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq |
          And | Or

type uop = Neg | Not

type typ = Int | Bool | Void 
        | Float | String | Byte
        | Matrix of typ * int list

type bind = typ * string 

type expr =
    Literal of int
  | FLiteral of float
  | BoolLit of bool
  | SLiteral of string
  | Id of string
  | Binop of expr * op * expr
  | Unop of uop * expr
  | Assign of string * expr
  | Call of string * expr list
  | MatrixAccess of string * expr list
  | MatrixAssign of string * expr list * expr
  | Noexpr

type stmt =
    Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | Elif of expr list * stmt list
  | For of expr * expr * expr * stmt
  | While of expr * stmt

type func_decl = {
    typ : typ;
    fname : string;
    formals : bind list;
    locals : bind list;
    body : stmt list;
  }



type program = bind list * func_decl list

(* Pretty-printing functions *)

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | And -> "&&"
  | Or -> "||"

let string_of_uop = function
    Neg -> "-"
  | Not -> "!"

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | FLiteral(l) -> string_of_float l
  | SLiteral(l) -> l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | Id(s) -> s
  | MatrixAccess (t,dims) -> t ^ (List.fold_left (fun acc el -> "[" ^ (string_of_expr el) ^ "]" ^ acc) "" dims)
  | MatrixAssign (t,dims,e) -> let r = string_of_expr e in
      t ^ (List.fold_left (fun acc el -> "[" ^ (string_of_expr el) ^ "]" ^ acc )"" dims) ^ " = " ^ r
  | Binop(e1, o, e2) -> 
        let l = string_of_expr e1 and r = string_of_expr e2 in
            (l ^ " " ^ string_of_op o ^ " " ^ r)
  | Unop(o, e) -> string_of_uop o ^ string_of_expr e
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"
  | Noexpr -> ""

let rec string_of_stmt = function
    Block(stmts) ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n";
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n";
  | If(e, s, Block([])) -> "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | Elif(exprs, stmts) ->  "if (" ^ string_of_expr (List.hd exprs) ^ ")\n" ^
      string_of_stmt (List.hd stmts)
      ^ String.concat "" (List.map2 (fun e s -> "elif (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s) (List.tl exprs) (List.tl (List.rev (List.tl (List.rev stmts))))) 
      ^ "else\n" ^ string_of_stmt (List.hd (List.rev stmts))
  | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let rec string_of_typ = function
    Int -> "int"
  | Bool -> "bool"
  | Void -> "void"
  | Float -> "float"
  | String -> "string"
  | Byte -> "byte"
  | Matrix(t, l) -> (string_of_typ t) ^ (List.fold_left (fun acc el -> acc ^ "[" ^ (string_of_int el) ^ "]" ) "" l)

let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.typ ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_program (vars, funcs) =
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
