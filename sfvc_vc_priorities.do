*Strategic
**Priorities for action
quietly{
use "sfvc_data.dta", clear
rename scopes_scopetypes scope
replace scope = scope[_n-1] if missing(scope)
encode selectedpriorities_keyword, generate(priority_num)
}
	tab selectedpriorities_keyword
	bysort scope: tab selectedpriorities_keyword
quietly{
graph hbar (percent) priority_num, over(selectedpriorities_keyword) blabel(bar, format(%3.1f)) ytitle("Percentage of total", size(medium) height(5)) ///
							ylabel(, labsize(vsmall)) ///
							ylabel(#7) ///
							ymtick(##10)
}

quietly{
gen value=.
replace value = 1 if regexm(selectedpriorities_keyword, "P1")
replace value = 1 if regexm(selectedpriorities_keyword, "P2")
replace value = 1 if regexm(selectedpriorities_keyword, "P3")
replace value = 1 if regexm(selectedpriorities_keyword, "P4")
bysort selectedpriorities_keyword: egen total=total(value)
by selectedpriorities_keyword:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup
encode selectedpriorities_keyword, gen(f)
keep total f
order f
egen t=total(total)
gen per=(total/t)*100
replace per=round(per, 0.1)
gen per2=string(100 * total/t, "%8.1f") + "%"


		graph twoway (bar total f if f==1, bcolor("193 9 45") barwidth(0.7) ///
								yaxis(1) yscale(range(0) axis(1)) ///
								ytitle("Percentage of total", size(medium) height(5)) ///
								ylabel(#7) ylabel(, labsize(small)) ///
								ymtick(##10) ///
								xtitle("Sendai Priorities for Action", size(medium) height(5)) ///
								xlabel(, angle(vertical) labsize(large)) ///
								xlabel(#15) ///
								xlabel(1 "Priority 1" 2 "Priority 2" 3 "Priority 3" 4 "Priority 4") ///
								xlabel(, angle(horizontal) labsize(small) notick)) ///
								(bar total f if f==2, bcolor("235 117 42") barwidth(0.7)) ///
								(bar total f if f==3, bcolor("150 41 135") barwidth(0.7)) ///
								(bar total f if f==4, bcolor("0 175 174") barwidth(0.7)) ///
								(scatter total f if f==1 | f==2 | f==3 | f==4, ///
								msym(none) mlab(per2) mlabposition(0.8) mlabcolor(black) mlabsize(small) mlabangle(hor) legend(off) yaxis(1))
*								(scatter total f if f==1 | f==2 | f==3 | f==4 | f==5, ///
*								msym(none) mlab(per2) mlabposition(4) mlabcolor(black) mlabsize(small) mlabangle(hor) legend(off))
graph export "Q:\1_SFVC\7_SFVC_Analysis\3_Reports\SFVC_Analysis_code\Others\Reports\Children_youth\1_priorities.png", as(png) replace
}
