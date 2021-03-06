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
