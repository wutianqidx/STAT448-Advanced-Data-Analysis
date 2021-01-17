data politics;
 length can_off $3 can_nam $90 can_off_sta $2 can_par_aff $3 can_status $10;
 infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/politics.csv' dlm=',' dsd firstobs=2;
 input can_off $ can_nam $ can_off_sta $ can_par_aff $ can_status $ ind_con :dollar13.2 ;
 format can_status $1. ind_con dollar13.2 ;
 if can_par_aff not in ('DEM','REP') then party='OTH';
  else party=can_par_aff;
 if can_off_sta in ('CO','FL','IA','MI','MN','OH','NV','NH','NC','PA','VA','WI') then swingstate=1;
  else swingstate=0;
 if ind_con >= 1000000 then contributiongroup='high';
  else if 250000 <= ind_con < 1000000 then contributiongroup='mid';
   else if ind_con < 250000 then contributiongroup='low';
    else contributiongroup=' ';
   *format contributiongroup $6.;
drop can_par_aff;
run;

*(a);
proc sort data = politics;
 by descending ind_con;
run;

title 'Candidates swinging from other parties' ;
proc print data = politics;
 where swingstate = 1 and party = 'OTH';
run;

*(b);
title 'Bar plot of the contributions group among the political parties';
proc sgplot data = politics;
 vbar contributiongroup / group = party groupdisplay=cluster;
run;

*(c);
title 'Bar plot of the contributions group among the candidate’s status';
proc sgplot data = politics;
 vbar contributiongroup / group = can_status groupdisplay=cluster;
run;

*(d);
proc freq data = politics;
 tables swingstate*can_off / expected riskdiff;
run;

*(e);
proc freq data = politics;
 tables swingstate*can_off / expected or(cl=wald);
run;

*(f);
proc freq data = politics;
 tables swingstate*can_off / expected chisq;
run;

*(g);
proc freq data = politics;
 tables can_off*contributiongroup / expected chisq;
run;

*(h);
proc anova data = politics plots=none;
 class can_off;
 model ind_con = can_off;
 means can_off / hovtest welch;
run;

proc npar1way data = politics;
 class can_off;
 var ind_con;
 ods select KruskalWallisTest;
run;;/

*(i);
proc anova data = politics;
 class swingstate;
 model ind_con = swingstate;
 means can_off / welch;
run;

*(j);
data log_politics;
 set politics;
 log_ind_con = log(ind_con);
run;





