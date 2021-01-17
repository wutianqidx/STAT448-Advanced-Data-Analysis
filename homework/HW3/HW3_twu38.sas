data bkhomessmall;
 length NEIGHBORHOOD $45. BUILDING_CLASS $45. ADDRESS $45.;
 infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/brooklynhomes_sub1.csv' dsd firstobs=2;
 input NEIGHBORHOOD $ BUILDING_CLASS $ ADDRESS $ ZIP_CODE RES_UNITS COM_UNITS TOT_UNITS LAND_SQ_FT :comma5. GROSS_SQ_FT :comma5. YEAR_BUILT BUILDING_CLASS_CODE $ SALE_PRICE :dollar11. SALE_DATE :mmddyy10. SAFE_RANK MED_INCOME :dollar10. REQ_LEASE_INCOME :dollar10. LOG_SALE_PRICE;
 format LAND_SQ_FT comma5. GROSS_SQ_FT comma5. SALE_PRICE dollar10. MED_INCOME dollar10. REQ_LEASE_INCOME dollar10. SALE_DATE mmddyy10. LOG_SALE_PRICE 6.3;
 drop LOG_SALE_PRICE;
 if res_units < 5 ;
run;
proc contents data=bkhomessmall;
run;

data bkhomes;
 length NEIGHBORHOOD $45. BUILDING_CLASS $45. ADDRESS $45.;
 infile '/home/wutianqidx0/my_courses/kinson2/stat448_data/brooklynhomes_main.csv' dsd firstobs=2;
 input NEIGHBORHOOD $ BUILDING_CLASS $ ADDRESS $ ZIP_CODE RES_UNITS COM_UNITS TOT_UNITS LAND_SQ_FT :comma5. GROSS_SQ_FT :comma5. YEAR_BUILT BUILDING_CLASS_CODE $ SALE_PRICE :dollar11. SALE_DATE :mmddyy10. SAFE_RANK MED_INCOME REQ_LEASE_INCOME;
 format LAND_SQ_FT comma5. GROSS_SQ_FT comma5. SALE_PRICE dollar10. MED_INCOME dollar10. REQ_LEASE_INCOME dollar10. SALE_DATE mmddyy10.;
 if res_units < 5 ;
run;
data bkhomes;
 set bkhomes;
 where building_class contains '01' or building_class contains '02' or building_class contains '03' ;
run;
proc contents data=bkhomes;
run;


*1;
proc tabulate data=bkhomessmall;
 class NEIGHBORHOOD BUILDING_CLASS;
 var SALE_PRICE;
 table NEIGHBORHOOD*BUILDING_CLASS,
 SALE_PRICE*(mean std n);
run;

proc glm data=bkhomessmall plots=diagnostics;
 class NEIGHBORHOOD BUILDING_CLASS;
 model SALE_PRICE = NEIGHBORHOOD BUILDING_CLASS;
run;

*2;
proc anova data=bkhomessmall;
 class NEIGHBORHOOD BUILDING_CLASS;
 model SALE_PRICE = NEIGHBORHOOD BUILDING_CLASS;
 means NEIGHBORHOOD BUILDING_CLASS/ tukey;
run;

*3;
proc glm data=bkhomes;
 class RES_UNITS SAFE_RANK;
 model SALE_PRICE = RES_UNITS SAFE_RANK;
 lsmeans RES_UNITS SAFE_RANK/ adjust=tukey cl;
run;

*4;
proc sgplot data=bkhomes;
 scatter y = SALE_PRICE x = GROSS_SQ_FT;
run;

proc reg data=bkhomes plots=diagnostics;
 model SALE_PRICE = GROSS_SQ_FT;
run;

*5;
proc sgplot data=bkhomes;
 scatter y = SALE_PRICE x = SAFE_RANK;
run;

proc reg data=bkhomes plots=diagnostics;
 model SALE_PRICE = SAFE_RANK;
run;

*7;
proc reg data=bkhomes plots=diagnostics;
 model SALE_PRICE = SAFE_RANK MED_INCOME TOT_UNITS--YEAR_BUILT / VIF;
run;

*9;
proc reg data = bkhomes;
 model SALE_PRICE = SAFE_RANK MED_INCOME TOT_UNITS--YEAR_BUILT / selection = f sle=0.05;
run;

proc reg data = bkhomes outest= bkhomes_2;
 model SALE_PRICE = SAFE_RANK MED_INCOME TOT_UNITS--YEAR_BUILT / selection = adjrsq aic;
run;

proc sort data = bkhomes_2;
 by _aic_ _rsq_;
run;

proc print data = bkhomes_2;
run;

proc reg data=bkhomes plots=diagnostics;
 model SALE_PRICE = SAFE_RANK MED_INCOME TOT_UNITS GROSS_SQ_FT YEAR_BUILT;
run;