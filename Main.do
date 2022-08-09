do Support

********************************************************************
********************************************************************
*Regressions

**** Specification (1)

*Model 1 - No controls
reg SDR dcgr degr dcgrE degrC, vce(cluster id)

testparm dcgrE degrC, equal //H4

*Model 2 - No controls
reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC, vce(cluster id)

testparm dtimec dtimee, equal //H1
//p-value on dtimeec //H2
testparm dtimec dtimee dtimece dtimeec, equal //H3
testparm dcgrE degrC, equal //H4

**** Specification (2)

*Model 1 - Controlling only for microscopic preference
reg SDR dcgr degr dcgrE degrC if micro==0, vce(cluster id)

testparm dcgrE degrC, equal //H4

*Model 2 - Controlling only for microscopic preference
reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC if micro==0, vce(cluster id)

testparm dtimec dtimee, equal //H1
//p-value on dtimeec //H2
testparm dtimec dtimee dtimece dtimeec, equal //H3
testparm dcgrE degrC, equal //H4

**** Specification (3)

*Model 1 - Controlling for all plausibility tests, attention checks & time
reg SDR dcgr degr dcgrE degrC if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)

testparm dcgrE degrC, equal //H4

*Model 2 - Controlling for all plausibility tests, attention checks & time
reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)

testparm dtimec dtimee, equal //H1
//p-value on dtimeec //H2
testparm dtimec dtimee dtimece dtimeec, equal //H3
testparm dcgrE degrC, equal //H4

**** Specification (4)

*Model 1 - Controlling for plausability, attention checks, time & socio-econonmic vars
reg SDR dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)

testparm dcgrE degrC, equal //H4

*Model 2 - Controlling for plausability, attention checks, time & socio-econonmic vars
reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)

testparm dtimec dtimee, equal //H1
//p-value on dtimeec //H2
testparm dtimec dtimee dtimece dtimeec, equal //H3
testparm dcgrE degrC, equal //H4

**** Specification (5)

*Model 1 - Previous regression but only including individuals who are never irrational
reg SDR dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0 & anyplaus==0, vce(cluster id)

testparm dcgrE degrC, equal //H4

*Model 2 - Previous regression but only including individuals who are never irrational
reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0 & anyplaus==0, vce(cluster id)

testparm dtimec dtimee, equal //H1
//p-value on dtimeec //H2
testparm dtimec dtimee dtimece dtimeec, equal //H3
testparm dcgrE degrC, equal //H4

**************************************************************
**************************************************************
*Tables & Figures - Note: Additional manual editing necesarry to arrive at paper version

*Figure 1 - Example CES Function
graph twoway (function y=(x^(0.3))/(0.3)), xtitle("{stSerif: Consumption}") ytitle("{stSerif: Utility}") graphregion(color(white)) bgcolor(white) xla(, format(%2.1f)) yla(, nogrid)

graph export CRRAexample.emf

*Table 1 - Summary Statistics (SDR, time, micro, equal, switch, anyplaus, anyattc)
outreg2 using sumstat, word sum(log) keep(SDR time micro equal switch anyplaus anyattc) eqkeep(mean sd min max) label replace

*Table 2 - Main Regressions
reg SDR dcgr degr dcgrE degrC, vce(cluster id)
outreg2 using mainreg, word replace 

reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC, vce(cluster id)
outreg2 using mainreg, word keep(dtimec dtimee dtimeec dcgr degr dcgrE degrC)

reg SDR dcgr degr dcgrE degrC if micro==0, vce(cluster id)
outreg2 using mainreg, word

reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC if micro==0, vce(cluster id)
outreg2 using mainreg, word keep(dtimec dtimee dtimeec dcgr degr dcgrE degrC)

reg SDR dcgr degr dcgrE degrC if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)
outreg2 using mainreg, word

reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)
outreg2 using mainreg, word keep(dtimec dtimee dtimeec dcgr degr dcgrE degrC)

*Table 3 - Robustness Checks
reg SDR dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)
outreg2 using robtests, word keep(dcgr degr dcgrE degrC) replace 

reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0, vce(cluster id)
outreg2 using robtests, word keep(dtimec dtimee dtimeec dcgr degr dcgrE degrC)

reg SDR dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0 & anyplaus==0, vce(cluster id)
outreg2 using robtests, word keep(dcgr degr dcgrE degrC)

reg SDR dtimec dtimee o.dtimece dtimeec dcgr degr dcgrE degrC i.parinc i.pareduc i.gender i.age i.pol if micro==0 & equal==0 & switch==0 & time>=600 & anyattc==0 & anyplaus==0, vce(cluster id)
outreg2 using robtests, word keep(dtimec dtimee dtimeec dcgr degr dcgrE degrC)