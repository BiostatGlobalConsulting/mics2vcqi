/**********************************************************************
Program Name:               mics to VCQI -RIHC dataset
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

if $RIHC_SURVEY==1 {
	* Pull in mics combined dataset and save as new dataset for VCQI
	use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear


	* cd to OUTPUT local
	cd "$OUTPUT_FOLDER"

	save MICS_${MICS_NUM}_to_VCQI_RIHC, replace 


	* Only keep the people who participated in the survey 
	keep if MICS_${MICS_NUM}_rihc_survey==1 
	
	* Only keep if the interview was completed
	keep if HM33==4
	
	save, replace
	
	* Drop all variables except RIHC
	local rlist
	foreach v in `=lower("${RI_LIST}")' {
		local rlist `rlist' `v'_date_register* `v'_tick_register dob_date_register*  
	}


	keep RIHC* `rlist' *rihc_survey rihc_eligible age_months
	aorder

	save "MICS_${MICS_NUM}_to_VCQI_RIHC", replace
	

}
