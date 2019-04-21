## Sas2py

**SAS cluster plot by Python** 

> **使用方式**

* 适用于Windows系统
* 适当修改`sas` 与 `python` 文件的数据和first变量
* sas cluster.sas
* python Sas2py.py
* 图片存放在 ./picture/cluster.png 



---

>  **代码展示**

#####  SAS 代码

##### 随机生成一个案例，然后使用不同的方法进行比较。

```sas
libname sl "C:\Users\20141\Desktop\7-聚类分析作业\saslib";
options ls=72 ps=40;
/*产生均值分别为(0,0),(3,0),(1,2),协差阵
均为单位阵的二维正态分布*/
data sl.data;
   keep x y c;
   n=50;scale=1;
   mx=0;my=0;c=3;link generate;
   mx=3;my=0;c=1;link generate;
   mx=1;my=2;c=2;link generate;
   stop;
   generate:
      do i=1 to n;
	    x=rannor(9)*scale+mx;
        y=rannor(9)*scale+my;
	    output;
	  end;
	  return;
run;

*快速聚类
proc fastclus data=sl.data out=sl.out1 maxc=3 noprint;
  var x y;
run;

*最短距离聚类法
proc cluster data=sl.data outtree=sl.tree
         method=single noprint;
   var x y;
proc tree noprint out=sl.out2 n=3 dock=5;
   copy x y;
   title'不能完全分开的球状数据的最短距离聚类法';
run;

*类平均法
proc cluster data=sl.data outtree=sl.tree
         method=averge noprint;
   var x y;
proc tree noprint out=sl.out3 n=3;
   copy x y;
   title'不能完全分开的球状数据的类平均法';
run;


*WARD离差平方和法
proc cluster data=sl.data outtree=sl.tree
         method=ward noprint;
   var x y;
proc tree noprint out=sl.out4 n=3;
   copy x y;
   title'不能完全分开的球状数据的WARD离差平方和法';
run;

*重心法
proc cluster data=sl.data outtree=sl.tree
         method=centroid noprint;
   var x y;
proc tree noprint out=sl.out5 n=3 dock=5;
   copy x y;
   title'不能完全分开的球状数据的重心法聚类分析';
run;

*两阶段聚类
proc cluster data=sl.data outtree=sl.tree
         method=twostage k=10 noprint;
   var x y;
proc tree noprint out=sl.out6 n=3;
   copy x y;
   title'不能完全分开的球状数据的两阶段密度法';
run;

```

##### python代码

```python
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
zhfont1 = matplotlib.font_manager.FontProperties(fname='C:\\Windows\\Fonts\\simhei.TTF')

method = ["真实分类","快速聚类法","最短距离聚类法","类平均法","WARD离差平方和法","重心法","两阶段聚类"]
color = ['red','blue','green','purple','gold']
fig = plt.figure(figsize=(13,13))
fig.suptitle("各种聚类方法比较",fontproperties=zhfont1, fontsize=20)

cluster = []
first = True

for i in range(7):
    if first:
        data = pd.read_sas('./saslib/data.sas7bdat')
        x = data.x
        y = data.y     
        label = data.c.replace(set(data.c),color[:len(set(data.c))])
        ax = fig.add_subplot(3,3,i+1)
        ax.set_title(method[i],fontproperties=zhfont1,fontsize=15)
        ax.scatter(x, y, c=label,s=30, alpha=0.8) 
        first = False
        continue
    if i == 2:
        color = ['red','green','blue','purple','gold']
    data = pd.read_sas('./saslib/out%d.sas7bdat' % i)
    data.dropna(axis=0, how='any', inplace=True)
    cluster = data.CLUSTER.replace(set(data.CLUSTER),color[:len(set(data.CLUSTER))])
    x = data.x
    y = data.y
    ax = fig.add_subplot(3,3,i+1)
    ax.set_title(method[i],fontproperties=zhfont1,fontsize=15)
    ax.scatter(x, y, c=cluster,s=30, alpha=0.8)

plt.savefig('./picture/cluster') #保存
plt.show()
```

聚类图像如下:

![不同聚类方法](.\picture\demo.png)