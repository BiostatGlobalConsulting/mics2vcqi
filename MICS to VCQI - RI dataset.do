/**********************************************************************
Program Name:               MICS to VCQI - RI dataset
Purpose:                    Code to create VCQI dataset using mics questionnaire
Project:                    Q:\- WHO mics VCQI-compatible\mics manuals
Charge Number:  
Date Created:    			2016-04-28
Date Modified:  
Input Data:                 
Output2:                                
Comments: Take mics combined dataset with new VCQI variables and create datasets so that the data can be run through VCQI
Author:         Mary Kay Trimner

Stata version:    14.0
**********************************************************************/
set more off

if $RI_SURVEY==1 {
	* Pull in mics combined dataset and save as new dataset for VCQI
	use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear

	* cd to Output folder
	cd "$OUTPUT_FOLDER"

	save MICS_${MICS_NUM}_to_VCQI_RI, replace 


	* Only keep the people who participated in the survey 
	keep if MICS_${MICS_NUM}_child_survey==1 
	
	* Only keep if the interview was completed
	keep if HM33==4
	
	* Drop all variables except RI
	local dlist
	foreach v in `=lower("${RI_LIST}")' {
		local dlist `dlist' `v'_date_card_* `v'_history `v'_tick_card dob_date_card_* dob_date_hist* 
	}
	
	* Keep bcg_scar_history if bcg is part of the ri dose list
	if strpos("`=lower("$RI_LIST")'","bcg")!=0 {
		local dlist `dlist' bcg_scar_history
	}
	
	* Make a list of the additional variables to include with the dataset
	foreach v in $RI_ADDITIONAL_VARS {
		capture confirm variable MICS_${MICS_NUM}_`v'
		if _rc == 0 local dlist `dlist' MICS_${MICS_NUM}_`v'
	}
	
	keep  RI* `dlist' ri_eligible age_months
	order RI* `dlist' ri_eligible age_months
	
	*drop all RIHC variables
	capture drop RIHC*
	aorder

	save, replace
	
	* Save dataset for age groups
	* Age 12-23m
	use "MICS_${MICS_NUM}_to_VCQI_RI", clear
	keep if age_months >=12 & age_months <=23
	save "MICS_${MICS_NUM}_to_VCQI_RI_12_to_23", replace 

	
	* If max age is greather than 23m 
	* Make a second dataset that captures 24m to $RI_MAX_AGE
	if $RI_MAX_AGE >23 {
		use "MICS_${MICS_NUM}_to_VCQI_RI", clear
		keep if age_months >=24 & age_months <=$RI_MAX_AGE
		save "MICS_${MICS_NUM}_to_VCQI_RI_24_to_${RI_MAX_AGE}", replace 
	}

	
	* If min age does not equal 12
	* Make a dataset with the ages provided
	if $RI_MIN_AGE != 12 { 
		use "MICS_${MICS_NUM}_to_VCQI_RI", clear
		keep if age_months >=$RI_MIN_AGE & age_months <=$RI_MAX_AGE
		save "MICS_${MICS_NUM}_to_VCQI_RI_${RI_MIN_AGE}_to_${RI_MAX_AGE}", replace 
	}
	
	
	
/*
	* Save dataset for each SIA survey
	foreach v in `=lower("${SIA_LIST}")' {
		use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_to_VCQI_RI", clear
		save MICS_${MICS_NUM}_VCQI_RI_SIA_`=upper("`v'")', replace
	}
*/
}
