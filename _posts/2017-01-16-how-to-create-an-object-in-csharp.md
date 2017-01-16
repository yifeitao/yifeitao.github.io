---
title: 如何创建一个对象(C#篇)
layout: post
categories: coding
---

 在面向对象编程范式的语言中，对象是最重要的一个概念，对象维护自身的状态，通过发消息（调用）来影响其他对象，从而完成整个程序的运转。何时以何种方式创建对象，是面向对象设计中需要重点考量的问题之一。本文对C#语言中创建对象的方法进行简要总结，涉及语言特性、设计模式等，所有的例子以能说明清楚问题为目的，不注重其实用性。相信本文对Java等其他面向对象语言也有相似的价值。

## 1. new与构造函数

一个C#对象封装了一些字段和一些方法（属性、事件等本质上都是方法），考察一个C#对象的内存图景可以发现，每个具体的对象实际上拥有的是字段，而方法本质上都是全局性的，对象上方法的调用`A.b(...)`可视为`b(A,...)`，对象的`this`指针将作为方法的一个参数传入，从这个角度理解就不难发现，创建一个对象本质上需要根据对象的字段划分一块内存，并将这些字段的内容初始化。完成这项工作最直接的途径就是`new`与构造函数，这也是C#语言提供的构建对象的基本机制。

考虑下面这个简单的例子，`Shape`类主要抽象了计算面积这一行为，派生类`Rectangle`和`Circle`具体完成这一行为。

```c#
public abstract class Shape
{
    public abstract double Area();
}

public class Rectangle:Shape
{
    public double Width { get; set; }
    public double Height { get; set; }
    public Rectangle(double width, double height)
    {
        Width = width;
        Height = height;
    }
    public override double Area()
    {
        return Width * Height;
    }
}

public class Circle : Shape
{
    public double Radius { get; set; }
    public Circle(double radius)
    {
        Radius = radius;
    }
    public override double Area()
    {
        return System.Math.PI*Radius*Radius;
    }
}

public class Test
{
    public static void Main()
    {
        Shape rectangle = new Rectangle(3, 4);
        Shape circle = new Circle(5);
        System.Console.WriteLine(rectangle.Area());
        System.Console.WriteLine(circle.Area());
    }
}
```

我们可以通过如下命令编译与查看IL代码

```
csc Shape.cs
ildasm Shape.exe
```

`Test`类中`Main`函数的IL代码如下：

```
.method public hidebysig static void  Main() cil managed
{
  .entrypoint
  // 代码大小       65 (0x41)
  .maxstack  2
  .locals init (class Shape V_0,
           class Shape V_1)
  IL_0000:  nop
  IL_0001:  ldc.r8     3.
  IL_000a:  ldc.r8     4.
  IL_0013:  newobj     instance void Rectangle::.ctor(float64,
                                                      float64)
  IL_0018:  stloc.0
  IL_0019:  ldc.r8     5.
  IL_0022:  newobj     instance void Circle::.ctor(float64)
  IL_0027:  stloc.1
  IL_0028:  ldloc.0
  IL_0029:  callvirt   instance float64 Shape::Area()
  IL_002e:  call       void [mscorlib]System.Console::WriteLine(float64)
  IL_0033:  nop
  IL_0034:  ldloc.1
  IL_0035:  callvirt   instance float64 Shape::Area()
  IL_003a:  call       void [mscorlib]System.Console::WriteLine(float64)
  IL_003f:  nop
  IL_0040:  ret
} // end of method Test::Main
```

在IL代码中，构造函数编译为一个名为`.ctor`的方法，而new操作有对应`newobj`操作符，生成一个对象实例后将其加入Main函数的栈，而调用对象方法时的操作`callvirt`则保证了在运行时根据继承树找到合适的方法。

很容易发现，普通方法`Area`是运行时确定的，但是构造函数却不得不在编译时确定，或者说，对象的使用是多态的，对象的创建则是具体的，因此，对象的创建，或者说`new`与构造函数这个机制，成为制约程序变化的瓶颈。

## 2 new的隔离与封装

基于1中的例子，考虑如下的需求，用户从命令行输入参数信息，第一个参数代表形状的种类，后续参数代表构造这个形状需要的数据，然后由程序计算面积。代码如下：

```c#
public class Test
{
    public static void Main(string[] args)
    {
        Shape shape = ShapeFactory.CreateShape(args);
        if(args[0]=="Circle")
        {
          shape = new Circle(double.Parse(args[1]));
        }
        else if(args[0]=="Rectangle")
        {
          shape = new Rectangle(double.Parse(args[1]),double.Parse(args[2]));
        }
        if(shape!=null)
        {
          System.Console.WriteLine(shape.Area());
        }
    }
}
```

考虑以下两点原因，我们需要进一步封装上述代码中的条件分支语句：

1. 在应用`Shape`这个体系的时候，类似的根据不同的字符串来创建不同的子类的代码还可能很多，比如根据配置文件来创建`Shape`，根据数据库中的数据来创建Shape等，需要消除重复代码；
2. `Shape`的种类可能不断增多，需要隔离变化。

封装出的方法`CreateShape`可以作为`Shape`类的静态方法，或者作为一个新的工厂类`ShapeFactory`的静态方法。

```c#
public class ShapeFactory
{
  public static Shape CreateShape(string[] args)
  {
    Shape shape = null;
    if(args[0]=="Circle")
    {
      shape = new Circle(double.Parse(args[1]));
    }
    else if(args[0]=="Rectangle")
    {
      shape = new Rectangle(double.Parse(args[1]),double.Parse(args[2]));
    }
    return shape;
  }
}

public class Test
{
    public static void Main(string[] args)
    {
        Shape shape = ShapeFactory.CreateShape(args);
        if(shape!=null)
        {
          System.Console.WriteLine(shape.Area());
        }
    }
}
```

这一般称为简单工厂，算是一种准设计模式，代码的扩展点位于`CreateShape`中的条件分支语句。

## 3 工厂方法和抽象工厂

前述2中的`ShapeFactory`是一个具体类，如果提取出一个接口`IShapeFactory`来，二者就构成了一个工厂方法模式，不过这么做没什么意义，工厂方法更多的是体现在平行的类层次上，考虑这样的需求，假设我们在一个编辑环境中编辑这些`Shape`，双击它们的会弹出不同的设置窗口，即对不同的`Shape`有不同的`Editor`,这时候可以在抽象类`Shape`中加入一个工厂方法`CreateEditor`,它的具体创建行为延迟到子类中决定。

```C#
public abstract class Shape
{
    ...
  	public abstract Editor CreateEditor();
}

public class Rectangle:Shape
{
    public override Editor CreateEditor()
      {
        return new RectangleEditor(this);
      }
}

public class Circle : Shape
{
    public override Editor CreateEditor()
      {
        return new CircleEditor(this);
      }
}

public abstract class Editor{}
public class RectangleEditor : Editor{}
public class CircleEditor : Editor{}
```

具体的创建行为在子类中，但是它们的关系依然是编译时决定并绑定死的。

抽象工厂可以视为工厂方法的扩展，假如`Shape`除了构造`Editor`类体系外，还构建自己的3D形式，那么需要在`Shape`中再加入一个`Create3D`方法，返回`ThreeDShape`，这时`Shape`类构建了一系列相关的类，成为一个抽象工厂，当然这时`Shape`类太过复杂，可以考虑把这些创建函数都提取到`ShapeFactory`中去，这里就不再赘述了。

## 4 反射工厂

 回到1中的`ShapeFactory`，它的扩展点主要是根据不同的字符串生成不同的类，这是创建对象时最常见的场景之一，这个字符串往往来自于用户配置，如果事先知道有多少种子类，那么这个条件分支已经是程序中唯一的扩展点了，也是可以接受的，但如果事先不知道有多少种子类，比如我们把`Shape`类作为一个库提供给程序员使用，那么`ShapeFactory`的位置就会比较尴尬，而.Net的反射机制则能一劳永逸的解除这个尴尬。

根据一个字符串，创建一个同名的对象是很自然的想法，但在C++中，很难实现，因为C++的类编译后不再保有自己的类名信息，而.Net则在运行时一直保有类的详细信息。使用反射改写工厂方法如下：

```C#
public class ShapeFactory
{
  public static Shape CreateShape(string[] args)
  {
    System.Type type = System.Type.GetType(args[0]);
    object[] shapeArgs = new object[args.Length - 1];
    for(int i = 0; i < args.Length - 1; i++)
    {
      shapeArgs[i] = double.Parse(args[i+1]);
    }
    return (Shape)System.Activator.CreateInstance(type, shapeArgs);
  }
}
```

反射是C#和Java这类静态语言获得一定动态性的重要机制，在一些动态语言如Python中，由于Eval机制的存在，字符串和代码基本上是不分家的。

## 5 序列化与反序列化

简单理解的话，序列化等同于把运行时对象存储为一个字符串，而反序列化则等同于从这个字符串（常使用xml格式）恢复对象。一般可以用工厂方法来实现。比如可以这样设计`Shape`的反序列化。

```c#
public abstract class Shape
{
    ...
  	public static Shape Load(string str)
    {
      ...
    }
  	public abstract string Save();
}
```

在`Load`方法中，由于要根据字符串来辨别子类，所以离不开反射机制。

.Net提供了比较友好的序列化与反序列化机制，只要我们设计类型时遵循一定的原则，比如需要无参构造函数等，就可以直接使用该机制。比如在`Rectangle`中加入无参构造函数后，可以把它保存到xml文件再恢复出来。

```C#
Shape rectangle = new Rectangle(3, 4);
XmlSerializer mySerializer = new XmlSerializer(typeof(Rectangle));
StreamWriter myWriter = new StreamWriter("rectangle.xml");
mySerializer.Serialize(myWriter, rectangle);
myWriter.Close();
FileStream myFileStream = new FileStream("rectangle.xml", FileMode.Open);
Shape rectangle2 = (Rectangle)mySerializer.Deserialize(myFileStream);
```

由于序列化和与反序列化机制的成熟，用类似上面的代码可以轻松的实现对象克隆，所以原型模式在C#中比较少使用。

一般的Xml序列化有一个问题，它不能保持对象间的引用关系，微软还将WPF中的Xaml序列化单独拿出来做成了库，所以不想自己实现一个保持引用关系的序列化机制的话，可以考虑System.Xaml 命名空间。

## 6 依赖注入

关于依赖注入的原理，看懂老马的这篇文章就够了。

依赖注入要解决的是一系列相关对象的创建问题，对象`A`的组成部分之一`B`是一个抽象类，那么在创建`A`的时候就免不了要创建`B`的实例，而这就免不了具体类的出现，因此需要使用工厂类完成这项工作，这样类`A`才能真正和`B`的具体子类解耦。依赖注入通过一个公有的的工厂机制来解决这个问题，只要你的类按照一定的规则设计，比如提供构造函数或者提供属性，用于设定类中包含的抽象类型的具体实例。

依赖注入框架一般支持代码创建对象，也支持xml配置文件创建对象，第一种方式将对象创建代码集中起来，但对象类型仍然是编译时确定的，而第二种方式则借助反射，使用描述式编程来管理对象创建，完全实现运行时确定对象类型。

C#中的依赖注入框架，除了官方的Unity外，还有Autofac，Ninject等。

对象的创建问题，到依赖注入框架，基本上也就到极致了。



