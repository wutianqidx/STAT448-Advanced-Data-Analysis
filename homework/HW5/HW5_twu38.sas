data crime2012;
 infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/crime_count_2012.csv' dsd firstobs=2;
 input agency $ state $ month agg_assault burglary car_theft larceny murder rape robbery;
 if month >= 12;
 drop month;
run;
proc contents data=crime2012;
run;
proc princomp data=crime2012 plots(ncomp=2)=score(ellipse) cov;
run;

*1;
proc princomp data=crime2012;
id state;
run;

*2;
proc princomp data=crime2012 plots(ncomp=2)=all;
id state;
run;

*3;
proc princomp data=crime2012 plots(ncomp=2)=score(ellipse);
id state;
run;

*4;
proc princomp data=crime2012 cov;
id state;
run;

*5;
proc princomp data=crime2012 plots(ncomp=2)=all cov;
id state;
run;

*6;
proc princomp data=crime2012 plots(ncomp=2)=score(ellipse) cov;
id state;
run;

*8;
proc cluster data = crime2012 method = average
ccc pseudo outtree = crime2012_tree plots = all PLOTS(MAXPOINTS=500);
var agg_assault--robbery;
copy state;
run;

*9;
proc tree data = crime2012_tree out = crime2012_tree1 n = 4;
copy agg_assault--robbery state;
run;

proc sort data = crime2012_tree1;
by cluster;
run;

proc print data=crime2012_tree1;
run;

proc means data = crime2012_tree1;
var agg_assault--robbery;
by cluster;
run;

*10;
proc cluster data = crime2012 method = average
ccc pseudo outtree = crime2012_tree2 plots = all std PLOTS(MAXPOINTS=500);
var agg_assault--robbery;
copy state;
run;

proc tree data = crime2012_tree2 out = crime2012_tree3 n = 4;
copy agg_assault--robbery state;
run;

proc sort data = crime2012_tree3;
by cluster;
run;

proc print data=crime2012_tree3;
run;

proc means data = crime2012_tree3;
var agg_assault--robbery;
by cluster;
run;
