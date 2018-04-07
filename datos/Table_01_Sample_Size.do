version 9.2
# delimit;
clear;
set more off;
set mem 200m;
capture log close;
log using Table_01_Sample_Size.log, replace text;

/*****
** CREAT THE TABLE;
*****/

use "Public_Data_AEJApp_2010-0132";
drop if suba == 1 & grade < 9;

gen category1 = 0;
replace category1 = 1 if grade > 8 & grade < 11;
replace category1 = 2 if grade == 11;
gen category2 = r_be_gene == "F";

*Create Research Groups;
gen group = 1;
replace group = 2 if ~suba & T1_treat;
replace group = 3 if ~suba & T2_treat;
replace group = 4 if suba & control;
replace group = 5 if suba & treatment;

*All Students;
tab category1 group;
tab category2 group;

*Students in selected schools;
tab category1 group if survey_selected;
tab category2 group if survey_selected;

*Students giving baseline survey;
tab category1 group if bl_observed;
tab category2 group if bl_observed;

log close;
