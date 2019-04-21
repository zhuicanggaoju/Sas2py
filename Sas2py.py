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
        try:
            label = data.c.replace(set(data.c),color[:len(set(data.c))])
        except AttributeError:
            label = 'black'
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
