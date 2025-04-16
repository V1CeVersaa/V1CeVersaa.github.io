# OCaml && Functional Programming

!!! Info 

    一直想学一门函数式编程语言，等我暑假捋完 Rust 的基本内容之后再来。也打算写成文档的样子，也符合函数式编程的简洁优雅。现在这里就是随便记一点点。

OCaml 程序不需要有一个名为 `main` 的特殊函数来启动程序。通常的做法就是让文件中的最后一个定义作为启动计算的主函数。

```ml
let rec fact n = if n = 0 then 1 else n * fact (n - 1)

let rec pow (n : int) (m: int ) : int = if m = 1 then n else n * pow n (m - 1)
```



