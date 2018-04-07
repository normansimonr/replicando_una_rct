/* Program to Create Appendix A3: Comparison of Students Completing Baseline Survey */

version 9.2
clear
#delimit ;
set mem 200m;
set more off;
capture log close;
log using Table_A3_Baseline_Comparison_Survey.log, replace text;

/*****
*** LOAD AND FORMAT VARIABlES
*****/

global varbaseline "s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_sexo s_yrs s_single s_edadhead s_yrshead s_tpersona s_num18 s_estrato s_puntaje s_ingtotal";

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

*Drop students not giving baseline survey;
keep if bl_observed == 1 & survey_selected == 1;

*Generate Table Variables;
gen row_num = _n;
gen str30 col0 = "";
forvalues i = 1(1)10 {;
   gen str20 col`i' = "";
   };

*Means and Regressions;

local row = -1;
foreach var in $varbaseline {;
   disp "`var'";
   local row = `row' + 2;
   replace col0 = "`var'" if row_num == `row';

   sum `var' if ~suba & control;
   replace col1 = string(r(mean), "$strformat") if row_num == `row';
   replace col1 = "<" + string(r(sd), "$strformat") + ">" + " " if row_num == `row'+1;
   reg `var' T1_treat T2_treat if suba == 0, cluster(school_code);
   sig col2 _b[T1_treat] _se[T1_treat] row_num `row';
   sig col3 _b[T2_treat] _se[T2_treat] row_num `row';
   reg `var' T1_treat control if suba == 0, cluster(school_code);
   sig col4 _b[T1_treat] _se[T1_treat] row_num `row';

   sum `var' if suba & T3_control;
   replace col6 = string(r(mean), "$strformat") if row_num == `row';
   replace col6 = "<" + string(r(sd), "$strformat") + ">" + " "  if row_num == `row'+1;
   reg `var' T3_treat if suba == 1, cluster(school_code);
   sig col7 _b[T3_treat] _se[T3_treat] row_num `row';
   };

sort row_num;
outsheet col0 col1-col8 using Table_A3_Baseline_Comparison_Survey.csv if _n <= `row'+1, replace comma;
log close;
