/* Program to Create Figures 1 to 4 */

version 9.2
# delimit;
clear;
set more off;
set mem 200m;
capture log close;
log using Figure_1-4_Followup.log, replace text;

/******
** WORKING DIRECTORY
******/

* WRITE THE THE LOCALLY-WEIGHTED REGRESSION PROGRAM CODE ;
* PROGRAM ARGUMENTS: (1) YVAR (2) XVAR (3) OUTPUT-ESTIMATE (4) OUTPUT-DERIVATIVE (5) BANDWIDTH (6) X-VALUES FOR ESTIMATING FUNCTION
                     *(7) DUMMY VARIABLE FOR WHICH OBSERVATIONS ARE USED TO ESTIMATE THE FUNCTION;
* NOTE: MUST HAVE GLOBAL VARIABLE GSIZE CONTAINING THE NUMBER OF VALUES AT WHICH FUNCTION SHOULD BE ESTIMATED;
        cap program drop lowrex;
        program def lowrex;
                local ic=1;
                qui gen `3'=.;
                qui gen `4'=.;
                while `ic' <= $gsize {;
                dis `ic';
                local xx=`6'[`ic'];
                qui gen z=abs((`2'-`xx')/`5');
                qui gen kz=(3/4)*(1-z^2)/`5' if z <= 1;
                qui gen x_mod = (`2'-`xx')*(kz^0.5);
                qui gen const_mod = kz^0.5;
                qui gen y_mod = (`1')*(kz^0.5);
                qui reg y_mod const_mod x_mod if kz ~= . & `7', noconstant;
                qui replace `4'=_b[x_mod] in `ic';
                qui replace `3'=_b[const_mod] in `ic';
                drop z kz x_mod y_mod const_mod;
                local ic=`ic'+1;
                };
        end;

/*****
*** LOAD AND FORMAT VARIABlES
*****/

/*****
** CREATE THE TABLE;
*****/
 
use "Public_Data_AEJApp_2010-0132.dta";
drop if suba == 1 & grade < 9;

drop if grade == 11;


* SET BANDWIDTH;
        global h=0.075;
        global d_h = $h/2;

        global h2=100;
        global d_h2 = $h2/2;

* SET GRID SIZE;
        global gsize=200;

* SET THE RANGE OVER WHICH X SHOULD MOVE;
        global xmin= 0.2;
        global xmax= 0.95;
        global st1=($xmax-$xmin)/($gsize-1);
        gen xgrid1=$xmin+(_n-1)*$st1 in 1/$gsize;

        global xmin2= 0;
        global xmax2= 650;
        global st2=($xmax2-$xmin2)/($gsize-1);
        gen xgrid2=$xmin2+(_n-1)*$st2 in 1/$gsize;

gen in_range = .;


*Enrollment -- baseline;
replace in_range = control == 1 & suba == 0 & m_enrolled ~= . & grade < 11;
quietly lowrex m_enrolled en_baseline en_control den_control $h xgrid1 in_range;

replace in_range = T1_treat == 1 & suba == 0 & m_enrolled ~= . & grade < 11;
quietly lowrex m_enrolled en_baseline en_treat1 den_treat1 $h xgrid1 in_range;

replace in_range = T2_treat == 1 & suba == 0 & m_enrolled ~= . & grade < 11;
quietly lowrex m_enrolled en_baseline en_treat2 den_treat2 $h xgrid1 in_range;

* PLOT;
twoway (line en_control xgrid1, clpattern(shortdash))
       (line en_treat1 xgrid1, clpattern(longdash))
       (line en_treat2 xgrid1, clpattern(solid)),
       ytitle("Enrollment")
       ylabel(0.2(.1)1, labsize(small))
       ylabel(, tposition(inside) nogrid)
       xtitle("Predicted Enrollment") 
       xlabel(0.2(.1)1.0)
       xlabel(, tposition(inside) nogrid)
       graphregion(color(white))
       legend(order(1 2 3) label(1 "Control") label(2 "Basic Treatment") label(3 "Savings Treatment"))
       note("Note: Results from local polynomial regressions (bandwidth=0$h)")
       saving("Figure_2_Followup_EnByPred", asis replace)
       scheme(sj);

drop en_control den_control en_treat* den_treat*;

replace in_range = control == 1 & suba == 1 & m_enrolled ~= . & grade < 11;
quietly lowrex m_enrolled en_baseline en_control den_control $h xgrid1 in_range;

replace in_range = T3_treat == 1 & suba == 1 & m_enrolled ~= . & grade < 11;
quietly lowrex m_enrolled en_baseline en_treat3 den_treat3 $h xgrid1 in_range;

* PLOT;
twoway (line en_control xgrid1, clpattern(shortdash))
       (line en_treat3 xgrid1, clpattern(solid)),
       ytitle("Enrollment")
       ylabel(0.2(.1)1, labsize(small))
       ylabel(, tposition(inside) nogrid)
       xtitle("Predicted Enrollment") 
       xlabel(0.2(.1)1.0)
       xlabel(, tposition(inside) nogrid)
       graphregion(color(white))
       legend(order(1 2) label(1 "Control") label(2 "Tertiary Treatment"))
       note("Note: Results from local polynomial regressions (bandwidth=0$h)")
       saving("Figure_4_Followup_EnByPred", asis replace)
       scheme(sj);

drop en_control den_control en_treat* den_treat*;

keep if survey_selected;

*ATTENDANCE;
* SET BANDWIDTH;
        global h=0.075;
        global d_h = $h/2;
        global h2= 100;
        global d_h2 = $h2/2;

* SET GRID SIZE;
        global gsize=200;

* SET THE RANGE OVER WHICH X SHOULD MOVE;
        global xmin= 0.65;
        global xmax= 0.9;
        global st1=($xmax-$xmin)/($gsize-1);
        replace xgrid1= .;
        replace xgrid1=$xmin+(_n-1)*$st1 in 1/$gsize;

        global xmin2= 0;
        global xmax2= 650;
        global st2=($xmax2-$xmin2)/($gsize-1);
        replace xgrid2= .;
        replace xgrid2=$xmin2+(_n-1)*$st2 in 1/$gsize;

*Attendance -- Baseline;
replace in_range = control == 1 & suba == 0;
quietly lowrex at_msamean at_baseline attend_control dattend_control $h xgrid1 in_range;

replace in_range = T1_treat == 1 & suba == 0;
quietly lowrex at_msamean at_baseline attend_treat1 dattend_treat1 $h xgrid1 in_range;

replace in_range = T2_treat == 1 & suba == 0;
quietly lowrex at_msamean at_baseline attend_treat2 dattend_treat2 $h xgrid1 in_range;

* PLOT;
twoway (line attend_control xgrid1, clpattern(shortdash))
       (line attend_treat1 xgrid1, clpattern(longdash))
       (line attend_treat2 xgrid1, clpattern(solid)),
       ytitle("Actual Attendance")
       ylabel(0.5(.1)1, labsize(small))
       ylabel(, tposition(inside) nogrid)
       xtitle("Predicted Baseline Attendance") 
       xlabel(0.65(.05)0.9)
       xlabel(, tposition(inside) nogrid)
       graphregion(color(white))
       legend(order(1 2 3) label(1 "Control") label(2 "Basic Treatment") label(3 "Savings Treatment"))
       note("Note: Results from local polynomial regressions (bandwidth=0$h)")
       saving("Figure_1_Followup_AttByPred", asis replace)
       scheme(sj);

drop attend_control dattend_control attend_treat* dattend_treat*;

replace in_range = control == 1 & suba == 1;
quietly lowrex at_msamean at_baseline attend_control dattend_control $h xgrid1 in_range;

replace in_range = T3_treat == 1 & suba == 1;
quietly lowrex at_msamean at_baseline attend_treat3 dattend_treat3 $h xgrid1 in_range;

* PLOT;
twoway (line attend_control xgrid1, clpattern(shortdash))
       (line attend_treat3 xgrid1, clpattern(solid)),
       ytitle("Actual Attendance")
       ylabel(0.5(.1)1, labsize(small))
       ylabel(, tposition(inside) nogrid)
       xtitle("Predicted Baseline Attendance") 
       xlabel(0.65(.05)0.9)
       xlabel(, tposition(inside) nogrid)
       graphregion(color(white))
       legend(order(1 2) label(1 "Control") label(2 "Tertiary Treatment"))
       note("Note: Results from local polynomial regressions (bandwidth=0$h)")
       saving("Figure_3_Followup_AttByPred", asis replace)
       scheme(sj);


log close;
