/* Program to Create Table_05: Variation in the Basic and Savings Treatment Effects, Basic-Savings Experiment */

version 9.2
clear
#delimit ;
set mem 200m;
set more off;
capture log close;
log using Table_05_Heterogeneity.log, replace text;

/*****
*** LOAD AND FORMAT VARIABlES
*****/

*Note that s_sexo is not in this set because girl is used as an interaction variable.  So, it is included seperately in each regression;
global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age";

/*****
** Table Variables
*****/

global strformatsmall "%9.2f";
global strformatbig "%9.4f";
global strformat "%9.2f";

capture program drop sig;
program sig;
   args obj_var point_est_var point_sd_var row_id_var row_num;
   local point_est `point_est_var';
   local point_sd `point_sd_var';
   local t_stat abs(`point_est'/`point_sd');
   if `t_stat' < 1.645 {;
      replace `obj_var' = string(`point_est', "$strformat") if `row_id_var' == `row_num';
      };
   if `t_stat' >= 1.645 & `t_stat' < 1.96 {;
      replace `obj_var' = string(`point_est', "$strformat")+"*" if `row_id_var' == `row_num';
      };
   if `t_stat' >= 1.96 & `t_stat' < 2.576 {;
      replace `obj_var' = string(`point_est', "$strformat")+"**" if `row_id_var' == `row_num';
      };
   if `t_stat' >= 2.576 {;
      replace `obj_var' = string(`point_est', "$strformat")+"***" if `row_id_var' == `row_num';
      };
   replace `obj_var' = "<" + string(`point_sd', "$strformat") + ">" + " " if `row_id_var' == `row_num' + 1;
   end;

/*****
*** Table
*****/

use "Public_Data_AEJApp_2010-0132.dta";
drop if suba == 1 & grade < 9;
drop if grade > 10;

*Create interaction terms;
gen girl = s_sexo == 0;
gen boy = girl == 0;

*Second income tercile starts at 380,000 pesos a month;
gen inc_380 = s_ingtotal <= 380;
gen T1_inc_380 = T1_treat * inc_380;
gen T2_inc_380 = T2_treat * inc_380;

gen pen = en_baseline;
gen patt = at_baseline;

foreach var in survey_selected girl pen patt {;
   gen T1_treat_`var' = T1_treat * `var';
   gen T2_treat_`var' = T2_treat * `var';
   gen T3_treat_`var' = T3_treat * `var';
   };

*** San Cristobal;

*Formatting Regression;
xi: reg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl T1_inc_380 T2_inc_380 inc_380 T1_treat_pen T2_treat_pen T1_treat_patt T2_treat_patt $varbaseline if suba == 0 & grade < 11, cluster(school_code);
outreg T1_treat T2_treat T1_treat_girl T2_treat_girl girl T1_inc_380 T2_inc_380 inc_380 T1_treat_pen T2_treat_pen T1_treat_patt T2_treat_patt using "Table_05_Heterogeneity.csv", 3aster coefastr se comma replace;

*Gender;
xi: reg at_msamean T1_treat T2_treat T1_treat_girl T2_treat_girl girl $varbaseline i.school_code if suba == 0 & survey_selected == 1, cluster(school_code);
outreg T1_treat T2_treat  T1_treat_girl T2_treat_girl girl using "Table_05_Heterogeneity.csv", 3aster coefastr se comma append;
test T1_treat == T2_treat;
test T1_treat + T1_treat_girl == T2_treat + T2_treat_girl;
xi: reg m_enrolled T1_treat T2_treat T1_treat_girl T2_treat_girl girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code);
outreg T1_treat T2_treat  T1_treat_girl T2_treat_girl girl using "Table_05_Heterogeneity.csv", 3aster coefastr se comma append;

gen T1_treat_boy = T1_treat * boy;
gen T2_treat_boy = T2_treat * boy;
xi: reg at_msamean T1_treat T2_treat T1_treat_boy T2_treat_boy boy $varbaseline i.school_code if suba == 0 & survey_selected == 1 & girl == 1, cluster(school_code);
xi: reg m_enrolled T1_treat T2_treat T1_treat_boy T2_treat_boy boy $varbaseline i.school_code if suba == 0 & grade < 11 & girl == 1, cluster(school_code);

*Income;
xi: reg at_msamean T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl $varbaseline i.school_code if suba == 0 & survey_selected == 1, cluster(school_code);
test T1_treat == T2_treat;
test T1_treat + T1_inc_380 == T2_treat + T2_inc_380;
test T1_treat + T1_inc_380 == 0;
test T2_treat + T2_inc_380 == 0;
outreg T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 using "Table_05_Heterogeneity.csv", 3aster coefastr se comma append;
xi: reg m_enrolled T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code);
test T1_treat == T2_treat;
test T1_treat + T1_inc_380 == T2_treat + T2_inc_380;
test T1_treat + T1_inc_380 == 0;
test T2_treat + T2_inc_380 == 0;
outreg T1_treat T2_treat T1_inc_380 T2_inc_380 inc_380 using "Table_05_Heterogeneity.csv", 3aster coefastr se comma append;

*High Low Predictions;
xi: reg at_msamean T1_treat T2_treat T1_treat_patt T2_treat_patt girl $varbaseline i.school_code if suba == 0 & survey_selected == 1, cluster(school_code);
outreg T1_treat T2_treat T1_treat_patt T2_treat_patt using "Table_05_Heterogeneity.csv", 3aster coefastr se comma append;
test T1_treat == T2_treat;
test T1_treat_patt == T2_treat_patt;
xi: reg m_enrolled T1_treat T2_treat T1_treat_pen T2_treat_pen girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code);
outreg T1_treat T2_treat T1_treat_pen T2_treat_pen using "Table_05_Heterogeneity.csv", 3aster coefastr se comma append;
test T1_treat == T2_treat;
test T1_treat_pen == T2_treat_pen;

*** Test for differences in enrollment rates for lower income families;
*** Note 67.3 percent of the sample has income less than 400,000 pesos a month;
gen inc_400 = s_ingtotal < 400;
gen inc_n400 = s_ingtotal >= 400;
gen T2_inc_400 = T2_treat * inc_400;
gen T2_inc_n400 = T2_treat * inc_n400;
gen T1_inc_400 = T1_treat * inc_400;

xi: reg m_enrolled T2_inc_n400 T2_inc_400 inc_400 girl $varbaseline i.school_code if suba == 0 & grade < 11 & (T1_treat == 1 | T2_treat == 1), cluster(school_code);
su m_enrolled if suba == 0 & grade < 11 & T1_treat == 1 & inc_400 == 1;
su m_enrolled if suba == 0 & grade < 11 & T1_treat == 1 & inc_400 == 0;

xi: reg m_enrolled T1_treat T2_treat T1_inc_400 T2_inc_400 inc_400 girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code);
test T1_inc_400 + T1_treat == T2_treat + T2_inc_400;

*** Test for differences in enrollment rates for low predicted enrollment;
*** Note 13.2 percent of the sample has enrollment rates below 40 percentage points;
gen en_4 = en_baseline < 0.4;
gen en_n4 = en_baseline >= 0.4;
gen T2_en_400 = T2_treat * en_4;
gen T2_en_n400 = T2_treat * en_n4;
gen T1_en_400 = T1_treat * en_4;

xi: reg m_enrolled T2_en_n4 T2_en_4 en_4 girl $varbaseline i.school_code if suba == 0 & grade < 11 & (T1_treat == 1 | T2_treat == 1), cluster(school_code);
su m_enrolled if suba == 0 & grade < 11 & T1_treat == 1 & en_4 == 1;
su m_enrolled if suba == 0 & grade < 11 & T1_treat == 1 & en_n4 == 0;

xi: reg m_enrolled T1_treat T2_treat T1_en_4 T2_en_4 en_4 girl $varbaseline i.school_code if suba == 0 & grade < 11, cluster(school_code);
test T1_en_4 + T1_treat == T2_treat + T2_en_4;
test T1_treat == T2_treat;

log close;

