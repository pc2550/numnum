(* Code generation: translate takes a semantically checked AST and
produces LLVM IR

LLVM tutorial: Make sure to read the OCaml version of the tutorial

http://llvm.org/docs/tutorial/index.html

Detailed documentation on the OCaml LLVM library:

http://llvm.moe/
http://llvm.moe/ocaml/

*)
module L = Llvm
  
module A = Ast
  
module StringMap = Map.Make(String)


let translate (globals, functions) =
  let context = L.global_context () in

  let the_module = L.create_module context "NumNum"
  and i32_t = L.i32_type context 
  and i8_t = L.i8_type context
  and i1_t = L.i1_type context 
  and void_t = L.void_type context
  and float_t = L.double_type context
  and string_t = L.pointer_type (L.i8_type context)
  and array_t t dims = L.array_type t (List.fold_left (fun acc el -> acc*el) 1 dims) in
  let rec ltype_of_typ =
    function
    | A.Int -> i32_t
    | A.Bool -> i1_t
    | A.Void -> void_t
    | A.String -> string_t
    | A.Float -> float_t
    | A.Byte -> i8_t
    | A.Matrix (t, dims) -> array_t (ltype_of_typ t) dims in 
  (* Declare each global variable; remember its value in a map *)
  let global_vars =
    let errno = (L.define_global "errno" (L.const_int i32_t 0) the_module,A.Int) in
    let () = L.set_linkage L.Linkage.Available_externally (fst errno) in
    let global_var m (t, n) =
      let init = L.const_int (ltype_of_typ t) 0
      in StringMap.add n ((L.define_global n init the_module),t) m
    in List.fold_left global_var (StringMap.singleton "errno" errno) globals in

  (* Declare printf(), which the print built-in function will call *)
  let printf_t = L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func = L.declare_function "printf" printf_t the_module in
  let open_t = L.var_arg_function_type i32_t [| L.pointer_type i8_t;i32_t |] in
  let open_func = L.declare_function "open" open_t the_module in
  let read_t = L.var_arg_function_type i32_t [| i32_t; L.pointer_type i32_t; i32_t |] in
  let read_func = L.declare_function "read" read_t the_module in
  let readbyte_t = L.var_arg_function_type i32_t [| i32_t; L.pointer_type i8_t; i32_t |] in
  let readbyte_func = L.declare_function "read" readbyte_t the_module in
  let creat_t = L.var_arg_function_type i32_t [| L.pointer_type i8_t;i32_t |] in
  let creat_func = L.declare_function "creat" creat_t the_module in
  let write_t = L.var_arg_function_type i32_t [| i32_t; L.pointer_type i8_t; i32_t |] in
  let write_func = L.declare_function "write" write_t the_module in
  let close_t = L.var_arg_function_type i32_t [| i32_t |] in
  let close_func = L.declare_function "close" close_t the_module in
  (* Define each function (arguments and return type) so we can call it *)
  let function_decls =
    let function_decl m fdecl =
      let name = fdecl.A.fname
      and formal_types =
        Array.of_list
          (List.map (fun (t, _) -> ltype_of_typ t) fdecl.A.formals) in
      let ftype = L.function_type (ltype_of_typ fdecl.A.typ) formal_types
      in
        StringMap.add name ((L.define_function name ftype the_module), fdecl)
          m
    in List.fold_left function_decl StringMap.empty functions in
  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.A.fname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in
    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in
    let byte_format_str = L.build_global_stringptr "%x\n" "fmt" builder in
    let float_format_str = L.build_global_stringptr "%f\n" "fmt" builder in
    let string_format_str = L.build_global_stringptr "%s\n" "fmt" builder in
    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p =
        (L.set_value_name n p;
         let local = L.build_alloca (ltype_of_typ t) n builder
         in (ignore (L.build_store p local builder); StringMap.add n (local,t) m)) in
      let add_local m (t, n) =
        let local_var = L.build_alloca (ltype_of_typ t) n builder
        in StringMap.add n (local_var,t) m in
      let formals =
        List.fold_left2 add_formal StringMap.empty fdecl.A.formals
          (Array.to_list (L.params the_function))
      in List.fold_left add_local formals fdecl.A.locals in
    (* Return the value for a variable or formal argument *)
    let lookup n =
      try match (StringMap.find n local_vars) with (lt,_) -> lt
      with | Not_found ->  match (StringMap.find n global_vars) with (lt,_) -> lt in
    (* Look up the dimensions for a matrix *)
    let lookup_dims n =
      let get_dims t = match t with 
          A.Matrix (_,dims) -> dims
        | _ -> [] in
      try match (StringMap.find n local_vars) with (_,t) -> get_dims t
      with | Not_found ->  match (StringMap.find n global_vars) with (_,t) -> get_dims t in
    let lookup_type n =
      let get_type t = match t with 
          A.Matrix (typ,_) -> typ
        | _ -> t in
      try match (StringMap.find n local_vars) with (_,typ) -> get_type typ
      with | Not_found ->  match (StringMap.find n global_vars) with (_,typ) -> get_type typ in
    let integer_conv_op lh rh builder =
        let rht =  (L.type_of rh) in
        let lht=  (L.type_of lh) in
        ( match lht with
            | _ when lht == i8_t ->  (
              match  rht with
                | _ when rht == i32_t -> (L.build_intcast rh i8_t "conv" builder)
                | _ when rht == float_t ->  (L.build_uitofp rh i8_t "conv" builder)
                | _ -> rh )
            | _ when lht == i32_t -> (
              match  rht with
                | _ when rht == i8_t -> (L.build_intcast rh i32_t "conv" builder)
                | _ when rht == float_t ->  (L.build_fptosi rh i32_t "conv" builder)
                | _ -> rh )
            | _ when lht == float_t ->  (
              match  rht with
                | _ when rht == float_t -> rh
                | _ ->  ( L.build_sitofp rh float_t "conv" builder) )
            | _ -> rh  ) in 
    let integer_conversion lh rh builder = 
        let rht = (L.type_of rh) in
        let rhw =  (L.integer_bitwidth rht) in
          (match lh with
            | A.Byte -> (match rht with
                | _ when rht == i8_t -> rh
                | _ when rht == float_t  -> (L.build_fptosi rh i8_t "conv" builder)
                | _ -> ( L.build_intcast rh i8_t "conv" builder) ) 
            | A.Int -> (match rht with
                | _ when rht == i32_t -> rh
                | _ when rht == float_t -> (L.build_fptosi rh i32_t "conv" builder)
                | _  -> ( L.build_intcast rh i32_t "conv" builder) )
            | A.Float -> (match rht with
                | _ when rht == float_t -> rh
                | _ when rht == i8_t -> ( L.build_uitofp rh float_t "conv" builder)
                | _ -> ( L.build_sitofp rh float_t "conv" builder) )
            | _ -> rh) in
    (* Construct code for an expression; return its value *)
    let rec expr builder = 
      function
      | A.Literal i -> L.const_int i32_t i
      | A.FLiteral i -> L.const_float float_t i
      | A.SLiteral l -> L.build_global_stringptr l "tmp" builder
      | A.BoolLit b -> L.const_int i1_t (if b then 1 else 0)
      | A.Noexpr -> L.const_int i32_t 0
      | A.Id s -> L.build_load (lookup s) s builder
      | A.MatrixAccess ( s, params) -> 
          let dims = lookup_dims s in
          let acc_params = List.map (fun el -> (expr builder el)) params in
          let get_pos = List.fold_right2 
                          (fun p d acc -> (L.build_add p (L.build_mul (L.const_int i32_t d) acc "tmp" builder) "tmp" builder)) 
                          acc_params 
                          dims 
                          (L.const_int i32_t 0) in
          L.build_load (L.build_gep (lookup s) [|L.const_int i32_t 0;get_pos|] "tmp" builder) "tmp" builder
      | A.Binop (e1, op, e2) ->
          let e1' = expr builder e1 in
          let e2' = expr builder e2 in (*(print_int (L.integer_bitwidth (L.type_of e1')));*)
          let e2f = (integer_conv_op e1' e2' builder) (*match  L.integer_bitwidth (L.type_of e1') with 
            | 32 -> (
              match  L.integer_bitwidth (L.type_of e2') with
                | 8 -> L.const_trunc e1' i8_t
                | _ -> e1') 
            | _ -> e1' *)in
          let etype = L.classify_type (L.type_of (expr builder e1))
          in
            (match etype with
             | L.TypeKind.Double ->
                 (match op with
                  | A.Add -> L.build_fadd
                  | A.Sub -> L.build_fsub
                  | A.Mult -> L.build_fmul
                  | A.Div -> L.build_fdiv
                  | A.And -> L.build_and
                  | A.Or -> L.build_or
                  | A.Equal -> L.build_fcmp L.Fcmp.Oeq
                  | A.Neq -> L.build_fcmp L.Fcmp.One
                  | A.Less -> L.build_fcmp L.Fcmp.Olt
                  | A.Leq -> L.build_fcmp L.Fcmp.Ole
                  | A.Greater -> L.build_fcmp L.Fcmp.Ogt
                  | A.Geq -> L.build_fcmp L.Fcmp.Oge) e1' e2f "tmp" builder
             | _ ->
                 (match op with
                  | A.Add -> L.build_add
                  | A.Sub -> L.build_sub
                  | A.Mult -> L.build_mul
                  | A.Div -> L.build_sdiv
                  | A.And -> L.build_and
                  | A.Or -> L.build_or
                  | A.Equal -> L.build_icmp L.Icmp.Eq
                  | A.Neq -> L.build_icmp L.Icmp.Ne
                  | A.Less -> L.build_icmp L.Icmp.Slt
                  | A.Leq -> L.build_icmp L.Icmp.Sle
                  | A.Greater -> L.build_icmp L.Icmp.Sgt
                  | A.Geq -> L.build_icmp L.Icmp.Sge) e1' e2f "tmp" builder)
      | A.Unop (op, e) ->
          let e' = expr builder e
          in
            (match op with | A.Neg -> L.build_neg | A.Not -> L.build_not) e'
              "tmp" builder
      | A.Assign (s, e) ->
          let e' = expr builder e in
          let s' = (lookup s) in
          let ef = (integer_conversion (lookup_type s) e' builder) in
            (ignore (L.build_store ef s' builder)); ef
      | A.MatrixAssign (s,dims_assign,e) -> 
          let e' = expr builder e in 
          let s' = (lookup s) in 
          let ef = (integer_conversion (lookup_type s) e' builder) in
          let dims = lookup_dims s in
          let acc_params = List.map (fun el -> (expr builder el)) dims_assign in
          let get_pos = List.fold_right2 
                          (fun p d acc -> (L.build_add p (L.build_mul (L.const_int i32_t d) acc "tmp" builder) "tmp" builder)) 
                          acc_params 
                          dims 
                          (L.const_int i32_t 0) in
          L.build_store  ef (L.build_gep s' [|L.const_int i32_t 0;get_pos|] "tmp" builder) builder
      | A.Call ("print", ([ e ])) | A.Call ("printb", ([ e ])) ->
          L.build_call printf_func [| int_format_str; expr builder e |]
            "printf" builder
      | A.Call ("printfl", ([ e ])) ->
          L.build_call printf_func [| float_format_str; expr builder e |]
            "printf" builder
      | A.Call ("printstr", ([ e ])) ->
          L.build_call printf_func [| string_format_str; expr builder e |]
            "printf" builder
      | A.Call ("printbyte", ([ e ])) ->
          L.build_call printf_func [| byte_format_str; expr builder e |]
            "printf" builder
      | A.Call ("dim", ([ e ])) ->
              ( match e with 
                | A.Id(t) -> 
                  let d = L.build_alloca  i32_t "tmp" builder in
                  (ignore (L.build_store (L.const_int i32_t (List.length (lookup_dims t))) d  builder);
                  L.build_load d "tmp" builder)
                | _ -> expr builder e)
      | A.Call (el_op, ([a; b; c])) ->
            ( match a, b, c with
                | A.Id(x), A.Id(y), A.Id(z) ->

                    (* Get a list of params lists *)
                    let dims = lookup_dims x in
                    let rec range i j = if i >= j then [] else A.Literal(i) :: (range (i+1) j) in
                    let dim2 = range 0 1 in
                    let dim1 = range 0 1 in
                    let tmp1 = List.concat (List.map (fun x -> List.map (fun y -> y::[x]) dim2) dim1) in
                    let tmp2 = List.fold_left (fun tmp dim -> (List.concat (List.map (fun x -> List.map (fun y -> y::x) (range 0 dim)) tmp))) tmp1 dims in
                    let all_pos = List.map List.rev (List.map List.rev (List.map List.tl (List.map List.tl (List.map List.rev tmp2)))) in

                    (* Do multiplication at each of the positions *)
                    let do_op = fun builder params ->
                        let e1 = A.MatrixAccess(x, params) in
                        let e2 = A.MatrixAccess(y, params) in
                        let e1' = expr builder e1 in
                        let e2' = expr builder e2 in
                        let etype = L.classify_type (L.type_of e1') in
                        let r = (match etype with
                            | L.TypeKind.Double ->
                                (match el_op with
                                    | "el_add" -> L.build_fadd
                                    | "el_sub" -> L.build_fsub
                                    | "el_mul" -> L.build_fmul
                                    | "el_div" -> L.build_fdiv
                                    (*
                                    | "el_and" -> L.build_and
                                    | "el_or" -> L.build_or
                                    | "el_eq" -> L.build_fcmp L.Fcmp.Oeq
                                    | "el_neq" -> L.build_fcmp L.Fcmp.One
                                    | "el_less" -> L.build_fcmp L.Fcmp.Olt
                                    | "el_leq" -> L.build_fcmp L.Fcmp.Ole
                                    | "el_greater" -> L.build_fcmp L.Fcmp.Ogt
                                    | "el_geq" -> L.build_fcmp L.Fcmp.Oge
                                    *)
                                    | _ -> raise (Failure ("Unable to do element-wise operation " ^ el_op ^ " on matrices"))
                                )
                            | _ ->
                                (match el_op with
                                    | "el_add" -> L.build_add
                                    | "el_sub" -> L.build_sub
                                    | "el_mul" -> L.build_mul
                                    | "el_div" -> L.build_sdiv
                                    (*
                                    | "el_and" -> L.build_and
                                    | "el_or" -> L.build_or
                                    | "el_eq" -> L.build_icmp L.Icmp.Eq
                                    | "el_neq" -> L.build_icmp L.Icmp.Ne
                                    | "el_less" -> L.build_icmp L.Icmp.Slt
                                    | "el_leq" -> L.build_icmp L.Icmp.Sle
                                    | "el_greater" -> L.build_icmp L.Icmp.Sgt
                                    | "el_geq" -> L.build_icmp L.Icmp.Sge
                                    *)
                                    | _ -> raise (Failure ("Unable to do element-wise operation " ^ el_op ^ " on matrices"))
                                )
                            ) e1' e2' "tmp" builder
                        in
                        let z' = (lookup z) in 
                        let ef = (integer_conversion (lookup_type z) r builder) in
                        let dims = lookup_dims z in
                        let acc_params = List.map (fun el -> (expr builder el)) params in
                        let get_pos = List.fold_right2 
                                          (fun p d acc -> (L.build_add p (L.build_mul (L.const_int i32_t d) acc "tmp" builder) "tmp" builder)) 
                                          acc_params 
                                          dims 
                                          (L.const_int i32_t 0) in
                        ignore(L.build_store ef (L.build_gep z' [|L.const_int i32_t 0;get_pos|] "tmp" builder) builder); builder
                    in
                    ignore(List.fold_left do_op builder all_pos); L.const_int i32_t 0
                           
                | _, _, _ -> raise (Failure ("Unable to do element-wise operation " ^ el_op ^ " on matrices")))
      | A.Call ("open", ([ e ; e2 ])) ->
              (L.build_call open_func [| expr builder e;expr builder e2|] "open" builder)
      | A.Call ("read", ([ e ; e2 ])) ->
                let ev = expr builder e and
                 ev2 = A.string_of_expr e2 in
                let arrptr = (lookup ev2) in
                let arrtype = (lookup_type ev2) in
                let arrsize = (List.fold_left (fun acc el -> acc*el) 1 (lookup_dims ev2))  in 
                let fd = (L.build_call open_func [| ev ; L.const_int i32_t 0|] "open" builder) in
                let ret = (match arrtype with
                          A.Byte -> (L.build_call readbyte_func 
                                              [| fd ;
                                                (L.build_gep arrptr [|L.const_int i32_t 0;L.const_int i32_t 0|] "tmp" builder);
                                                 L.const_int i32_t (arrsize)|] "read" builder) 
                          | A.Int -> (L.build_call read_func 
                                              [| fd ;
                                                (L.build_gep arrptr [|L.const_int i32_t 0;L.const_int i32_t 0|] "tmp" builder);
                                                 L.const_int i32_t (arrsize*4)|] "read" builder) 
                          | _ -> raise (Failure ("Unable to read into matrix type " ^ (A.string_of_typ arrtype)))                       
                ) in
                (ignore (L.build_call close_func [| fd |] "close" builder));ret
      | A.Call ("write", ([e; e2])) ->
                let path = expr builder e and
                var_name =  A.string_of_expr e2 in
                let arrptr = (lookup var_name) in
                let arrsize = (List.fold_left (fun acc el -> acc*el) 1 (lookup_dims var_name)) in
                let fd = (L.build_call creat_func [| path ; L.const_int i32_t 438|] "creat" builder) in
                let ret = L.build_call write_func 
                                              [| fd ;
                                                (L.build_gep arrptr [|L.const_int i32_t 0;L.const_int i32_t 0|] "tmp" builder);
                                                 L.const_int i32_t (arrsize)|] "write" builder 
                in
                (ignore (L.build_call close_func [| fd |] "close" builder));ret
      | A.Call (f, act) ->
          let (fdef, fdecl) = StringMap.find f function_decls in
          let actuals = List.rev (List.map (expr builder) (List.rev act)) in
          let result =
            (match fdecl.A.typ with | A.Void -> "" | _ -> f ^ "_result")
          in L.build_call fdef (Array.of_list actuals) result builder in
    (* Invoke "f builder" if the current block doesn't already
       have a terminal (e.g., a branch). *)
    let add_terminal builder f =
      match L.block_terminator (L.insertion_block builder) with
      | Some _ -> ()
      | None -> ignore (f builder) in
    (* Build the code for the given statement; return the builder for
       the statement's successor *)
    let rec stmt builder =
      function
      | A.Block sl -> List.fold_left stmt builder sl
      | A.Expr e -> (ignore (expr builder e); builder)
      | A.Return e ->
          (ignore
             (match fdecl.A.typ with
              | A.Void -> L.build_ret_void builder
              | _ -> L.build_ret (expr builder e) builder);
           builder)
      | A.If (predicate, then_stmt, else_stmt) ->
          let bool_val = expr builder predicate in
          let merge_bb = L.append_block context "merge" the_function in
          let then_bb = L.append_block context "then" the_function
          in
            (add_terminal (stmt (L.builder_at_end context then_bb) then_stmt)
               (L.build_br merge_bb);
             let else_bb = L.append_block context "else" the_function
             in
               (add_terminal
                  (stmt (L.builder_at_end context else_bb) else_stmt)
                  (L.build_br merge_bb);
                ignore (L.build_cond_br bool_val then_bb else_bb builder);
                L.builder_at_end context merge_bb))
      | A.Elif (exprs, stmts) ->
            (match exprs with 
                [] -> 
                    (match stmts with
                        [] -> builder
                        | h::t ->     
                            stmt builder (A.Block [ A.Block [(h)]])
                    )
                | _ ->
                    let bool_val = expr builder (List.hd exprs) in
                    let merge_bb = L.append_block context "merge" the_function in
                    let then_bb = L.append_block context "then" the_function
                    in
                    (add_terminal (stmt (L.builder_at_end context then_bb) (List.hd stmts))
                        (L.build_br merge_bb);
                        let else_bb = L.append_block context "else" the_function
                        in
                        (add_terminal
                            (stmt (L.builder_at_end context else_bb) (A.Elif (List.tl exprs, List.tl stmts)))
                            (L.build_br merge_bb);
                        ignore (L.build_cond_br bool_val then_bb else_bb builder);
                        L.builder_at_end context merge_bb))
            )
      | A.While (predicate, body) ->
          let pred_bb = L.append_block context "while" the_function
          in
            (ignore (L.build_br pred_bb builder);
             let body_bb = L.append_block context "while_body" the_function
             in
               (add_terminal (stmt (L.builder_at_end context body_bb) body)
                  (L.build_br pred_bb);
                let pred_builder = L.builder_at_end context pred_bb in
                let bool_val = expr pred_builder predicate in
                let merge_bb = L.append_block context "merge" the_function
                in
                  (ignore
                     (L.build_cond_br bool_val body_bb merge_bb pred_builder);
                   L.builder_at_end context merge_bb)))
      | A.For (e1, e2, e3, body) ->
          stmt builder
            (A.Block
               [ A.Expr e1; A.While (e2, (A.Block [ body; A.Expr e3 ])) ]) in
    (* Build the code for each statement in the function *)
    let builder = stmt builder (A.Block fdecl.A.body)
    in
      (* Add a return if the last block falls off the end *)
      add_terminal builder
        (match fdecl.A.typ with
         | A.Void -> L.build_ret_void
         | t -> L.build_ret (L.const_int (ltype_of_typ t) 0))
  in (List.iter build_function_body functions; the_module)
  

