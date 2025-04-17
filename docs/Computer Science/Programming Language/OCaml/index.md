# OCaml && Functional Programming

!!! Info 

    一直想学一门函数式编程语言，打算将这个部分写成备忘录的样子，对于一些不太好理解的东西或许会更加详细地记录一下。

OCaml 程序不需要有一个名为 `main` 的特殊函数来启动程序。通常的做法就是让文件中的最后一个定义作为启动计算的主函数。

```ocaml
let rec fact n = if n = 0 then 1 else n * fact (n - 1)

let rec pow (n : int) (m: int ) : int = if m = 1 then n else n * pow n (m - 1)
```

```ocaml
(** [even n] is whether [n] is even.
    Requires: [n >= 0]. *)
let rec even n = n = 0 || odd (n - 1)

(** [odd n] is whether [n] is odd.
    Requires: [n >= 0]. *)
and odd n = n <> 0 && even (n - 1)
```

```ocaml
let inc x = x + 1
let inc = fun x -> x + 1
```

这两种写法语法层面不同但是语义层面相等。来一个更惊人的例子：

```ocaml
let x = e1 in e2
(fun x -> e2) e1
```

这两种情况语法层面不同但是语义等价，简要说来，`let` 表达式其实就是调用匿名函数的语法糖。

> In essence, `let` expressions are just syntactic sugar for anonymous function application.

假设 `inc` 定义如上不变，再定义一个 `#!ocaml let square x = x * x`：

```ocaml
let x = square (inc 1)
let x = 5 |> inc |> square
```

但是管道运算符每侧都只能有一个参数。

There is a built-in infix operator in OCaml for function application called the pipeline operator, written |>. Imagine that as depicting a triangle pointing to the right. The metaphor is that values are sent through the pipeline from left to right. For example, suppose we have the increment function inc from above as well as a function square that squares its input:

```ocaml
let id x = x
- : val id : 'a -> 'a = <fun>

let id_int (x: int) : int = x
let id_int' : int -> int = id
```

对于多态函数，编译器会做类似于这样的处理：

```ocaml
let inc' : 'a -> 'a = fun x -> x + 1
- : val inc' : int -> int = <fun>
```

因为传递一个 bool 或 string 或一些复杂的数据结构给它是不安全的，而 `+` 可以安全操作的唯一数据是整数。因此，OCaml 将类型变量 `'a` 实例化为 `int`，从而防止我们将 `id'` 应用于非整数。

```ocaml
let func ~name1: a ~name2: b = a + b
let func ~name1:(arg1: int) ~name2:(arg2: int) = arg1 + arg2
func ~name2: 22 ~name1: 11
let func_default ?name1:(arg1 = 1) ?name2:(arg2 = 2) = arg1 + arg2
```

对于代标签的参数和可选参数，对于这样的情况分别会报 warning 和报错：

- 完全不带标签调用会报 warning：`func 1 2`

如果参数的标签和变量名相同，那么可以简写为：

```ocaml
let func ~a ~b = a + b
func ~a: 11 ~b: 22
```

部分调用：

```ocaml
let add x y = x + y
let add x = fun y -> x + y
let add = fun x -> (fun y -> x + y)
```

这三种写法还是语法层面不同，但是语义层面等价。

```ocaml
let ( ^^ ) arg1 arg2 = max arg1 arg2
```

```ocaml
[] (* called nil, a' list *)
[1; 2; 3]
1 :: 2 :: 3 :: []
```

```ocaml
let rec append lst1 lst2 =
    match lst1 with
    | [] -> lst2
    | h :: t -> h :: append t lst2
```

模式匹配语法：

```ocaml
match expr with
| pattern1 -> result1
| pattern2 -> result2
| ...
| patternN -> resultN
```

同一个变量名不能在模式中出现多次。例如，模式 `x :: x` 是非法的。通配符可以出现任意次数。

???- Info "Pattern in Documentation"

    ```ocaml
    pattern	::=	value-name
            ∣	 _
            ∣	 constant
            ∣	 pattern as value-name
            ∣	 ( pattern )
            ∣	 ( pattern : typexpr )
            ∣	 pattern | pattern
            ∣	 constr pattern
            ∣	 `tag-name pattern
            ∣	 #typeconstr
            ∣	 pattern { , pattern }+
            ∣	 { field [: typexpr] [= pattern]{ ; field [: typexpr] [= pattern] } [; _ ] [ ; ] }
            ∣	 [ pattern { ; pattern } [ ; ] ]
            ∣	 pattern :: pattern
            ∣	 [| pattern { ; pattern } [ ; ] |]
            ∣	 char-literal .. char-literal
            ∣	 lazy pattern
            ∣	 exception pattern
            ∣	 module-path .( pattern )
            ∣	 module-path .[ pattern ]
            ∣	 module-path .[| pattern |]
            ∣	 module-path .{ pattern }
    ```

列表是不可变的，没有办法将列表的元素从一个值更改为另一个值。如果需要修改（真的是修改吗）列表，就需要从旧列表中创建新列表。

```ocaml
let rec inc_first lst = 
    match lst with
    | [] -> []
    | h :: t -> (h + 1) :: t
```

OCaml 中，列表的元素类型必须相同。





