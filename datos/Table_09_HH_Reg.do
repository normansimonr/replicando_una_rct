/* Program to Create Table_09: Effects of Treatment on Siblings using Monitored and Administrative Participation,
Households with two registered children */

version 9.2
# delimit;
clear;
set more off;
set mem 200m;
capture log close;
log using Table_09_HH_Reg.log, replace text;

/*****
*** LOAD AND FORMAT VARIABlES
*****/

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
   replace `obj_var' = "<" + string(`point_sd', "$strformat") + ">" + " " if `row_id_var' == `row_num' + 1;
   end;

/*****
** CREAT THE TABLE;
*****/
 
use "Public_Data_AEJApp_2010-0132.dta";

keep if fu_observed == 1;
drop if grade == 11;

bysort fu_nim_hogar: gen num_rsib = _N;
replace num_rsib = . if fu_nim_hogar == .;
tab num_rsib;
keep if num_rsib == 2;

bysort fu_nim_hogar: gen tsib = treatment[2] if _n == 1;
bysort fu_nim_hogar: replace tsib = treatment[1] if _n == 2;
bysort fu_nim_hogar: egen num_tsib = sum(treatment);

drop if suba == 1 & grade < 9;

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma replace;
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;

xi: reg at_msamean treatment suba $varbaseline i.school_code if num_tsib == 1, cluster(school_code);
outreg treatment using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;
xi: reg m_enrolled treatment suba $varbaseline i.school_code if num_tsib == 1, cluster(school_code);
outreg treatment using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 0, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 0, cluster(school_code);
outreg tsib using "Table_09_HH_Reg.csv", 3aster coefastr se comma append;

*Not in table but in foot notes;
bysort fu_nim_hogar: gen msib = s_sexo[1] == 1 if _n == 2;
bysort fu_nim_hogar: replace msib = s_sexo[2] == 1 if _n == 1;
gen mixed = s_sexo ~= msib;
gen tsib_mixed = tsib * mixed;

xi: reg at_msamean tsib tsib_mixed mixed suba $varbaseline i.school_code if control == 1, cluster(school_code);
xi: reg m_enrolled tsib tsib_mixed mixed suba $varbaseline i.school_code if control == 1, cluster(school_code);

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0 & mixed == 1, cluster(school_code);
xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0 & mixed == 0, cluster(school_code);
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0 & mixed == 1, cluster(school_code);
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 0 & mixed == 0, cluster(school_code);

xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1 & mixed == 1, cluster(school_code);
xi: reg at_msamean tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1 & mixed == 0, cluster(school_code);
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1 & mixed == 1, cluster(school_code);
xi: reg m_enrolled tsib suba $varbaseline i.school_code if control == 1 & s_sexo == 1 & mixed == 0, cluster(school_code);

log close;
