/**********************************************************************
Program Name:               mics to VCQI -RI dataset
Purpose:                     Code to create VCQI dataset using mics questionnaire
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
	use "${OUTPUT_FOLDER}/mics_${MICS_NUM}_combined_dataset", clear


	* cd to OUTPUT local
	cd "$OUTPUT_FOLDER"

	save mics_${MICS_NUM}_to_VCQI_RI, replace 


	* Only keep the people who participated in the survey 
	keep if mics_${MICS_NUM}_child_survey==1 
	
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
	

	keep RI* `dlist' ri_eligible age_months
	
	*drop all RIHC variables
	drop RIHC*
	aorder

	save, replace

	* Save dataset for each SIA survey
	foreach v in `=lower("${SIA_LIST}")' {
		use "${OUTPUT_FOLDER}/mics_${MICS_NUM}_to_VCQI_RI", clear
		save mics_${MICS_NUM}_VCQI_RI_SIA_`=upper("`v'")', replace
	}
}
