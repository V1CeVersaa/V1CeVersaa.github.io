# Lecture 9：模版函数

## 1. 简单的例子

函数模版是一种泛型函数/Generic Function。

```cpp
template <typename T>
T min (const T &a, const T &b) {
    return a < b ? a : b;
}

template <typename T, typename U>
auto min(const T &a, const U &b) {
    return a < b ? a : b;
}
```

实例化方法对应有两种：可以直接指定类型，也可以让编译器自行推断，但是推断的结果不一定如使用者本意（比如会把字符串字面量推断成 `const char*`）：

```cpp
min<int>(3, 4);                     // 显式实例化：编译器帮我们生成对应代码
min(3.14, 2.71);                    // 隐式实例化：编译器自行推断数据类型
min("hello", "world");              // 隐式实例化：编译器自行推断数据类型
min<const char*>("hello", "world"); // 显式实例化：上一行对应的其实是这个
```

还可以写更复杂的模版：

```cpp
template <class InputIt, class T>
InputIt find(InputIt first, InputIt last, const T &value);
```

## 2. Concepts

想法：要求模版函数的类型参数需要有某种特定的属性，比如 `min` 需要类型参数支持 `<` 运算符，`find` 需要类型参数 `InputIt` 是一个迭代器。

```cpp
template <typename T>
concept Comparable = requires(const T &a, const T &b) {
    { a < b } -> std::convertible_to<bool>;
};
```

其中：

- `#!cpp concept`：代表限制的一个有名集合（a named set of constraints）；
- `#!cpp requires(const T &a, const T &b)`：指定类型 `T` 必须满足的条件，这里我们要求类型 `T` 必须能够接受两个常量引用参数，并且满足下面条件；
- `#!cpp { a < b } -> std::convertible_to<bool>`：这里我们要求花括号 `{}` 内的 `a < b` 必须不存在编译错误，并且返回值必须可以转换为 `bool` 类型。注意到 `std::convertible_to` 也是一个 concept。

使用 concept，我们可以修改我们的代码，下面两种写法都是对的：

```cpp
template <typename T> requires Comparable<T>
T min(const T &a, const T &b);

template <Comparable T>
T min(const T &a, const T &b);

template <std::input_iterator InputIt, class T>
InputIt find(InputIt first, InputIt last, const T &value);
```

## 3. 变参模版

想法：我们希望创建可以接受任意数量参数的模版函数，但是函数重载的实现太过笨拙，考虑用递归的形式简化实现。

```cpp
template <Comparable T>
T min(const T &v) { return v; }

template <Comparable T, Comparable... Args>
T min(const T &v, const Args &...args) {
    auto m = min(args...);
    return v < m ? v : m;
}
```

注意：

- 只有一个参数的版本是 Base Case Function；
- `Args` 是一个参数包，对应着 0 个或者更多种类型，`args` 是实际的参数值；
- 在 `#!cpp auto m = min(args...);` 这一行执行了包展开，将 `args...` 展开成了真正的参数。

在 `#!cpp min<int, int, int, int>(2, 7, 5, 1)` 的最初调用中：`#!cpp T = int`，`#!cpp Args = [int, int, int]`。

编译器通过递归生成任意数量的重载，这使得我们可以支持任意数量的函数参数；实例化发生在编译时。

## 4. 模版元编程

我们可以利用函数模板的特性来进行一些编译期的计算，这被称为模板元编程/Templates Metaprogramming。

```cpp
template <>
struct Factorial<0> {
    enum { value = 1 };     // enum: One way to store a compile-time constant
};

template <std::size_t N>
struct Factorial {
    enum { value = N * Factorial<N - 1>::value };
};

std::cout << Factorial<5>::value << std::endl;  // 120
```

TMP 是图灵完备的，我们可以在编译期执行任何代码（但是写出来一般很丑）。`constexpr` 和 `consteval` 为我们提供了 TMP 的一个替代品：

```cpp
constexpr std::size_t factorial(std::size_t n) {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}

consteval std::size_t factorial(std::size_t n) {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}
```

- `#!cpp constexpr`：允许编译时求值，但是如果条件不满足，可以退化为普通函数；
    - 要求：参数和返回值必须是字面值类型，不能有副作用，只能调用 `constexpr` 函数。
    - 性质：对应函数是纯函数，返回值隐含 `const` 属性。
- `#!cpp consteval`：强制编译时求值，如果不能在编译时求值，则编译失败。
    - 要求：不能有静态变量，不能有副作用，不能在运行时上下文中调用。
