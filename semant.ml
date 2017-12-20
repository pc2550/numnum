(* Semantic checking for the MicroC compiler *)
open Ast
  
module StringMap = Map.Make(String)


(* Semantic checking of a program. Returns void if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)
let check (globals, functions) =
  (* Raise an exception if the given list has a duplicate *)
  let report_duplicate exceptf list =
    let rec helper =
      function
      | n1 :: n2 :: _ when n1 = n2 -> raise (Failure (exceptf n1))
      | _ :: t -> helper t
      | [] -> ()
    in helper (List.sort compare list) in
  (* Raise an exception if a given binding is to a void type *)
  let check_not_void exceptf =
    function | (Void, n) -> raise (Failure (exceptf n)) | _ -> () in
  (* Raise an exception of the given rvalue type cannot be assigned to
     the given lvalue type *)
  let is_int_type a = (match a with
    | Int|Byte|Float -> true
    | Matrix (t,_) -> (match t with
        Int|Byte|Float -> true
        | _ -> false )
    | _ -> false
  ) in
  let check_assign lvaluet rvaluet err =
    if lvaluet == rvaluet then lvaluet 
    else if (is_int_type lvaluet) &&  (is_int_type rvaluet) then lvaluet
    else raise err
  in

    (**** Checking Global Variables ****)
    (**** Checking Functions ****)
    (List.iter (check_not_void (fun n -> "illegal void global " ^ n)) globals;
     report_duplicate (fun n -> "duplicate global " ^ n)
       (List.map snd globals);
     if List.mem "print" (List.map (fun fd -> fd.fname) functions)
     then raise (Failure "function print may not be defined")
     else ();
     report_duplicate (fun n -> "duplicate function " ^ n)
       (List.map (fun fd -> fd.fname) functions);
     (* Function declaration for a named function *)
     let built_in_decls =
        StringMap.add "dim"
         {
           typ = Int;
           fname = "dim";
           (* The arguments to Matrix
           don't matter, they are overridden in the checker below, but we need
           them here for this to compile *)
           formals = [ (Matrix(Int, [1]), "x") ]; 
           locals = [];
           body = [];
         }
 
       (StringMap.add "print"
         {
           typ = Void;
           fname = "print";
           formals = [ (Int, "x") ];
           locals = [];
           body = [];
         }
         (StringMap.add "open"
         {
           typ = Int;
           fname = "open";
           formals = [ (String, "x"); (Int,"y") ];
           locals = [];
           body = [];
         }
         (StringMap.add "read"
         {
           typ = Int;
           fname = "read";
           formals = [(String,"w"); ((Matrix( Byte , [])), "x") ];
           locals = [];
           body = [];
         }
         (StringMap.add "write"
         {
           typ = Int;
           fname = "write";
           formals = [(String,"w"); ((Matrix( Byte , [])), "x") ];
           locals = [];
           body = [];
         }
         (StringMap.add "printbyte"
         {
           typ = Void;
           fname = "printbyte";
           formals = [ (Byte, "x") ];
           locals = [];
           body = [];
         }
         (StringMap.add "printb"
            {
              typ = Void;
              fname = "printb";
              formals = [ (Bool, "x") ];
              locals = [];
              body = [];
            }
            (StringMap.add "printstrn"
            {
              typ = Void;
              fname = "printstrn";
              formals = [ (String, "x") ];
              locals = [];
              body = [];
            }
            (StringMap.add "printfl"
               {                 
                 typ = Void;
                 fname = "printfl";
                 formals = [ (Float, "x") ];
                 locals = [];
                 body = [];
               }
               (StringMap.singleton "printstr"
                  {
                    typ = Void;
                    fname = "printstr";
                    formals = [ (String, "x") ];
                    locals = [];
                    body = [];
                  }
        )))))))))
     in
     let built_in_decls =
        List.fold_left (fun m f ->
            StringMap.add f 
            {
                typ = Void;
                fname = f;
                formals = [(Matrix(Int, [1]), "x"); (Matrix(Int, [1]), "y"); (Matrix(Int, [1]), "z") ]; 
                locals = [];
                body = [];
            }
            m
        ) built_in_decls ["el_add"; "el_sub"; "el_mul"; "el_div"]
    in
    (*
     let built_in_decls =
        List.fold_left (fun m f ->
            StringMap.add f 
            {
                typ = Void;
                fname = f;
                formals = [(Matrix(Int, [1]), "x"); (Matrix(Int, [1]), "y"); (Matrix(Bool, [true]), "z") ]; 
                locals = [];
                body = [];
            }
            m
        ) built_in_decls ["el_and"; "el_or"; "el_eq"; "el_neq"; "el_less"; "el_leq"; "el_greater"; "el_geq"]
    in
    *)
     let built_in_decls =
        List.fold_left (fun m f ->
            StringMap.add f 
            {
                typ = Void;
                fname = f;
                formals = [(Matrix(Int, [1]), "x"); (Matrix(Int, [1]), "y"); (Matrix(Int, [1]), "z") ]; 
                locals = [];
                body = [];
            }
            m
        ) built_in_decls ["bc_add"; "bc_sub"; "bc_mul"; "bc_div"]
    in
     let function_decls =
       List.fold_left (fun m fd -> StringMap.add fd.fname fd m)
         built_in_decls functions in
     let function_decl s =
       try StringMap.find s function_decls
       with | Not_found -> raise (Failure ("unrecognized function " ^ s)) in
     let _ = function_decl "main" in (* Ensure "main" is defined *)
     let check_function func =
       (List.iter
          (check_not_void
             (fun n -> "illegal void formal " ^ (n ^ (" in " ^ func.fname))))
          func.formals;
        report_duplicate
          (fun n -> "duplicate formal " ^ (n ^ (" in " ^ func.fname)))
          (List.map snd func.formals);
        List.iter
          (check_not_void
             (fun n -> "illegal void local " ^ (n ^ (" in " ^ func.fname))))
          func.locals;
        report_duplicate
          (fun n -> "duplicate local " ^ (n ^ (" in " ^ func.fname)))
          (List.map snd func.locals);
        (* Type of each variable (global, formal, or local *)
        let symbols =
          List.fold_left (fun m (t, n) -> StringMap.add n t m) StringMap.
            empty (globals @ (func.formals @ func.locals)) in
        let type_of_identifier s =
          try StringMap.find s symbols
          with | Not_found -> raise (Failure ("undeclared identifier " ^ s)) in
        let type_of_matrix_identifier s =
          try let sym = StringMap.find s symbols in
            match sym with 
               Matrix (t,_) -> t
               | _  -> raise (Failure ("identifier isn't a matrix " ^ s))
          with | Not_found -> raise (Failure ("undeclared identifier " ^ s)) in
        (* Return the type of an expression or throw an exception *)
        let rec expr =
          function
          | Literal _ -> Int
          | FLiteral _ -> Float
          | SLiteral _ -> String
          | BoolLit _ -> Bool
          | Id s -> type_of_identifier s
          | MatrixAccess (s, _) -> type_of_matrix_identifier s 
          | (MatrixAssign (s,_,e) as ex) -> 
              let lt = type_of_identifier s
              and rt = expr e
              in
                check_assign lt rt
                  (Failure
                     ("illegal assignment " ^
                        ((string_of_typ lt) ^
                           (" = " ^
                              ((string_of_typ rt) ^
                                 (" in " ^ (string_of_expr ex)))))))
         | (Binop (e1, op, e2) as e) ->
              let t1 = expr e1
              and t2 = expr e2
              in
                (match op with
                 | Add | Sub | Mult | Div when (t1 = Int) && (t2 = Int) -> Int
                 | Add | Sub | Mult | Div when (t1 = Float) && (t2 = Float) -> Float
                 | Add | Sub | Mult | Div when (t1 = Byte) && (t2 = Byte) -> Byte
                 | Add | Sub | Mult | Div when (t1 = Byte) && (t2 = Int) -> Byte
                 | Add | Sub | Mult | Div when (t1 = Byte) && (t2 = Float) -> Byte
                 | Add | Sub | Mult | Div when (t1 = Int) && (t2 = Byte) -> Int
                 | Add | Sub | Mult | Div when (t1 = Int) && (t2 = Float) -> Int
                 | Add | Sub | Mult | Div when (t1 = Float) && (t2 = Byte) -> Float
                 | Add | Sub | Mult | Div when (t1 = Float) && (t2 = Int) -> Float
                 | Equal | Neq when t1 = t2 -> Bool
                 | Equal | Neq when (t1 = Int) && (t2 = Byte) -> Bool
                 | Less | Leq | Greater | Geq when (t1 = Int) && (t2 = Int) -> Bool
                 | Less | Leq | Greater | Geq when (t1 = Int) && (t2 = Byte) -> Bool
                 | Less | Leq | Greater | Geq when (t1 = Byte) && (t2 = Int) -> Bool
                 | Less | Leq | Greater | Geq when (is_int_type t1) && (is_int_type t2) -> Bool
                 | And | Or when (t1 = Bool) && (t2 = Bool) -> Bool
                 | _ ->
                     raise
                       (Failure
                          ("illegal binary operator " ^
                             ((string_of_typ t1) ^
                                (" " ^
                                   ((string_of_op op) ^
                                      (" " ^
                                         ((string_of_typ t2) ^
                                            (" in " ^ (string_of_expr e))))))))))
          | (Unop (op, e) as ex) ->
              let t = expr e
              in
                (match op with
                 | Neg when t = Int -> Int
                 | Not when t = Bool -> Bool
                 | _ ->
                     raise
                       (Failure
                          ("illegal unary operator " ^
                             ((string_of_uop op) ^
                                ((string_of_typ t) ^
                                   (" in " ^ (string_of_expr ex)))))))
          | Noexpr -> Void
          | (Assign (var, e) as ex) ->
              let lt = type_of_identifier var
              and rt = expr e
              in
                check_assign lt rt
                  (Failure
                     ("illegal assignment " ^
                        ((string_of_typ lt) ^
                           (" = " ^
                              ((string_of_typ rt) ^
                                 (" in " ^ (string_of_expr ex)))))))
          | (Call (fname, actuals) as call) ->
              let fd = function_decl fname
              in
                (if ( != ) (List.length actuals) (List.length fd.formals)
                 then
                   raise
                     (Failure
                        ("expecting " ^
                           ((string_of_int (List.length fd.formals)) ^
                              (" arguments in " ^ (string_of_expr call)))))
                 else
                     if (fname = "dim") then
                         let e = List.hd actuals in
                         match (e) with
                         | Id(m) -> (match (type_of_identifier m) with 
                             | Matrix(_,_) -> ()
                             | _ -> raise (Failure ("illegal argument to dim() found  expected Matrix in " ^ (string_of_expr e))))
                         | _ -> raise (Failure ("illegal argument to dim() found  expected Matrix in " ^ (string_of_expr e)))
       	     else if (fname = "el_add" || fname = "el_sub" || fname = "el_mul" || fname = "el_div") then
                let e = List.hd actuals in
                (match(e) with
                    | Id(m) -> (match (type_of_identifier m) with
                        | Matrix(_, _) ->
                            let comp_matrix e1 e2 =
                            (match(e1, e2) with
                                | Id(m1), Id(m2) -> (match (type_of_identifier m1, type_of_identifier m2) with
                                    | Matrix(t1, l1), Matrix(t2, l2) -> 
                                        let rec compareVs v1 v2 = match v1, v2 with
                                            | [], [] -> true
                                            | [], _
                                            | _, [] -> false
                                            | x::xs, y::ys -> x=y && compareVs xs ys
                                        in
                                        if (t1 != t2) then
                                            raise(Failure ("incompatibles types of matrices to " ^ fname))
                                        else if not (compareVs l1 l2) then
                                            raise(Failure ("incompatibles dimensions of matrices to " ^ fname))
                                        else
                                            e2
                                    | _, _ -> raise (Failure ("illegal argument to " ^ fname ^ " found expected Matrix in " ^ (string_of_expr e))))
                                | _, _ -> raise (Failure ("illegal argument to " ^ fname ^ " found  expected Matrix in " ^ (string_of_expr e))))
                                 (* checking to see if two matrices have same type and shape *)
                            in
                            ignore(List.fold_left comp_matrix e (List.tl actuals)); ()
                        | _ -> raise (Failure ("illegal argument to " ^ fname ^ " found  expected Matrix in " ^ (string_of_expr e))))
                    | _ -> raise(Failure ("illegal argument to " ^ fname ^ " found expected Matrix in "^ (string_of_expr e))) 
                )
       	     else if (fname = "bc_add" || fname = "bc_sub" || fname = "bc_mul" || fname = "bc_div") then
                let e = List.hd actuals in
                (match(e) with
                    | Id(m) -> (match (type_of_identifier m) with
                        | Matrix(_, [1]) ->
                            let comp_matrix e1 e2 =
                            (match(e1, e2) with
                                | Id(m1), Id(m2) -> (match (type_of_identifier m1, type_of_identifier m2) with
                                    | Matrix(t1, l1), Matrix(t2, l2) -> 
                                        let rec compareVs v1 v2 = match v1, v2 with
                                            | [], [] -> true
                                            | [], _
                                            | _, [] -> false
                                            | x::xs, y::ys -> x=y && compareVs xs ys
                                        in
                                        if (t1 != t2) then
                                            raise(Failure ("incompatibles types of matrices to " ^ fname))
                                        else if not (compareVs l1 l2) then
                                            raise(Failure ("incompatibles dimensions of matrices to " ^ fname))
                                        else
                                            e2
                                    | _, _ -> raise (Failure ("illegal argument to " ^ fname ^ " found expected Matrix in " ^ (string_of_expr e))))
                                | _, _ -> raise (Failure ("illegal argument to " ^ fname ^ " found expected Matrix in " ^ (string_of_expr e))))
                                 (* checking to see if two matrices have same type and shape *)
                            in
                            ignore(List.fold_left comp_matrix (List.hd (List.tl actuals)) (List.tl actuals)); ()
                        | _ -> raise (Failure ("illegal argument to " ^ fname ^ " found expected Matrix in " ^ (string_of_expr e))))
                    | _ -> raise(Failure ("illegal argument to " ^ fname ^ " found expected Matrix in "^ (string_of_expr e))) 
                )
            else

                  List.iter2
                    (fun (ft, _) e ->
                       let et = expr e
                       in
                         ignore
                           (check_assign ft et
                              (Failure
                                 ("illegal actual argument found " ^
                                    ((string_of_typ et) ^
                                       (" expected " ^
                                          ((string_of_typ ft) ^
                                             (" in " ^ (string_of_expr e)))))))))
                    fd.formals actuals;
                fd.typ) in
        let check_bool_expr e =
          if ( != ) (expr e) Bool
          then
            raise
              (Failure
                 ("expected Boolean expression in " ^ (string_of_expr e)))
          else () in
        (* Verify a statement or throw an exception *)
        let rec stmt =
          function
          | Block sl ->
              let rec check_block =
                (function
                 | [ (Return _ as s) ] -> stmt s
                 | Return _ :: _ ->
                     raise (Failure "nothing may follow a return")
                 | Block sl :: ss -> check_block (sl @ ss)
                 | s :: ss -> (stmt s; check_block ss)
                 | [] -> ())
              in check_block sl
          | Expr e -> ignore (expr e)
          | Return e ->
              let t = expr e
              in
                if t = func.typ
                then ()
                else
                  raise
                    (Failure
                       ("return gives " ^
                          ((string_of_typ t) ^
                             (" expected " ^
                                ((string_of_typ func.typ) ^
                                   (" in " ^ (string_of_expr e)))))))
          | If (p, b1, b2) -> (check_bool_expr p; stmt b1; stmt b2)
          | Elif (exprs, stmts) -> 
              (List.iter check_bool_expr exprs;
               List.iter stmt stmts) 
          | For (e1, e2, e3, st) ->
              (ignore (expr e1);
               check_bool_expr e2;
               ignore (expr e3);
               stmt st)
          | While (p, s) -> (check_bool_expr p; stmt s)
        in stmt (Block func.body))
     in List.iter check_function functions)
  

