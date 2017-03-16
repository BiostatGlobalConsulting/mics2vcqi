/**********************************************************************
Program Name:               MICS to VCQI - levels of datasets
Purpose:                    Code to create VCQI dataset using mics questionnaire
Project:                    Q:\- WHO mics VCQI-compatible\mics manuals
Charge Number:  
Date Created:    			2016-04-27
Date Modified:  
Input Data:                 
Output2:                                
Comments: Take mics combined dataset with new VCQI variables and create datasets so that the data can be run through VCQI
Author:         Mary Kay Trimner

Stata version:    14.0
**********************************************************************/
* Bring in Combined dataset
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear

* cd to OUTPUT 
cd "$OUTPUT_FOLDER"

* Create level1name dataset
clear
set obs 1
generate level1id = 1 in 1
generate level1name = "${LEVEL1_NAME}" in 1
save level1name, replace

* Create level2names dataset
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear
bysort $PROVINCE_ID: keep if _n == 1
keep $PROVINCE_ID
sort $PROVINCE_ID
rename $PROVINCE_ID level2id
gen level2name = ""
local l `:value label level2id'
forvalues i = 1/`=_N' {
	replace level2name = "`:label `l' `=level2id[`i']''" in `i'
}
label value level2id
save level2names, replace


* Create level2order dataset
clear
use level2names
drop level2name
gen level2order = _n
save level2order, replace

* Create level3name dataset
//get rid of unique global and do word count
clear
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear
if wordcount("$LEVEL_3_ID") > 1 {
	egen level3id=group(${LEVEL_3_ID}), label lname(l3id)
	gen level3name=""
	forvalue i = 1/`=_N' {
		replace level3name="`:label l3id `=level3id[`i']''" in `i'
	}
	bysort level3id: keep if _n==1
	sort level3id
	keep level3*
	label value level3id
	save level3names, replace

}
else {
	bysort $LEVEL_3_ID: keep if _n == 1
	keep $LEVEL_3_ID 
	sort $LEVEL_3_ID
	rename $LEVEL_3_ID level3id
	gen level3name = ""
	local l `:value label level3id'
	forvalues i = 1/`=_N' {
		replace level3name= "`:label `l' `=level3id[`i']''" in `i'
	}
	label value level3id 
	save level3names, replace
}

* Create level3order dataset
clear
use level3names
drop level3name
gen level3order = _n
save level3order, replace

**********************************************************************
* Generate some level4 datasets

clear
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear
bysort $LEVEL_4_ID: keep if _n == 1
keep $LEVEL_4_ID
sort $LEVEL_4_ID
rename $LEVEL_4_ID level4id
local l `:value label level4id'
gen level4name = ""
forvalues i = 1/`=_N' {
	replace level4name = "`:label `l' `=level4id[`i']''" in `i'
}
label value level4id
save level4names, replace

* Create level4order dataset
clear
use level4names
drop level4name
gen level4order = _n
save level4order, replace
