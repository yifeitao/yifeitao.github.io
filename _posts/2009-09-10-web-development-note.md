---
layout: post
title:   Web开发学习笔记
categories: coding
---
## 1 HTML

网页基于古老而青春永驻的HTTP协议传输，在网页上右击鼠标查看源代码，然后我们会看到一堆缺乏美感的代码（不排除有人觉得美），这是浏览器的“母语”——HTML代码。浏览器的使命在于将缺乏美感的HTML代码人道的呈现于上网的你我面前。

用Google搜索HTML（而不是百度），会得到有用的关于HTML的知识。

维基百科的[HTML](http://zh.wikipedia.org/zh-cn/Html)词条介绍了HTML的简要历史，HTML是用于呈现的语言，所以使用了各种标记包裹在文字、图片地址等外面，标记语言的灵活带来的是混乱。微软的IE6统治互联网8年，至今中国绝大部分网民还不离不弃，IE6自创的标准为广大中国用户接受，至今那些ie only的网站还华丽的挂在服务器上，比如[中华人民共和国国家邮政局](http://www.chinapost.gov.cn/)，用Firefox上去是惨不忍睹。[XHTML](http://zh.wikipedia.org/zh-cn/XHTML)是个美好的继承者，因为它有更严格的限定，正如严格的格律限定一定程度上成就了唐诗宋词的伟大时代。

[w3schools](http://www.w3schools.com/htmL/)有教程，演示页面，甚至还有水平测试，这一切都是免费的！只不过你要会一点点英文。当然，中文的傻瓜化[HTML教程](http://zh.html.net/tutorials/html/)也是有的。本人出奇的喜欢写hello world程序，这次也不例外，下面是华丽版的hello world代码：

```html
<html> 
  <title>Hello World!</title>
<body style="background-color: 99FFFF;"> 
  <br /> 
  <h1>Hello World!</h1> 
  <p><a href="http://yifeitao.com/">by yifeitao</a></p> 
  <p>2009-09-10</p> 
  <table border="1" > 
    <tr> 
      <td><img src="http://img1.qq.com/news/pics/17261/17261849.jpg" alt="H" title="H" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261844.jpg" alt="E" title="E" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261862.jpg" alt="L" title="L" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261862.jpg" alt="L" title="L" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261848.jpg" alt="O" title="O" ></img></td> </tr> <tr> <td><img src="http://img1.qq.com/news/pics/17261/17261843.jpg" alt="W" title="W" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261848.jpg" alt="O" title="O" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261857.jpg" alt="R" title="R" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261862.jpg" alt="L" title="L" ></img></td> <td><img src="http://img1.qq.com/news/pics/17261/17261860.jpg" alt="D" title="D" ></img></td> 
</tr> 
</table> 
</body> </html>
```

## 2 Web服务端与客户端

HTTP协议是典型的[C/S](http://en.wikipedia.org/wiki/Client-Server)结构应用，不过客户端一般只需要一个浏览器，所以又有B/S结构的说法。

**Web服务端**需要安装服务端软件以提供Web服务，简言之就是根据用户请求生成相应的页面发送给用户。**Web客户端**只需要一个[浏览器](http://zh.wikipedia.org/zh-cn/%E6%B5%8F%E8%A7%88%E5%99%A8)即可，用于发出请求申请页面，及渲染页面。

在进一步讨论前，有必要了解**静态页面**和**动态页面**的概念。

静态页面对所有的用户请求返回的是完全一样的页面，比如在笔记（1）中写的hello.html，早期的很多个人主页服务只支持静态页面，目前可能只有一些大学的主页服务仍是如此。

而目前更多的是动态页面，比如你看到的这篇文章后面的随机推荐文章是由Web服务端生成的，可能每次都不一样，又比如百度搜索[时间](http://www.baidu.com/s?wd=%CA%B1%BC%E4)会在顶部看到动态的时钟。动态页面由**客户端脚本**和**服务端脚本**实现。

常见的客户端脚本如[JavaScript](http://zh.wikipedia.org/zh-cn/JavaScript)，查看上述时间搜索页面的源代码不难找到它嵌入到`<script type="text/javascript">`和`<script>`标签中的代码，JavaScript会下载到客户端而由客户端的JavaScript引擎解释执行。

而常见的服务端脚本有PHP，ASP等等。如下是PHP版本的hello world，并计算1+1。

```php+HTML
<html> 
  <head> <title>hello world</title> </head> 
  <body> 
    <?php echo "Hello world!<br />"; echo "1+1="; echo 1+1; ?> 
  </body> 
</html>
```

查看演示页面的源代码，很容发现PHP代码是不可见的，我们看到的是服务端输出的html代码。

当然，实际的技术往往同时用到客户端脚本和服务端脚本，如目Ajax技术，这里暂不讨论。

如果不运行服务端脚本，服务端软件只要使用简单的Http File Server即可，如[HFS ~ Http File Server](http://www.rejetto.com/hfs/)（[汉化版](http://www.hanzify.org/?Go=Show::List&ID=11930)）。把要发布的主页命名为index.html或default.html添加至虚拟文件系统即可。

为了创建动态网页，一般需要一个Web服务器（世界上使用最广泛的Web服务是[Apache](http://httpd.apache.org/)），一种服务端编程语言（如PHP）和一个数据库（如[MySQL](http://www.mysql.com/)，适应数据复杂的应用）。介绍这三个组件安装的教程很多，这里介绍傻瓜化的一次性解决方案——[XAMPP](http://www.apachefriends.org/zh_cn/xampp.html)。软件安装启动后，启动Apache服务即可访问http://localhost/，…\xampp\htdocs目录下的php文件均可运行，如…\xampp\htdocs\hello.php可通过http://localhost/hello.php访问。如果你的计算机有外网地址，完全可以开始做网站服务器了。

作为Web客户端的各种浏览器支持的标准不一致，这样导致Web开发者需要安装一堆浏览器以测试浏览效果，有很多开发者甚至不得不放弃万恶的ie6，但在中国，ie6仍是无法越过的高山。

## 3 php基础

PHP语言是用C开发的，所以语法规则基本上与C是一致的，有C背景的人学起来是很容易的。

### 1 输出

PHP代码放在`<?php>`和`<?>`标记之间，可以嵌入到html代码中，Apache服务器检测到后解释执行，最常用的输出方式有**echo**和**print**，输出会成为html代码的一部分最终发送到客户端。

**echo**是命令，不能返回值。echo后面可以跟很多个参数，之间用逗号隔开。

**print**是函数，可以返回一个值，只能有一个参数。

### 2 变量

PHP中变量要用\$开头，其余规则同C语言。

PHP不是强类型语言，无需指定变量类型，但如果自动处理不凑效时，可以强制类型转换。

PHP变量有作用范围，**global**全局变量，**static**静态变量。（意义同C语言）

PHP提供有关脚本环境信息的超全局变量，如`$_SERVER("PHP_SELF")`代表当前的文件名。

### 3 字符串

字符串可用单引号或双引号，但插入变量时必须用双引号。

用双引号时可以输出转义字符，定义基本同C语言，用单引号不行。

字符串比较函数**strcmp**（string1,string2），**strcasecmp**（string1,string2），分别为不区分大小写和区分大小写。字符串可用圆点（.）进行合并。

### 4 常量

常量定义型如**define**("PI",3.14)。常量不以\$开头。

constant(name)返回常量的值，get_defined_constants返回常量列表。预定义常量类似超全局变量，如`_FILE_`表示被执行的PHP文件的名称。

### 5 表达式与运算符

基本同C语言，注意弱类型的特点。类型转换运算符：(int)，(double)，(string)，(array)，(object)。

@运算符抑制错误信息；===全等，!==非全等，用于数组。

### 6 条件语句与循环语句

基本同C语言。演示判断从1900年到2100年的每一年是否是闰年。（源码仅包括PHP嵌入部分）。

```php+HTML
<?php 
for ($year=1900;$year<=2100;$year++) 
	{ if(($year%4==0) AND ($year%100!=0) OR($year%400==0)) echo $year."年是闰年。<br />"; 
     else echo $year."年不是闰年。<br />"; 
    } 
?>
```

## 4 php函数

PHP的函数与C/C++基本是一样的，从PHP5开始也有面向对象的特性，不过据说语言也因此弄得很繁杂。

### 函数的调用与创建

PHP内建了很多函数，其实目前高级语言的会考虑内建函数库，让使用者不必重复造一些简单的部件。比如phpinfo()返回PHP的配置信息。函数名不分大小写，秉承php的弱类型特点，函数有没有返回值以及返回值类型完全是自由的，但返回值如C语言只能有一个，多返回值要考虑数组等方式了。

### 参数

参数传递通常有两种，一是值传递，一是引用传递。PHP也是支持变量引用的，但没有引入强大而混乱的指针机制。PHP支持默认参数。

### 文件包含

PHP中的文件包含有四种，include，include_once， require， require_one。require方式会确保所包含文件的存在，否则停止程序，其余同include。带once的方式可以处理重复包含。function_exists可以检查某函数是否存在，如function_exists("test")。

### 面向对象特性

使用**class**创建类。**new**创建实例。**var**声明变量。构造函数可使用与类同名的方法，或__construct创建。可用this->访问类中的变量。**extends**运算符进行继承，**parent**运算符调用父类方法。可使用 ::直接调用类的方法（即不用创建实例的静态调用）。

## 5 php数组

PHP中的数组对比C/C++的数组做了很大的增强，支持动态数组大小。

### 创建数组

数字数组使用数字作为索引，关联数组则使用字符串。数组的元素可是是字符串、数字乃至其他数组。可以使用数组标识符[]赋值，不指定索引值时，PHP会自动指定。如`$weekdays[]='Monday';$weekdays[]='Tuesday';`

使用array创建数字数组，如`$weekdays[]=array('Monday','Tuesday');`

使用array，使用index=>value格式创建关联数组，如`$shapes=array('Orange'=>'Sphere','Phonebook'=>'Rectangle');`测试变量是否是数组：is_array。

使用foreach循环访问数组，如`foreach($shapes as $key=>$value)print"The $key is a $ value"`;

对已有数组的赋值会自动添加到数组末尾，如`$weekdays[]='Wednesday';`

count或sizeof计算数组的元素个数。使用sort排序，数字按升序，字符串按字母序。多维数组由于数组的元素可以是数组，所以多维数组只不过是数组的嵌套，如`$object=array('Orange'=>array('Shape'=>'Sphere','Color'='Orange'));`

使用list访问多维数组，如

`foreach($object as $obj_key=>$obj){echo"$obj_key:<br>"while(list($key,$value)=each($obj)) print"The $key is a $ value";}`

数组与普通变量使用extract函数作用关联数组index=>value，会产生一系列普通变量，变量名为index，变量值为value。`extract(array,EXTR_PREFIX_ALL,"the prefix")`可指定型如the prefix的前缀。并可作用于数字数组。生成类似the prefix_0的变量。可使用compact将一组变量包装为数组。

