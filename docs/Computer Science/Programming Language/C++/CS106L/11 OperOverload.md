# Lecture 11 运算符重载

```cpp
class __lambda_6_18 {
   public:
    bool operator()(int x) const { return x < n; }
    __lambda_6_18(int &n) : n{_n} {}
   private: 
    int n;
};

int n = 10;
auto lessThanN = __lambda_6_18(n);
find_if(begin, end, lessThanN);
```

我有问题🤓：我重载了运算符 `#!cpp operator()`，对使用 `()` 的构造函数有没有影响？

当然是没有：构造函数和 `operator()` 是完全独立的函数。重载 `operator()` 不会影响构造函数的使用。圆括号语法在两种情况下有不同的含义：

- 对类名使用时表示构造函数调用；
- 对对象使用时表示 `operator()` 调用。

```cpp
class Calculator {
   public:
    Calculator(int base) : base_(base) { std::cout << "Calculator constructed\n"; }
    int operator()(int x) const { return base_ + x; }

   private:
    int base_;
};

Calculator calc(10);  // 正常工作
int result = calc(5); // 调用 operator()，返回 15
```
