*************************************************
*Load Data & Drop Variables / Clean Missing
clear *
import excel crosselast, firstrow
format %24s *
drop if StartDate=="Start Date"
drop if ConsentCheck==""
drop if ProlificID==""
drop  AttentionCheck1_2 AttentionCheck2_2 FreeFeedback ResponseId PROLIFIC_PID InequalityTut InequalityPt2 IntertemporalTut Screener LocationLatitude LocationLongitude DistributionChannel ProlificID  UserLanguage ConsentCheck StartDate EndDate Status IPAddress Finished RecordedDate Progress RecipientLastName RecipientFirstName RecipientEmail ExternalReference
gen ID=_n
order AttentionCheck*, last
order ID, first
*************************************************

*************************************************
*Draft Discount Rates
foreach i of varlist CTO01_1-ECG10_2 { //
    if strpos("`i'", "_2")>0 {
        drop `i'
    }
    if strpos("`i'", "_1")>0 & strpos("`i'", "01")>0 & strpos("`i'", "C")==1{
        gen tempc=34.53877639 if `i'=="On"
         tostring tempc, replace force
                replace `i'= tempc
                destring `i', replace 
                drop tempc
    }
	 if strpos("`i'", "_1")>0 & strpos("`i'", "01")>0 & strpos("`i'", "E")==1{
        gen tempc=55.88026574 if `i'=="On"
         tostring tempc, replace force
                replace `i'= tempc
                destring `i', replace 
                drop tempc
    }
    if strpos("`i'", "_1")>0 & strpos("`i'", "10")>0{
        gen tempc=-99 if `i'=="Off"
         tostring tempc, replace force
                replace `i'= tempc
                destring `i', replace
                replace `i' = 0.2564664719 if missing(`i')
                drop tempc
    }
    if strpos("`i'", "1_1")>0 & strpos("`i'", "01")==0 & strpos("`i'", "E")==1{
        gen tempc=14.97796114 if `i'=="On"
         tostring tempc, replace force
                replace `i'= tempc
                destring `i', replace 
                drop tempc     
    }      
    if strpos("`i'", "1_1")>0 & strpos("`i'", "01")==0 & strpos("`i'", "C")==1{
        gen tempc=14.92890971 if `i'=="On"
         tostring tempc, replace force
                replace `i'= tempc
                destring `i', replace 
                drop tempc     
    }              
    if strpos("`i'", "_1")>0 & strpos("`i'", "01")==0 & strpos("`i'", "10")==0 {
        forvalues x = 2(1)9 {
            if strpos("`i'", "`x'")<length("`i'") & strpos("`i'", "`x'") != 1 & strpos("`i'", "`x'") != 0 {
                gen y=`x'-0.5
                gen tempc=100*0.05*ln(10/y) if `i'=="On"
                tostring tempc, replace force
                replace `i'= tempc
                destring `i', replace 
                drop tempc
                drop y
            }
        }
       
    }
}
*************************************************

*************************************************
*Multiple Switcher Dummies
gen switchCTO = 0
foreach x of varlist CTO01_1-CTO10_1 {
    replace `x' = 0 if missing(`x')
	replace switchCTO = `x' if `x' != switchCTO & switchCTO==0
	replace switchCTO = 1 if `x' <= 0 & switchCTO!=0 & switchCTO!=`x'
}
replace switchCTO=2 if switchCTO != 1

gen switchETO = 0
foreach x of varlist ETO01_1-ETO10_1 {
    replace `x' = 0 if missing(`x')
	replace switchETO = `x' if `x' != switchETO & switchETO==0
	replace switchETO = 1 if `x' <= 0 & switchETO!=0 & switchETO!=`x'
}
replace switchETO=2 if switchETO != 1

gen switchCETO = 0
foreach x of varlist CETO01_1-CETO10_1 {
    replace `x' = 0 if missing(`x')
	replace switchCETO = `x' if `x' != switchCETO & switchCETO==0
	replace switchCETO = 1 if `x' <= 0 & switchCETO!=0 & switchCETO!=`x'
}
replace switchCETO=2 if switchCETO != 1

gen switchCB = 0
foreach x of varlist CB01_1-CB10_1 {
    replace `x' = 0 if missing(`x')
	replace switchCB = `x' if `x' != switchCB & switchCB==0
	replace switchCB = 1 if `x' <= 0 & switchCB!=0 & switchCB!=`x'
}
replace switchCB=2 if switchCB != 1

gen switchCEG = 0
foreach x of varlist CEG01_1-CEG10_1 {
    replace `x' = 0 if missing(`x')
	replace switchCEG = `x' if `x' != switchCEG & switchCEG==0
	replace switchCEG = 1 if `x' <= 0 & switchCEG!=0 & switchCEG!=`x'
}
replace switchCEG=2 if switchCEG != 1

gen switchECTO = 0
foreach x of varlist ECTO01_1-ECTO10_1 {
    replace `x' = 0 if missing(`x')
	replace switchECTO = `x' if `x' != switchECTO & switchECTO==0
	replace switchECTO = 1 if `x' <= 0 & switchECTO!=0 & switchECTO!=`x'
}
replace switchECTO=2 if switchECTO != 1

gen switchEB = 0
foreach x of varlist EB01_1-EB10_1 {
    replace `x' = 0 if missing(`x')
	replace switchEB = `x' if `x' != switchEB & switchEB==0
	replace switchEB = 1 if `x' <= 0 & switchEB!=0 & switchEB!=`x'
}
replace switchEB=2 if switchEB != 1

gen switchECG = 0
foreach x of varlist ECG01_1-ECG10_1 {
    replace `x' = 0 if missing(`x')
	replace switchECG = `x' if `x' != switchECG & switchECG==0
	replace switchECG = 1 if `x' <= 0 & switchECG!=0 & switchECG!=`x'
}
replace switchECG=2 if switchECG != 1
*************************************************

*************************************************
*Rearrange Discount Rates Pt. 1
gen max_sdr = ""
gen CTO = 0
foreach x of varlist CTO01_1-CTO10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > CTO
    replace CTO = `x' if `x' > CTO
}
drop max_sdr
drop CTO1_1-CTO9_1

gen max_sdr = ""
gen ETO = 0
foreach x of varlist ETO01_1-ETO10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > ETO
    replace ETO = `x' if `x' > ETO
}
drop max_sdr
drop ETO1_1-ETO9_1

gen max_sdr = ""
gen CETO = 0
foreach x of varlist CETO01_1-CETO10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > CETO
    replace CETO = `x' if `x' > CETO
}
drop max_sdr
drop CETO1_1-CETO9_1

gen max_sdr = ""
gen CB = 0
foreach x of varlist CB01_1-CB10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > CB
    replace CB = `x' if `x' > CB
}
drop max_sdr
drop CB1_1-CB9_1

gen max_sdr = ""
gen CEG = 0
foreach x of varlist CEG01_1-CEG10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > CEG
    replace CEG = `x' if `x' > CEG
}
drop max_sdr
drop CEG1_1-CEG9_1

gen max_sdr = ""
gen ECTO = 0
foreach x of varlist ECTO01_1-ECTO10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > ECTO
    replace ECTO = `x' if `x' > ECTO
}
drop max_sdr
drop ECTO1_1-ECTO9_1

gen max_sdr = ""
gen EB = 0
foreach x of varlist EB01_1-EB10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > EB
    replace EB = `x' if `x' > EB
}
drop max_sdr
drop EB1_1-EB9_1

gen max_sdr = ""
gen ECG = 0
foreach x of varlist ECG01_1-ECG10_1 {
    replace `x' = 0 if missing(`x')
    replace max_sdr = "`x'" if `x' > ECG
    replace ECG = `x' if `x' > ECG
}
drop max_sdr
drop ECG1_1-ECG9_1
*************************************************

*************************************************
*Rearrange Discount Rates Pt. 2
local newob=8*_N
set obs `newob'
order Durationinseconds, before(Gender)
order ID, before(Durationinseconds)
tostring ID, replace
gen SDR=0

local varnames="id time gender age parinc pareduc pol conc1 conc2 conc3 conc4 conf1 conf2 conf3 conf4 compr1 compr2 compr3 compr4 compr5 compr6 rand attc1 attc2 attc3"

foreach var in `varnames'{
	generate `var'=""
}

gen switch=0
local countVar=0
foreach i of varlist switchCTO-switchECG{
    local countRow=1
    local countVar=`countVar'+1
    forvalues y = `countVar'(8)2584 {
        replace switch=`i'[`countRow'] if _n==`y'
        local countRow=`countRow'+1
    }
}
replace switch=0 if switch != 1
drop switchCTO-switchECG

local countVar=0
foreach i of varlist CTO-ECG{
    local countRow=1
    local countVar=`countVar'+1
    forvalues y = `countVar'(8)2584 {
        replace SDR=`i'[`countRow'] if _n==`y'
        local countRow=`countRow'+1
    }
}

local compar=0
local countVar=9
local countRow=1
local countVarmin1=0
foreach i of varlist ID-AttentionCheck3{
	local compar=0
	foreach j of varlist id-attc3{
		if `j'!="" | `compar'==1{
			continue
		}
		local countVar=9
		local countRow=1
		local countVarmin1=0
		forvalues y = `countVar'(8)2585 {
			replace `j'=`i'[`countRow'] if _n<`y' & _n>`countVarmin1'
			local countVarmin1=`countVarmin1'+8
			local countRow=`countRow'+1
		}
		local compar=`compar'+1
		continue
	}
}
destring id time, replace
drop ID-AttentionCheck3

order *10_1, first
order *01_1, first
format %24s rand

*************************************************

*************************************************
*Create Plausability Dummies
gen micro=0
local countVar=0
foreach i of varlist CTO01_1-ECG01_1{
    local countRow=1
    local countVar=`countVar'+1
    forvalues y = `countVar'(8)2584 {
        replace micro=`i'[`countRow'] if _n==`y'
        local countRow=`countRow'+1
    }
}
replace micro=1 if micro>33

gen equal=0
local countVar=0
foreach i of varlist CTO10_1-ECG10_1{
    local countRow=1
    local countVar=`countVar'+1
    forvalues y = `countVar'(8)2584 {
        replace equal=`i'[`countRow'] if _n==`y'
        local countRow=`countRow'+1
    }
}
replace equal=1 if equal==-99
replace equal=0 if equal!=1
order switch, last

drop CTO01_1-ECG10_1
drop CTO-ECG
*************************************************

*************************************************
*Generate Categorical Variables
la de cgender 1 "Male" 2 "Female" 3 "Non-binary / third gender" 4 "Prefer not to say"
la de cage 1 "18 - 20" 2 "21 - 25" 3 "26 or older" 4 "Prefer not to say"
la de cparinc 1 "£0 - £1.000" 2 "£1.001 - £2.000" 3 "£2.001 - £3.000" 4 "£3.001 - £4.000" 5 ">£4.000" 6 "I don't know / Prefer not to say"
la de cpareduc 1 "Did not finish Highschool" 2 "Highschool" 3 "Bachelor’s degree (or equivalent)" 4 "Master's degree (or equivalent) or above" 5 "I don't know / Prefer not to say"
la de cpol 1 "Far-Left" 2 "Left" 3 "Centre" 4 "Right" 5 "Far-Right" 6 "Other" 7 "I don't know / Prefer not to say"
la de cconc1 1 "Not at all" 2 "Not very much" 3 "Neither concerned nor unconcerned" 4 "Slightly" 5 "Very much"
la de cconc2 1 "Not at all" 2 "Not very much" 3 "Neither concerned nor unconcerned" 4 "Slightly" 5 "Very much"
la de cconc3 1 "Not at all" 2 "Not very much" 3 "Neither concerned nor unconcerned" 4 "Slightly" 5 "Very much"
la de cconc4 1 "Not at all" 2 "Not very much" 3 "Neither concerned nor unconcerned" 4 "Slightly" 5 "Very much"
la de cconf1 1 "No confidence" 2 "Little confidence" 3 "Neither confident nor unconfident" 4 "Some confidence" 5 "A lot of confidence"
la de cconf2 1 "No confidence" 2 "Little confidence" 3 "Neither confident nor unconfident" 4 "Some confidence" 5 "A lot of confidence"
la de cconf3 1 "No confidence" 2 "Little confidence" 3 "Neither confident nor unconfident" 4 "Some confidence" 5 "A lot of confidence"
la de cconf4 1 "No confidence" 2 "Little confidence" 3 "Neither confident nor unconfident" 4 "Some confidence" 5 "A lot of confidence"
la de ccompr1 1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"
la de ccompr2 1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"
la de ccompr3 1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"
la de ccompr4 1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"
la de ccompr5 1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"
la de ccompr6 1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"

foreach i of varlist gender-attc3{
    encode `i', generate(c`i') label(c`i')
    drop `i'
    rename c`i' `i'
}
*************************************************

*************************************************
*Generate Regression Dummies
local varnames="dtimec dtimee dtimece dtimeec dcgr degr dcgrE degrC Edom"

foreach var in `varnames'{
	generate `var'=0
}

local pattern="1 0 0 1 0 0 0 0"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace dtimec=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 1 0 0 0 0 1 0"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace dtimee=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 0 1 0 1 0 0 0"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace dtimece=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 0 0 0 0 1 0 1"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace dtimeec=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 0 0 2 2 0 0 0"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace dcgr=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 0 0 0 0 0 2 2"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace degr=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 0 0 0 2 0 0 0"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace dcgrE=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 0 0 0 0 0 0 2"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace degrC=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

local pattern="0 1 0 0 0 1 1 1"

forvalues y=1(8)2584{
    local counter=`y'
    foreach dummy in `pattern'{
        replace Edom=`dummy' if _n==`counter'
        local counter=`counter'+1
    }
}

gen anyplaus=0

forvalues x=1(8)2584{
	local zahl=0
    forvalues y=1(1)8{
        local counter=`x'-1+`y'
		if micro[`counter']==1 | equal[`counter']==1 | switch[`counter']==1 {
			 local zahl=`counter'+1
		}
        local obergrenze=`x'+7
        replace anyplaus=1 if `zahl'>0 & _n>=`x' & _n<=`obergrenze'
    }
}

gen anyattc=0

forvalues x=1(8)2584{
	local zahl=0
    forvalues y=1(1)8{
        local counter=`x'-1+`y'
		if attc1[`counter']==1 | attc2[`counter']==1 | attc3[`counter']!=1 {
			 local zahl=`counter'+1
		}
        local obergrenze=`x'+7
        replace anyattc=1 if `zahl'>0 & _n>=`x' & _n<=`obergrenze'
    }
}


order id, first
order time-attc3, last
order anyattc, last
order anyplaus, before(gender)
*************************************************

*************************************************
*Generate Variable Labels & Value Labels
label variable id   "Participant ID"
label variable SDR   "Social discount rate"
label variable dtimec   "Consumption PRTP Dummy" 
label variable dtimee   "Environmental Quality PRTP Dummy"
label variable dtimece   "Consumption & Environmental Quality PRTP Dummy"
label variable dtimeec   "Environmental Quality & Consumption &  PRTP Dummy"
label variable dcgr   "Dummy for Consumption Growth"
label variable degr   "Dummy for Environmental Quality Growth"
label variable dcgrE   "Dummy for Consumption Growth w/ Background Environmental Quality Growth"
label variable degrC   "Dummy for Environmental Quality Growth w/ Background Consumption Growth"
label variable Edom   "Dummy for Environmental Scenarios"
label variable time   "Completion time in seconds"
label variable micro   "Preference for microscopic addition"
label variable equal   "Preference for equal addition in 21 years"
label variable switch   "Switched multiple time"
label variable anyplaus   "At least one implausible response"
label variable gender   "Participant Gender"
label variable age   "Participant Age"
label variable parinc   "Participant Parental Income"
label variable pareduc   "Participant Parental Education"
label variable pol   "Participant Political View"
label variable conc1   "Concerned by: Inequality"
label variable conc2   "Concerned by: The environment in general"
label variable conc3   "Concerned by: The future of the planet"
label variable conc4   "Concerned by: Pollution today"
label variable conf1   "Confidence in: The government"
label variable conf2   "Confidence in: Political parties"
label variable conf3   "Confidence in: NGO's"
label variable conf4   "Confidence in: People in general"
label variable compr1   "Comprehension: I understood the trade-offs that I was facing"
label variable compr2   "Comprehension: I made conscious decisions about the trade-offs I was facing"
label variable compr3   "Comprehension: I understood the scenario descriptions"
label variable compr4   "Comprehension: I was able to stay focused for the duration of the survey"
label variable compr5  "Comprehension: I made reasonable decisions about the trade-offs I was facing"
label variable compr6   "Comprehension: I understood the differences between the different blocks"
label variable rand   "Scenario first presented"
label variable attc1   "Failed Attention Check 1"
label variable attc2   "Failed Attention Check 2"
label variable attc3   "Failed Attention Check 3"
label variable anyattc   "At least one failed attention check"