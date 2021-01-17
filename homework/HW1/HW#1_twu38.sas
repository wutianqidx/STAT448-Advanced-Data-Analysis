data fishy;
  infile '/home/wutianqidx0/stat448/fishy.csv' dsd dlm=',' firstobs=2;
  input species $ weight length1 length3 height;
run;

*(a);
proc sgscatter data=fishy;
  title "Scatterplot Matrix for fishy Data";
  matrix weight length1 length3 height;
run;

*(b);
proc corr data = fishy;
  title "Linear Correlation Analyses for fishy Data";
run;

proc corr data = fishy spearman;
  title "Nonlinear Correlation Analyses for fishy Data";
run;

*(c);
proc corr data = fishy nosimple;
  by species;
  title "Linear Correlation Analyses by group for fishy Data";
run;

proc corr data = fishy nosimple spearman;
  by species;
  title "Nonlinear Correlation Analyses by group for fishy Data";
run;

*(d);
proc sgplot data=fishy;
 title "Vertical Box Plot of Weight";
 vbox weight;
run;

*(e);
proc sgplot data=fishy;
  title "Vertical Box Plot of Weight by species";
  vbox weight / category=species;
run;

*(f); 
proc univariate data=fishy;
 var length1 weight;
 histogram;
 qqplot;
run;

*(g);
proc univariate data=fishy;
 var length3 height;
 by species;
 histogram;
 qqplot;
run;

*(h);
proc univariate data=fishy mu0=30 normaltest cibasic alpha=0.05;
 var length1;
 ods select TestsForLocation TestsForNormality BasicIntervals;
run;
proc ttest data = fishy h0=30;
  var length1;
  ods select ConfLimits TTests;
run;

*(i);
proc univariate data= fishy normaltest;
 var length3;
 by species;
 ods select TestsForLocation TestsForNormality BasicIntervals;
run;
proc ttest data=fishy;
class species;
var length3;
ods select TTests Equality ConfLimits;
run;

*(j);
data log_fishy;
 set fishy;
 lnweight = log(weight);
run;
proc univariate data= log_fishy normaltest;
 var lnweight;
 by species;
 ods select TestsForLocation TestsForNormality BasicIntervals;
run;
