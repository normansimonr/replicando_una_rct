/* Program to Create Table_08: Effects of Transfers on Academic Effort, Consumption, and Labor Activities */

version 9.2
# delimit;
clear;
set more off;
set mem 200m;
capture log close;
log using Table_08_Followup_Survey.log, replace text;

/*****
*** LOAD AND FORMAT VARIABlES
*****/

global labor_new "fu_primary_study fu_primary_work fu_primary_home fu_hrs_last_wwk fu_earn_last_wwk";
global varbaseline "i.s_teneviv s_utilities s_durables s_infraest_hh s_age_sorteo s_age_sorteo2 s_years_back s_sexo i.s_estcivil s_single s_edadhead s_yrshead s_tpersona s_num18 i.s_estrato s_puntaje s_ingtotal i.grade suba s_over_age";

/*****
** FORMATTING VARIABLES AND PROGRAMS
*****/

global strformat "%8.3f";

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
   replace `obj_var' = "<"+string(`point_sd', "$strformat") + ">" if `row_id_var' == `row_num' + 1;
   end;

/*****
** CREATE THE TABLE;
*****/

use "Public_Data_AEJApp_2010-0132.dta";
drop if suba == 1 & grade < 9;

forvalues i = 1(1)9 {;
   gen str col`i' = "";
   };
gen row_num = _n;

local cur_row = 1;


*LABOR FOR STUDENTS 6-10;

global condition "survey_selected & fu_observed & grade < 11";
foreach var in $labor_new {;
   replace col1 = "`var'" if row_num == `cur_row';

   reg `var' if control & ~suba & $condition;
   replace col2 = string(_b[_cons], "$strformat") if row_num == `cur_row';
   replace col2 = "<" + string(_se[_cons], "$strformat") + ">" if row_num == `cur_row' + 1;

   xi: reg `var' T1_treat T2_treat $varbaseline i.school_code if ~suba & $condition, cluster(school_code);
   sig col3 _b[T1_treat] _se[T1_treat] row_num `cur_row';
   sig col4 _b[T2_treat] _se[T2_treat] row_num `cur_row';

   test T1_treat == T2_treat;

   reg `var' if control & suba & grade > 8 & $condition;
   replace col5 = string(_b[_cons], "$strformat") if row_num == `cur_row';
   replace col5 = "<" + string(_se[_cons], "$strformat") + ">" if row_num == `cur_row' + 1;

   xi: reg `var' T3_treat $varbaseline i.school_code if suba & grade > 8 & $condition, cluster(school_code);
   sig col6 _b[T3_treat] _se[T3_treat] row_num `cur_row';

   local cur_row = `cur_row' + 2;

   disp("row `cur_row'");
   };

*LABOR FOR STUDENTS 11;

global condition "survey_selected & fu_observed & grade == 11";
foreach var in $labor_new {;
   replace col1 = "`var'" if row_num == `cur_row';

   reg `var' if control & ~suba & $condition;
   replace col2 = string(_b[_cons], "$strformat") if row_num == `cur_row';
   replace col2 = "<" + string(_se[_cons], "$strformat") + ">" if row_num == `cur_row' + 1;

   xi: reg `var' T1_treat T2_treat $varbaseline i.school_code if ~suba & $condition, cluster(school_code);
   sig col3 _b[T1_treat] _se[T1_treat] row_num `cur_row';
   sig col4 _b[T2_treat] _se[T2_treat] row_num `cur_row';

   test T1_treat == T2_treat;

   reg `var' if control & suba & grade > 8 & $condition;
   replace col5 = string(_b[_cons], "$strformat") if row_num == `cur_row';
   replace col5 = "<" + string(_se[_cons], "$strformat") + ">" if row_num == `cur_row' + 1;

   xi: reg `var' T3_treat $varbaseline i.school_code if suba & grade > 8 & $condition, cluster(school_code);
   sig col6 _b[T3_treat] _se[T3_treat] row_num `cur_row';

   local cur_row = `cur_row' + 2;

   disp("row `cur_row'");
   };


sort row_num;
outsheet col* using "Table_08_Followup_Survey.csv" if row_num < `cur_row', replace comma;

log close;
