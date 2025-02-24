# Lecture 10：函数与 Lambda 表达式

## 1. 谓词函数

!!! Info "谓词函数"
    谓词函数/Predicate 是一个返回 `bool` 类型的函数，通常用于 STL 中。

    ```cpp
    bool isEven(int x) {
        return x % 2 == 0;
    }
    
    bool isLessThan (int x, int y) {
        return x < y;
    }
    ```

想法：通过传入谓词函数，可以进一步简化上一节中的 `find` 函数。推广开来，定义序关系后，程序会更加简单。

```cpp
template <typename It, typename Pred>
It find_if(It first, It last, Pred pred) {
    for (It it = first; it != last; ++it) {
        if (pred(*it)) return it;
    }
    return last;
}

bool isVowel(char c) {
    c = ::tolower(c);
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'; 
}

std::string s = "Hello, World!";
std::string::iterator it = find_if(s.begin(), s.end(), isVowel);
```

将函数作为参数传递允许我们将算法与用户定义的行为进行泛化。
> Passing functions allows us to **generalize** an algorithm with **user-defined behaviour**.

事实上，`Pred` 是一个函数指针，对上述式子来说，`Pred` 的类型是 `#!cpp bool(*)(char)`。

但是，单纯传递函数指针作为参数是个很好的想法，然而函数指针的泛化能力有限（修改一下上面那段代码使得 `isVowel` 可以接受两个参数就知道了）。因此，我们引入了 Lambda 表达式。

## 2. Lambda 表达式

Lambda 函数是从所在的作用域捕获状态的函数。
> Lambda functions are functions that capture state from an enclosing scope.

```cpp
int n;
std::cin >> n;

auto lessThanN = [n](int x) { return x < n; };
```

Lambda 表达式的完整声明如下：`#!cpp [capture-values](arguments) mutable exception-> return type { function-body };`：

- 方括号 `[]` 内的是捕获列表，可以让函数体内使用外侧的变量；
- 括号 `()` 内的是参数列表，和正常的函数无异；
- `mutable` 关键字表示 Lambda 函数可以修改捕获的变量；
- 花括号 `{}` 内的是函数体，但是只有参数列表和捕获的变量可以被访问。

捕获方式如下：

- `[x]`：按值捕获 x（创建副本）；
- `[x&]`：按引用捕获 x；
- `[x, y]`：按值捕获 x 和 y；
- `[&]`：按引用捕获所有变量；
- `[&, x]`：除了 x 按值捕获外，其他都按引用捕获；
- `[=]`：按值捕获所有变量。
- `[]`：不捕获任何变量。

一个函子/Functor 是重载了 `operator()` 的类，Lambda 表达式本质上就是一个匿名的函子。
> Definition: A functor is any object that defines an operator()

```cpp
template <typename T>
struct std::greater {
    bool operator()(const T& x, const T& y) const {
        return x > y;
    }
};

std::greater<int> greaterThan;
greaterThan(3, 5);              // false
```

既然函子是一个对象，它当然可以有状态：

```cpp
struct my_functor {
    bool opearator()(int a) const {
        return a * value;
    }

    int value;
}

my_functor f;
f.value = 3;
f(5);       // 15
```

我们通过生成函子来生成 Lambda 表达式：

```cpp
int n = 10;
auto lessThanN = [n](int x) { return x < n; }
find_if(begin, end, lessThanN);
```

其中的 Lambda 表达式就等价于：

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

另外，`#!cpp std::function` 是所有函数/Lambda 表达式的统一类型，所有函数指针/函子/Lambda 表达式都可以转化成这种类型，但是运行稍微慢一点。

## 3. Range 和 View

Range 是定义了 `begin` 和 `end` 的任何东西。
> Definition: A range is anything with a begin and end.

像 `std::vector`、`std::string`、`std::set`、`std::map` 都是 Range。 

Range 提供了很多有效的函数，比如 `std::ranges::find`：

```cpp
std::vector<char> v = {'a', 'b', 'c', 'd', 'e'};
auto it_ = std::find(v.begin(), v.end(). 'c');
auto it  = std::ranges::find(v, 'c');
auto _it = std::ranges::find(v.begin() + 1, v.end() -  1, 'c');
```

View/视图提供一种组合算法的方式，View 是一种惰性地适配另一个 Range 的 Range。
> Views: a way to compose algorithms.  
> Definition: A view is a range that lazily adapts another range.

```cpp
std::vector<char> v = {'a', 'b', 'c', 'd', 'e'};
std::vector<char> f, t;

std::copy_if(v.begin(), v.end(), std::back_inserter(f), isVowel);
std::transform(f.begin(), f.end(), std::back_inserter(t), toupper);
```

在使用 View 后，上述可以变成：

```cpp
std::vector<char> letters = {'a', 'b', 'c', 'd', 'e'};

auto f = std::ranges::views::filter(letters, isVowel);
auto t = std::ranges::views::transform(f, toupper);

auto vowelUpper = std::ranges::to<std::vector<char>>(t);
```

这利用了 View 的可组合性，我们还可以通过 `#!cpp opera tor|` 来将 View 串联在一起，这很像管道操作：

```cpp
using rv = std::ranges::views;
std::vector<char> letters = {'a', 'b', 'c', 'd', 'e'};
std::vector<char> upperVowel = letters | rv::filter(isVowel) | rv::transform(toupper) | rv::to<std::vector<char>>();
```

- View 是**惰性求值/Lazy Evaluation** 的，这意味着上上个代码块只有到了最后一行才会真正求值。这样就可以很大的节约内存空间。这很像 Python 的生成器。
- Range 是**急切求值/Eager Evaluation** 的，这意味着 `#!cpp std::ranges::sort(v);` 会立刻操作。`std::ranges` 是旧的 STL 算法的重新包装。

> [PPT 上提到的一个小问题](https://www.fluentcpp.com/2019/02/12/the-terrible-problem-of-incrementing-a-smart-iterator/)

C++26 甚至还有更新的东西，这就不写了。
