---
layout: post
title:  阿基米德的杠杆原理求抛物线形面积
date:   2010-03-23 21:42:46 +0800
categories: math
---
近年来人们发现了[《阿基米德羊皮书》](http://book.douban.com/subject/3106607/)，其中有阿基米德用杠杆原理求抛物线形的面积的记载，这里面其实已经有微积分思想的雏形了。

![ parabola-area](/assets/images/parabola-area.png)

如上图所示，求Rt△ACZ的内接抛物线形ABC的面积。

证明中用到的条件是对于任一割线MX有 MX:OX=AC:AX。

该前提的证明需要用到切线方程，不知是否有更加初等的方法。

延长CK至T，使得KT=CK，平移OX至SH，T为SH中点，则MX:SH=MX:OX=AC:AX=KC:KN=TK:KN,

线段MX和SH关于点K满足杠杆原理。注意到SH,MX的重心分别为T，N，

由于MX的任意性，故△ACZ内部每根AZ的平行线与它在抛物线形ABC内部的对应线段（平移至T）关于点K满足杠杆原理，

即△ACZ的面积与抛物线形ABC的面积关于K满足杠杆原理，

△ACZ的重心在KC的1/3处，故抛物线形的重心T到△ACZ的重心的距离之比为3:1,

故抛物线形ABC的面积为△ACZ的面积的1/3,或△ABC面积的4/3。
