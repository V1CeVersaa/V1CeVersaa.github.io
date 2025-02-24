# Lecture 8 模版类

!!! Info

    注意**模版类**和**类模版**的区别：

    - **类模版/Class Template**：是一个模版，用于生成类的定义，编译器会使用它来实例化各种具体的类。
    - **模版类/Template Class**：是一个类模版实例化后的具体类，当使用类模版定义对象时，需要指定实际的类型参数，从而生成模版类。

!!! Note "「`this` 指针」"

    对于如下定义的类 `Point`：

    ```cpp
    class Point {
       public:
        Point() = default;
        Point(int x, int y) : x(x), y(y) {}
        int getX() const { return x; }
        int getY() const { return y; }
        void setX(int x) { this->x = x; }
        void setY(int y) { this->y = y; }
    
       private:
        int x = 0;
        int y = 0;
    };
    ```

    `this` 是一个指向当前类实例的指针，通过上个例子中的 `Point::setX` 函数，可以看到 `this` 指针的作用。

首先定义一个类模版 `Vector`：

```cpp
template <typename T>
class Vector {
   public:
    T& at(size_t index);
    void push_back(const T& elem);

   private:
    T* elems;
};
```

- 模版声明：`Vector` 是一个模版，接受类型参数 `T`；
- 模版实例化：当使用对应的实例的时候，编译器会根据指定的具体类型生成相应的代码。

    ```cpp
    Vector<int> intVector;
    Vector<std::string> stringVector;
    ```

- `Vector<int>` 和 `Vector<std::string>` 是 `Vector` 的两个实例，但是这两个实例是完全不同的。
    
    > These two instantiations (of the same template) are completely different (runtime and compile-time) types.

- 除了 `typename`，模版参数还可以是别的类型，并且在模版中，`typename` 和 `class` 是等价的。

    ```cpp
    template <typename T, std::size_t N>
    struct std::array;

    std::array<int, 5> arr; // An array of exactly 5 integers

    template <class T, std::size_t N>
    struct std::array;      // Equivalent to the above
    ```

- 声明成员函数的时候需要注意，对于上面类模版 `Vector` 而言，`Vector` 不是一个类型，但是 `Vector<T>` 是一个类型。

    ```cpp
    template <typename T>
    T& Vector<T>::at(size_t index) {
        return elems[index];
    }
    ```

- 注意类模版的实现：在 `.h` 文件中定义接口，在 `.cpp` 文件中实现对应函数，在 `.h` 文件的结尾 `#include` 对应的 `.cpp` 文件。
- 关于 `const`：

    ```cpp
    template <typename T>
    class Vector {
       public:
        size_t size();
        T& at(size_t index);
    };

    void printVec (const Vector<int>& vec) {
        for (size_t i = 0; i < vec.size(); ++i) {
            std::cout << vec.at(i) << std::endl;
        }
    }
    ```

    我们注意到第 8 行的 `const`，这个 `const` 表示传入的 `vec` 是一个常量引用，我们承诺不修改 `vec`，但是对应的 `size` 和 `at` 函数并没有声明为 `const`，编译器不能确定这两个函数是否会修改 `vec`，所以会报错。修改成下面的样子就好了。

    ```cpp
    size_t size() const;
    T& at(size_t index) const;      // 更应该是 const T& at(size_t index) const;
    ```

    对于 `const` 成员函数，传入的 `this` 指针是一个指向常量的指针，在上面就是 `const Vector<int>* this`，这样就不能在成员函数内修改成员变量了。

    **对于定义成 `const` 的对象，我们只能使用 `const` 接口**，其中 `const` 接口是指那些被定义成 `const` 的成员函数。

    基于 `const`，我们可以实现重载。这样，接受 `const` 参数的函数就不能随便修改对应的 `const` 对象，而接受非 `const` 参数的函数可以修改对应的对象，编译器会自动选择合适的函数。

    ```cpp
    const T& at(size_t index) const;
    T& at(size_t index);
    ```

- 关于 `const_cast`：使用为 `const_cast<target_type>(expr)`，cast away the const-ness of a variable。

    ```cpp
    template <typename T>
    T& Vector<T>::findElement(const T& value) {
        for (size_t i = 0; i < size; ++i) {
            if (elems[i] == value) return elems[i];
        }
        throw std::runtime_error("Element not found");
    }

    template <typename T>
    const T& Vector<T>::findElement(const T& value) const {
        return const_cast<Vector<T>&>(*this).findElement(value);
    }
    ```

    这里我们使用 `const_cast` 来将 `const` 的 `*this` 转换为非 `const` 饮用 `const Vector<T>&`，然后调用非 `const` 版本的 `findElement` 函数。但是整体还是 `const` 函数。

- 关于 `mutable`：`mutable` 修饰的成员变量可以在 `const` 函数中修改。
