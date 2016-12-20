---
layout: post
title:  如何序列化泛型List为xaml
date:   2016-12-20 18:57:17 +0800
categories: coding
---
Xaml实际上是一种加强版的Xml，Xaml最初是为了描述WPF控件而设计的，但其实具有一定的通用性，用Xaml序列化对象，可以自动维护对象间的引用关系，大大减轻工作量。

### 1. WPF控件中泛型List的序列化

Xaml序列化对象最直接的应用是保存和加载WPF界面与控件。考虑类似以下的自定义控件类，它包含了一个泛型列表属性。

```c#
public class WpfObject : Label
{
  public WpfObject()
  {
    Children = new List<string> { "hello", "wpf" };
  }
  public List<string> Children { get; set; }
}
```

WPF控件的序列化方法如下：

```c#
WpfObject w1 = new WpfObject { Content = "Hello, wpf" };
string xaml = System.Windows.Markup.XamlWriter.Save(w1);
File.WriteAllText("label.xaml", xaml);
WpfObject w2 = (WpfObject)System.Windows.Markup.XamlReader.Load(File.OpenRead("label.xaml"));
```

由于XamlWriter类的不完善，不支持泛型列表的序列化，上述代码将抛出异常：

```
无法序列化泛型类型“System.Collections.Generic.List`1[System.String]”
Cannot serialize a generic type “System.Collections.Generic.List`1[System.String]”
```

所以需要包装泛型列表属性，使其能序列化，最简单的方法是使用派生类，代码如下：

```C#
public class Children : List<string>{}
public class WpfObject : Label
{
    public WpfObject()
    {
        Children = new Children { "hello", "wpf" };
    }
    public Children Children { get; set; }
}
```

使用前述同样的序列化代码即可。

### 2. 普通对象中泛型List的序列化

自.Net4.0后，微软在System.Xaml.XamlServices命名空间重新设计了Xaml序列化，使其更好的支持一般的对象，不过比较讽刺的是，这个命名空间的序列化却不能很好的支持WPF控件，所以依然只能用本文第1部分的方法去hack。

考虑以下类型：

```C#
public class CommonObject
{
    public List<string> Children { get; set; }

    public CommonObject()
    {
        Children = new List<string> { "hello", "common" };
    }
}
```

它的序列化很简单直接，代码如下：

```C#
CommonObject p1 = new CommonObject();
string xaml = System.Xaml.XamlServices.Save(p1);
File.WriteAllText("parent.xaml", xaml);
CommonObject p2 = (CommonObject)System.Xaml.XamlServices.Load(File.OpenRead("parent.xaml"));
```
