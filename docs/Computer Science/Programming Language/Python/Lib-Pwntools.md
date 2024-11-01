# Pwntools

## BruteForce

`pwnlib.util.iters` 在原来的 Python 库 `itertools` 加入了很多别的东西，比如我们最常用的 `bruteforce()` 和 `mbruteforce()` 方法。

`pwnlib.util.iters.bruteforce(func, alphabet, length, method='upto', start=None)` 接受 5 个参数：

- `func` 为一个函数，接收一个字符串，返回一个布尔值，整个 `bruteforce()` 会对整个字符串进行枚举，一直到 `func` 函数返回为 `True` 为止；
- `alphabet` 为输入的字符集合，常见的有 `string.ascii_letters`、`string.lowercase`、`string.uppercase`、`string.digits`、`string.hexdigits`、`string.printable`、`string.punctuation`、`string.whitespace` 等。
- `length` 为枚举的字符串长度；
- `method` 为对字符串长度枚举的方法，有 `upto`、`fixed` 和 `downfrom` 三种，`upto` 会从长为 1 的字符串到长为 `length` 的字符串枚举；`fixed` 会仅对长为 `length` 的字符串枚举；`downfrom` 就不多说了；默认会是 `upto`；
- `start` 是一个元组 `(i, N)` 会将搜索空间分为 `N` 个部分，然后从第 `i` 个部分开始搜索，默认就是 `None` 也就是 `(1, 1)`。

