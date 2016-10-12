/**********************************************************************
Program Name:               mics to VCQI -SIA dataset
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

if $SIA_SURVEY==1 {

	* Pull in mics combined dataset and save as new dataset for VCQI
	use "${OUTPUT_FOLDER}/mics_${MICS_NUM}_combined_dataset", clear


	* cd to OUTPUT local
	cd "$OUTPUT_FOLDER"

	save mics_${MICS_NUM}_to_VCQI_SIA, replace 
	
	* Only keep if part of sia survey
	keep if mics_${MICS_NUM}_child_survey==1 
	
	* Only keep if the interview was completed
	keep if HM43==4

	
	* Drop if did not answer SIA question- create new variable to identify these people
	gen sia_participant=.
	label variable sia_participant "Child participanted in any SIA campagin"
	foreach v in `=lower("${SIA_LIST}")' {
		gen sia_participant_`v'=1 if !missing(SIA20_`v') 
		replace sia_participant_`v'=. if SIA20_`v'==9
		replace sia_participant=1 if sia_participant_`v'==1
		
		label variable sia_participant_`v' "Child participated in SIA campaign `v'"
	}
	

	* Drop child if they did not participant in any campagin
	keep if sia_participant==1

	* Drop all variables except SIA
	keep SIA* sia* HM29
	aorder

	save, replace

	* Save dataset for each SIA survey and rename each SIA20 variable
	foreach v in `=lower("${SIA_LIST}")' {
		use "${OUTPUT_FOLDER}/mics_${MICS_NUM}_to_VCQI_SIA", clear
		
		* Only keep the people who participated in the survey and were eligible
		*keep if sia_`v'_eligible==1
		
		* Rename variable so there is only one per SIA survey
		rename SIA20_`v' SIA20
		drop SIA20_* 
		keep if sia_participant_`v'==1
		drop sia_participant_*
		
		save mics_${MICS_NUM}_VCQI_SIA_`=upper("`v'")', replace
	}
}
