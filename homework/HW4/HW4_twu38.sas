data birth2007_1;
infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/natalitydata2007_1.csv'
       dsd firstobs=2 ;
input DBWT BWTR4 MRACEREC MAR SEX $ MAGER MAGER9 CIG_REC $ CIG_1 CIG_2  
      CIG_3 WTGAIN PRECARE_REC MEDUC BFACIL3 RDMETH_REC ATTEND APGAR5 APGAR5R DPLURAL;
run;
data birth2007_2;
infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/natalitydata2007_2.csv' 
       dsd firstobs=2 ;
input DBWT BWTR4 MRACEREC MAR SEX $ MAGER MAGER9 CIG_REC $ CIG_1 CIG_2  
      CIG_3 WTGAIN PRECARE_REC MEDUC BFACIL3 RDMETH_REC ATTEND APGAR5 APGAR5R DPLURAL;
run;
data birth2007_3;
infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/natalitydata2007_3.csv' 
       dsd firstobs=2 ;
input DBWT BWTR4 MRACEREC MAR SEX $ MAGER MAGER9 CIG_REC $ CIG_1 CIG_2  
      CIG_3 WTGAIN PRECARE_REC MEDUC BFACIL3 RDMETH_REC ATTEND APGAR5 APGAR5R DPLURAL;
run;
data birth2007_4;
infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/natalitydata2007_4.csv' 
       dsd firstobs=2 ;
input DBWT BWTR4 MRACEREC MAR SEX $ MAGER MAGER9 CIG_REC $ CIG_1 CIG_2  
      CIG_3 WTGAIN PRECARE_REC MEDUC BFACIL3 RDMETH_REC ATTEND APGAR5 APGAR5R DPLURAL;
run;
data birth2007_5;
infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/natalitydata2007_5.csv' 
       dsd firstobs=2 ;
input DBWT BWTR4 MRACEREC MAR SEX $ MAGER MAGER9 CIG_REC $ CIG_1 CIG_2  
      CIG_3 WTGAIN PRECARE_REC MEDUC BFACIL3 RDMETH_REC ATTEND APGAR5 APGAR5R DPLURAL;
run;
data birth2007;
 set birth2007_1 birth2007_2 birth2007_3 birth2007_4 birth2007_5;
 BWTRC=BWTR4;
 MAGERC=MAGER9-1;
 if BFACIL3=1 then BFACIL=1;
  else if BFACIL3=2 then BFACIL=0;
 if MRACEREC=1 then MRACE=0;
  else MRACE=1;
 if MAR=1 then MARR=0;
  else if MAR=2 then MARR=1;
 if ATTEND in (1,2) then ATTENDC=1;
  else if ATTEND=3 then ATTENDC=2;
   else if ATTEND=4 then ATTENDC=3;
    else if ATTEND=5 then ATTENDC=4;
 where DBWT < 9999 and BWTR4 <4 and MAGER between 18 and 45 and CIG_REC ^='U' and 
       CIG_1 <99 and CIG_2 <99 and CIG_3 <99 and WTGAIN < 99 and 
       PRECARE_REC <5 and MEDUC <9 and BFACIL3 < 3 and RDMETH_REC < 5 and
       APGAR5 < 11 and DPLURAL=1;
 if 1<=ATTENDC<=4;
 drop BFACIL3 MRACEREC MAR BWTR4 ATTEND MAGER9;
run;
proc contents data=birth2007;
run;

*1;
proc freq data = birth2007;
table BWTRC*APGAR5R;
run;


*2;
proc freq data = birth2007;
table BWTRC*MAGERC;
run;

*3;
data birth2007_1;
set birth2007;
if DBWT <2500 then DBWTB=1;
else if DBWT>=2500 then DBWTB=0;
run;

proc logistic data = birth2007_1 ;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1') RDMETH_REC(param=ref ref='4')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model DBWTB(ref = '0') = MRACE MARR WTGAIN RDMETH_REC MAGERC PRECARE_REC MEDUC;
run;


*4;
proc logistic data = birth2007_1 ;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1') RDMETH_REC(param=ref ref='4')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model DBWTB(ref = '0') = MRACE MARR WTGAIN RDMETH_REC MAGERC PRECARE_REC MEDUC
 /selection = stepwise sle=0.05 sls=0.05 ;
 output out=birth2007_cbar CBAR = CBAR;
run;

proc print data = birth2007_cbar;
where CBAR>0.5;
run;

*5;
proc logistic data = birth2007_1 ;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1') RDMETH_REC(param=ref ref='4')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model DBWTB(ref = '0') = MRACE MARR WTGAIN RDMETH_REC MAGERC PRECARE_REC MEDUC/lackfit rsquare ;
run;

*6;
proc logistic data = birth2007;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1') RDMETH_REC(param=ref ref='4')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model APGAR5R = MRACE MARR WTGAIN RDMETH_REC MAGERC PRECARE_REC MEDUC
 /link = clogit;
run;

*7;
proc logistic data = birth2007;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1') RDMETH_REC(param=ref ref='4')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model APGAR5R = MRACE MARR WTGAIN RDMETH_REC MAGERC PRECARE_REC MEDUC
 /link = clogit selection= stepwise sle=0.05 sls=0.05;
run;

*8;
proc logistic data = birth2007;
 class MRACE(param=ref ref='1') RDMETH_REC(param=ref ref='4')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model APGAR5R = MRACE WTGAIN RDMETH_REC MAGERC PRECARE_REC MEDUC
 /link = clogit lackfit rsquare;
run;

*9;
data cigbirth2007;
set birth2007;
where CIG_REC = 'Y';
DAILYCIG_AVG = round((CIG_1+CIG_2+CIG_3)/3);
run;

proc genmod data = cigbirth2007;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model DAILYCIG_AVG = MRACE MARR WTGAIN MAGERC PRECARE_REC MEDUC 
 / dist=poisson link=log type1 type3;
run;


*10;
proc genmod data = cigbirth2007;
 class MRACE(param=ref ref='1') MARR(param=ref ref='1')
 		MAGERC(param=ref ref='7')  PRECARE_REC(param=ref ref='4') MEDUC(param=ref ref='8');
 model DAILYCIG_AVG = MRACE MARR WTGAIN MAGERC PRECARE_REC MEDUC 
 / dist=poisson link=log scale=deviance type1 type3;
 output out=cigbirth2007_1 cooksd= cook1 ;
run;

proc print data=cigbirth2007_1;
 where cook1 > 1;
run;