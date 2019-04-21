libname sl "C:\Users\20141\Desktop\7-���������ҵ\saslib";
options ls=72 ps=40;
/*������ֵ�ֱ�Ϊ(0,0),(3,0),(1,2),Э����
��Ϊ��λ��Ķ�ά��̬�ֲ�*/
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


proc fastclus data=sl.data out=sl.out1 maxc=3 noprint;
  var x y;
run;

proc cluster data=sl.data outtree=sl.tree
         method=single noprint;
   var x y;
proc tree noprint out=sl.out2 n=3 dock=5;
   copy x y;
   title'������ȫ�ֿ�����״���ݵ���̾�����෨';
run;
proc cluster data=sl.data outtree=sl.tree
         method=averge noprint;
   var x y;
proc tree noprint out=sl.out3 n=3;
   copy x y;
   title'������ȫ�ֿ�����״���ݵ���ƽ����';
run;

proc cluster data=sl.data outtree=sl.tree
         method=ward noprint;
   var x y;
proc tree noprint out=sl.out4 n=3;
   copy x y;
   title'������ȫ�ֿ�����״���ݵ�WARD���ƽ���ͷ�';
run;

proc cluster data=sl.data outtree=sl.tree
         method=centroid noprint;
   var x y;
proc tree noprint out=sl.out5 n=3 dock=5;
   copy x y;
   title'������ȫ�ֿ�����״���ݵ����ķ��������';
run;

proc cluster data=sl.data outtree=sl.tree
         method=twostage k=10 noprint;
   var x y;
proc tree noprint out=sl.out6 n=3;
   copy x y;
   title'������ȫ�ֿ�����״���ݵ����׶��ܶȷ�';
run;


