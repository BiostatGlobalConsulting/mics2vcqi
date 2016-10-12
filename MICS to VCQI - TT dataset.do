/**********************************************************************
Program Name:               mics to VCQI -TT dataset
Purpose:                    Code to create VCQI dataset using mics questionnaire
Project:                    Q:\- WHO mics VCQI-compatible\mics manuals
Charge Number:  
Date Created:    			2016-04-28
Date Modified:  
Input Data:                 
Output2:                                
Comments: Take mics combined dataset with new VCQI vaTTables and create datasets so that the data can be run through VCQI
Author:         Mary Kay TTTmner

Stata version:    14.0
**********************************************************************/
set more off

if $TT_SURVEY==1 {
	* Pull in mics combined dataset and save as new dataset for VCQI
	use "${OUTPUT_FOLDER}/mics_${MICS_NUM}_combined_dataset", clear


	* cd to OUTPUT local
	cd "$OUTPUT_FOLDER"

	save mics_${MICS_NUM}_to_VCQI_TT, replace 


	* Only keep the people who participated in the survey 
	keep if mics_${MICS_NUM}_tt_survey==1 
	
	* Only keep if the interview was completed
	keep if HM38==4
	
	* Drop all variables except TT
	keep TT* `dlist' tt_eligible
	aorder

	save, replace

	* Save dataset for each SIA survey
	foreach v in `=lower("${SIA_LIST}")' {
		use "${OUTPUT_FOLDER}/mics_${MICS_NUM}_to_VCQI_TT", clear
		save mics_${MICS_NUM}_VCQI_TT_SIA_`=upper("`v'")', replace
	}
}
