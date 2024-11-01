# Java

!!! Abstract
    这是我学习Java语言的笔记，动机很简单，我想听的*CS61B*与*Algorithms*课程都是基于Java的，所以我需要学习Java。

    参考书籍：

    - 《Java核心技术》 卷I
    - 《On Java》 基础卷
    - 《Algorithms》

> Java is a **high-level, class-based, object-oriented** programming language.

## Basic

### 1.1 在写代码之前

Java的类库源文件在JDK中以压缩文件`lib/src.zip`的形式发布，其包括了所有公共类库的源代码，解压缩这个文件就可以得到源代码。

使用命令行工具，我们可以编译和运行Java程序。编译Java程序使用`javac`命令，`javac`程序是一个Java编译器，将我们的代码编译成字节码文件，也就是类文件（扩展名为`.class`）；再使用`java`命令启动Java虚拟机，执行编译器编译到类文件的字节码。

编译器需要文件名，需要提供扩展名`.java`，而虚拟机需要类名，不需要提供扩展名。

### 1.2 基本程序结构

调用方法的通用语法是`object.method(parameters)`，其中`object`是一个对象，`method`是对象的一个方法，`parameters`是方法的参数。

对于这段最简单的代码：

```java
public class FirstSample{
    public static void main(String[] args){
        System.out.println("We will not use 'Hello, World!'");
    }
}
```

关键词`public`被称为**访问修饰符/Access modifier**，决定了控制程序其他部分对这部分代码的访问级别。`class`表示Java程序中的**全部内容**都包含在类中，类是Java应用的构建模块。**一个源文件只能有一个公共类**，**但是可以有任意数量的非公共类**，源文件的文件名必须和公共类的类名相同，并且用`.java`作为扩展名。

在执行已经编译的程序的时候，虚拟机总是从指定类的`main`方法的代码开始执行，所以类的源代码中必须包含一个`main`方法，且`main`方法必须声明为`public`，当然直接声明全套`public static`也是极好的。方法其实就是函数的另外一种说法，我们也可以自行定义方法并且添加到类中。

### 1.3 对象与类

Java是一种**纯粹的**面对对象的语言，面对对象的程序是由对象组成的，每个对象包括对用户公开的特定功能与隐藏的实现。在面对对象程序设计中，数据是第一位的，之后我们才考虑操作数据的大小。

#### 1.3.1 类

**类/Class**指定了如何构造对象，通过一个类**构造/Construct**对象的过程称为创建这个类的一个**实例/Instance**。**封装/Encapsulation**是面对对象程序设计的一个重要概念，是指将数据与行为组合在一个包中，并对对象的使用者隐藏了具体的实现细节。对象中的数据称为**实例字段/Instance field**，操作数据的过程称为**方法/Method**，作为一个类的实例，一个对象有一组特定的实例字段值，这些值的集合就是这个对象的**当前状态/State**。只要在对象上调用一个方法，它的状态就有可能发生改变。

封装的关键在于，**不能让其他类的方法直接访问这个类的实例字段**。我们还可以通过**扩展**其他的类来构建新类，这个新类具有被扩展的类的所有属性与方法，这种通过扩展一个类来得到另外一个类的过程叫做**继承/Inheritance**。

使用面对对象编程之前，必须清楚对象的三个主要特性：

- 对象的**行为/Behavior**：可以对对象施加哪些操作，或者应用哪些方法？
- 对象的**状态/State**：调用那些方法的时候，对象将会如何响应？
- 对象的**标识/Identity**：如何区分可能具有相同行为和状态的不同对象？

对象的标识是两两不同的，每个对象都有一个唯一的标识。

类之间的最常见的关系有：**依赖/uses-a**，**聚合/has-a**与**继承/is-a**。

**依赖/Dependence**是最一般且最明显的关系，比如`Order`类使用了`Account`类，因为`Order`类需要访问`Account`类来获取信息。应该尽可能减少相互依赖的类，或者说减少类之间的**耦合/Coupling**。因为耦合度越低，越不容易在修改一个类的时候影响其他类。

**聚合/Aggregation**表明了一个类包含另外一个类的对象。

**继承/Inheritance**表示了一个更特殊的类与一个更一般的类之间的关系，在特殊化的类里边定义了更多的特殊方法与额外功能。

#### 1.3.2 预定义类

在Java中，没有类就不能做任何事情，但是并不是所有类都表现出面对对象的典型特征，比如`Math`类，它只包括了一些方法，甚至没有实例字段。下面我们将以`Date`类与`LocalDate`类为例说明类的使用。

在Java中，我们需要使用**构造器/构造函数/Constructor**来构造新的实例，构造器是一种特殊的方法，用来构造并且初始化对象，并且构造器总是与类同名。我们看几个例子：

- `new Date();`：使用`new`操作符，我们就可以构造一个`Date`对象，并且将这个对象初始化为当前的日期与时间。
- `String s = new Date().toString();`我们可以对这个对象应用一个方法，将这个日期转换成一个字符串。
- `System.out.println(new Date());`我们也可以将这个对象传递给一个方法。
- `Date rightNow = new Date();`我们定义了一个对象那个变量`rightNow`，其可以引用`Date`类型的变量，并且将新构造的对象存储在对象变量`rightNow`中。

对于对象变量而言，他们并不包含一个对象，只是**引用**一个对象，我们可以显式地将对象变量初始化为`null`，这就表明这个变量目前没有引用任何对象，对一个赋值为`null`的变量，我们不允许应用任何方法。

尽管我们使用了**引用**这个词，但是Java中的对象变量更像是C++中的对象指针，并且Java的语法甚至和C++的是一样的。所有的Java对象都存储在堆之中，当一个对象包含另外一个对象变量的时候，其实只是包含了另外一个堆对象的指针。

上面提到的`Date`类的实例有一个状态，就是一个特定的时间点，时间是距离另外一个固定的时间点的毫秒数，这个时间点就是所谓的**纪元/Epoch**，在Java中，纪元是UTC时间1970年1月1日00:00:00。

- `LocalDate.now();`
- `LocalDate newYearsEve = LocalDate.of(1999, 12, 31);`
- `int year = newYearsEve.getYear();`/`int month = newYearsEve.getMonthValue();`/`int day = newYearsEve.getDayOfMonth();`
- `LocalDate aThousandDaysLater = newYearsEve.plusDays(1000);`：**访问器方法/Accessor method**，与**更改器方法/Mutator method**。

#### 1.3.3 自定义类

我们不仅仅需要学会使用常用的类与配套的方法，还需要学会编写类。我们经常写的一种类叫做**主力类/Workhorse class**，这种类没有 `main` 方法，但是有自己的实例字段和实力方法，是构建一个完整程序的众多部分之一。

最简单的类形式为：

```java
type class ClassName{
    field;          // 实例字段
    constructor;    // 构造器
    method;         // 方法
}
```

实例字段可以是基本类型，也可以是对象。我们一般需要**将实例字段声明为 `private`**，这确保只有这个类的方法可以访问这种字段，这就是封装的一部分。而方法可以声明为 `private` 或者 `public`，`public` 方法可以被任何类的任何方法调用。`private` 方法只可以被本类的其他方法调用。

我们先看一个自定义类的例子：

```java
public class Employee{
    private String name;
    private double salary;
    private LocalDate hireDay;

    public Employee(String n, double s, int year, int month, int day){
        name = n;
        salary = s;
        hireDay = LocalDate.of(year, month, day);
    } // constructor

    public String getName(){
        return name;
    } // more methods
}
```

从**构造器**开始看，构造器与类同名。构造`Employee`类的对象时，构造器会运行，将实例字段初始化为所希望的初始状态。构造器没有返回值，可以有参数，也可以没有参数。

在声明对象变量的时候，我们可以用`var`关键字声明，Java会根据变量的初始值推导出其类型。比如，对上面的类，我们只需要声明`var harry = new Employee("Harry Hacker", 50000, 1989, 10, 1);`就可以了。

在使用构造器初始化一个对象的时候，有可能将某个实例字段初始化为`null`，但又有可能对这个字段应用某个方法，一个“宽容”的解决方法就是将`null`参数转换成一个适当的非`null`值，`Objects`类给予了一种便利方法：`Objects.requireNonNullElse(T, defalt obj)`，如果输入的对象`T`是`null`，那么就将返回默认值`default obj`。同样地，其实还提供了一种“严格”的方法`Objects.requireNonNull(T, string message)`，如果输入的对象`T`是`null`，那么就将抛出一个`NullPointerException`异常并且显示出问题的描述。

方法会操作对象并且访问其实例字段，方法一般会有两个参数，第一个参数是**隐式参数/Implicit parameter**，出现在方法名之前；第二个参数是**显式参数/Explicit parameter**，出现在方法名之后的括号里面。在方法中，我们可以使用`this`关键字来引用隐式参数。

封装是极其有必要的，我们来看一些比较特殊的方法，这些方法只访问并且返回实例字段的值，因此被称为**字段访问器/Field accessor**。相比于将实例字段声明为`public`，编写单独的访问器会更加安全：外界的代码不能修改这些实例字段，并且如果这些实例字段出了问题，我们直接调试字段访问器就可以了，如果是`public`的话，我们就需要在所有的代码中寻找问题。

有时，想要获取或者改变一个实例字段的值，我们需要提供下面三项内容：

- 一个私有的实例字段；
- 一个公共的字段访问器方法；
- 一个公共的字段更改器方法。

这样的处理非常好，首先可以改变内部实现而不改变该类方法之外的任何其他代码；其次，更改器方法可以完成错误检查，这就非常好了！

另外，**不要编写返回可变对象引用的访问器方法**，这样我们好好的封装就毁了！如果硬要返回一个可变对象的引用的话，首先应该对它进行**克隆/Clone**，克隆是指存放在另外一个新位置上的对象副本，使用类重的`clone`方法可以完成这个操作。

**访问权限**是一件非常重要的事情。**方法可以访问所属类的对象的任何数据**，当然包括私有数据，但是**不能访问其他对象的私有数据**。

尽管大部分方法都是公共的，但是某些情况下，**私有方法**可能会更加有用，比如我们希望将一个计算方法分解成若干个独立的辅助方法，但是这些方法不应该作为公共接口，这是因为其与当前实现关系非常紧密，或者需要一个特殊的协议或者调用次序，这些方法就应该实现为私有方法。实现私有方法很简单，只需要将关键字`public`改为`private`就好了。

如果一个方法是私有的，并且类的作者确信这个方法不会在别处使用，这个方法就可以被简单地剔除，但是如果方法是公共的，就不能简单地删除一个方法了，因为还有可能会有其余的代码依赖于这个方法。

我们可以将一些变量、类与方法设置为`final`。当我们定义一个类时使用了`final`修饰，这个类就不能被继承，这个类的成员变量可以根据需要设为`final`，但是类中的所有成员方法都会被设为`final`。如果定义了一个方法为`final`，这个方法就被“锁定”了，无法被子类的 方法重写，对方法定义为`final`一般常见于认为这个方法已经足够完整，不需要改变了。修饰变量是`final`用的最多的地方，`final`变量**必须显式指定初始值**，并且一旦被赋值，就不能给被重新赋值；如果`final`的是一个基本变量，这个变量就不能改动了，如果是一个**引用变量**，那么**对其初始化之后就不能再指向其他变量**。

比如`private final StringBuilder evaluations = new StringBuilder();`，这里的`evaluations`就不能指向别的对象了，但是这个对象可以修改，比如`evaluations.append(LocalDate.now() + ":Yes!")`。`final`修饰符对于类型为基本类型或者**不可变类**的字段尤其有用，并且`final`修饰符一般与`static`修饰符一起使用。

#### 1.3.4 `static` 静态

我们发现，先前的很多方法都标记了 `static` 修饰符，下面会讨论这个修饰符的含义。

- 静态字段：如果将一个字段定义为 `static`，那么这个字段并不会出现在每个类的对象之中。静态字段只有一个副本，可以认为这个字段属于整个类，这个类的所有实例将共享这个字段。
- 静态常量相对很常用，就比如 `Math` 类的 `PI` 字段，这个字段是一个不会改变的常量，事实上被定义为 `public static final double PI = 3.14159265358979323846;`。`System.out` 也是一个经常使用的 `final` 的静态常量。
- 静态方法是**不操作对象的方法**：这个方法没有隐式参数，因此不能访问实例字段，也不能使用 `this` 关键字，但是可以访问静态字段。一般使用类名来调用静态方法，比如 `Math.pow(2, 3)`，但是甚至可以使用对象调用静态方法，虽然静态方法的调用的结果和这个对象毫无关系。
  当方法不需要访问对象状态的时候，可以使用静态方法，这种情况下所有的参数都由现实参数提供；只要访问静态字段的时候，当然应该使用静态方法。
- 工厂方法：工厂方法是静态方法最为常见的用途。工厂方法是一个返回类的对象的静态方法，这样我们就可以使用这个方法来构造对象，而不使用构造器。比如 `LocalDate.now()` 就是一个工厂方法。
- `main` 方法：`main` 方法是一个特殊的静态方法，是程序的入口，虚拟机调用这个方法来执行程序。事实上启动程序的时候还没有对象，就只好让入口方法是静态的了。

#### 1.3.5 参数与调用

程序设计语言中，将参数传递给方法一般有两种方法，**按值调用/Call by Value**与**按引用调用/Call by Reference**。在 Java 中，所有的参数**总是按值调用的**，也就是说，方法得到的是所有参数值的一个拷贝。下面看三段代码：

=== "Case 1"

    ```java
    public static void tripleValue(double x){
        x = 3 * x;
    }
    double percent = 10;
    tripleValue(percent);
    ```
    如果我们企图使用这段代码令 `percent` 的值变为 `30`，那么我们就错了，`percent` 的值仍然是 `10`。这是因为传递的是 `percent` 的值，`x` 被初始化为 `percent` 的值的一个副本，然后 `x` 被修改，这个方法结束之后，参数 `x` 被丢弃，但是 `percent` 没有被修改。这个例子表明**一个方法是无法修改基本数据类型的参数的**。

=== "Case 2"

    尽管基本数据类型的参数无法被修改，但是毕竟方法参数有两种，另一种是对象引用。对象参数还是可以修改的，尤其是作为隐式参数的对象的字段。
    ```java
    class Employee{
        private int salary;
        public Employee(int sal){
            salary = sal;
        }
        public void RaiseSalary(int times){
            salary *= times;
        }
        public static void s_RaiseSalary(Employee x, int times){
            x.salary *= times;
        }
    }
    Employee sam = new Employee(100);
    sam.RaiseSalary(3);
    s_RaiseSalary(sam, 3);
    ```

#### 1.3.6 对象构造


### 1.4 数据类型

**数据类型**就是一组数据与对其能进行的操作的集合。

Java是典型的C类语言，声明变量的方法与C极为相似，但是在Java中，变量名的标识符的组成得到了扩充：字母、数字、货币符号与“标点链接符”组成变量名，首字母不能为数字。特别地，字母、数字与货币符号的范围更大，字母可以是一种语言表示中的**任何Unicode**字符，数字可以是`0`到`9`与**表示一位数字的任何Unicode**字符。

#### 1.4.1 基本类型

Java最基本的类型有下面几种，六种数字类型，一种字符类型，一种布尔型：

  - **整型**

  - **双精度实数类型**，与其对应的算数运算符(`double`)。

    我们使用`double`类型来表示双精度实数，使用64位，值域非常之大。

  - **字符型`char`**：`char`使用UTF-16方案进行编码，以前原本用于表示单个字符，但是现在情况变化了，有的Unicode字符需要两个`char`值。`char`类型的字面量要用单引号括起来，也可以表示为十六进制的值，比如`\u0041`就是`A`。
    
    在Unicode编码之前，已经有许多编码标准了，我们最熟悉的就是美国的ASCII编码。标准不统一会出现下面两个问题：对一个特定的代码值，在不同的机制中对应不同的字母；大字符集的语言的编码长度会有不同，有的是单字节编码，有的就使用双字节或者多字节编码。

    Java的字符型使用的16位编码在当时设计时的确是很好的改进，但是现在的Unicode字符已经超过65536个，这就尴尬住了。所以一个实用的建议就是不要在程序之中使用`char`类型，除非要处理UTF-16代码单元，否则就使用`String`类型。

    还是简单介绍一下Unicode编码吧：**码点/Code point**是指与一个编码表中某个字符对应的代码值，Unicode中的码点使用十六进制书写，并且在前面加上一个`U+`，`U+0041`就是A的码点。Unicode中的码点可以分为**17个代码平面/Code plane**。第一个代码平面被称为**基本多语言平面/Basic multilingual plane**，其包含了从`U+0000`到`U+FFFF`的“经典”Unicode编码，其余的16个代码平面从`U+10000`到`U+10FFFF`，包含了各种**辅助字符/Supplementary character**，这些平面包含了一些不常用的字符，比如一些古代文字、表意文字等等。

    UTF-16使用不同长度的代码表示所有Unicode码点，在基本多语言平面之中，每个字符使用16位表示，被称为**代码单元/Code unit**，辅助字符使用一对连续的代码单元表示，这种编码对使用基本多语言平面中未采用的2048个值范围（称为替代区域，`U+D800`到`U+DBFF`用于第一个代码单元，`U+DC00`到`U+DFFF`用于第二个代码单元）。而Java中的`char`类型描述就采用了UTF-16编码的一个代码单元。




#### 1.4.2 运算符

### 1.5 控制语句


### 1.6 字符串

概念上讲，Java 字符串就是字符序列，Java 没有内置的字符串类型，但是标准库中提供了预定义类 `String`，每个被双引号括起来的都是一个 `String` 类的实例，下面聊的主要是 `String` 类的使用。

首先，字符串可以为空，比如 `String emp = "";`，空串是一个长度为 0 的字符串，可以使用 `""` 表示，`null` 是一个特殊的值，表示没有任何对象和这个对象关联。不能对 `null` 调用任何方法，否则会抛出 `NullPointerException` 异常。 

如果要检查某个字符串既不是空串也不是 `null`，一般会这样做 `if (str != null && str.length() != 0)`。

#### 1.6.1 子串与拼接

子串更像切片，我们可以使用 `substring` 方法来获取一个字符串的子串，`substring` 方法有两个参数，第一个参数是子串的起始位置，第二个参数是子串的结束位置，但是**不包括结束位置的字符**，我们也可以认为第二个参数指的是**尾后字符**，这种尾后元素的使用其实蛮常见的，在 C++ 的学习中就可以看见这一点。比如 `String greeting = "Hello"; String s = greeting.substring(0, 3);`，这样 `s` 就是 `Hel`。

拼接很简单，使用 `+` 号就可以了，比如 `String expletive = "Expletive"; String PG13 = "deleted"; String message = expletive + PG13;`，这样 `message` 就是 `Expletivedeleted`。任何非字符串的值和字符串进行拼接的时候，Java 会将非字符串的值转换为字符串，甚至**任何一个 Java 对象都可以转换成字符串**。

值得一提的是，`String` 的运算符 `+` 和 `+=` 是 Java 里边仅有的重载的运算符，Java 不允许程序员重载别的运算符。

#### 1.6.2 字符串的不可变性

如果我们查看 JDK 文档，就会发现 `String` 类其实是不可变的/Immutable，每个看似会修改 `String` 值的方法，实际上都创建并且返回了一个全新的 `String` 对象，这个对象包括了修改后的字符串内容，但是原始的 `String` 对象保持不变。这样设计的原因之一是：参数一般是用来提供信息的，而不是用来修改的，这对代码的可读性和可理解性有很大的帮助。同时，编译器甚至可以让字符串共享。

```Java
public class Immutable{
    public static String upcase(String s){
        return s.toUpperCase();
    }
    public static void main(String[] args){
        String greeting = "Hello";
        System.out.println(greeting);       // Hello
        String GREETING = upcase(greeting);
        System.out.println(greeting);       // Hello
        System.out.println(GREETING);       // HELLO
    }
}
```

#### 1.6.3 比较字符串

使用 `equal` 方法检测两个字符串是否相等，对于表达式 `s.equals(t)`，如果相等就返回 `true`，否则返回 `false`，这个方法是区分大小写的，如果不区分大小写，可以使用 `equalsIgnoreCase` 方法。

由于每个被双引号括起来的字符串都是一个 `String` 类的实例，所以我们可当然可以对其使用 `equals` 方法，`"HeLLo".equals("HeLLo")` 就是 `true`。

`int compareTo(String other)` 和 `int compareToIgnoreCase(String other)` 方法用于比较两个字符串，如果调用字符串 `this` 在字典中排在参数字符串 `other` 之前，就返回一个负数，如果调用字符串在字典中排在参数字符串之后，就返回一个正数，如果两个字符串相等，就返回 `0`。

`matches`

#### 1.6.4 码点和代码单元

#### 1.6.5 String API

- `int length()`：返回字符串的长度。
- `boolean isEmpty()` 和 `boolean isBlank()`：判断字符串是否为空或者由空白符组成。
- `boolean startsWith(String prefix)` 和 `boolean endsWith(String suffix)`：判断字符串是否以指定的前缀或者后缀开始或者结束。



### 1.7 输入输出

#### 1.7.3 格式化输出


#### 1.7.2 格式化输入

从人类可读的文件或者标准输入中读取输入非常重要，但是比较痛苦，一般的解决方法是读入一行文本，然后进行分词解析，再使用 `Integer` 类和 `Double` 类中的方法解析数据。但是 Java 提供的 `Scanner` 类就大大减轻了这个负担。

传统一点的做法是：

但是使用 `Scanner` 类就简单多了，`Scanner` 类定义在 `java.util` 包之中，首先还是需要构造一个与输入流相关联的 `Scanner` 对象，`Scanner in = new Scanner(System.in);`，然后就可以使用 `nextInt`、`nextDouble`、`next` 等方法来读取输入了。

- `Scanner(InputStream in)` 用给定的额输入流构造一个 `Scanner` 对象。
- `String nextLine()` 读取下一行输入。
- `int nextInt()` 和 `int nextDouble()` 读取下一个整数或浮点数，`String next()` 读取下一个单词，这些都是以空白符作为分隔符的。
- `boolean hasNext()` 用于检查是否还有其他单词。
- `boolean hasNextInt()` 和 `boolean hasNextDouble()` 用于检查下一个字符序列是否表示整数或浮点数。
