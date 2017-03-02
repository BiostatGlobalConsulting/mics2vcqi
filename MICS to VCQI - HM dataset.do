/**********************************************************************
Program Name:               MICS to VCQI - HM dataset
Purpose:                    Code to create VCQI dataset using MICS questionnaire
Project:                    Q:\- WHO MICS VCQI-compatible\MICS manuals
Charge Number:  
Date Created:    			2016-04-27
Date Modified:  
Input Data:                 
Output2:                                
Comments: Take MICS combined dataset with new VCQI variables and create datasets so that the data can be run through VCQI
Author:         Mary Kay Trimner

Stata version:    14.0
**********************************************************************/
set more off

* Pull in MICS combined dataset and save as new dataset for VCQI
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear

* cd to OUTPUT 
cd "$OUTPUT_FOLDER"

save MICS_${MICS_NUM}_to_VCQI_HM, replace 

* Drop all variables except HM
keep HM* 
aorder

* Only keep observations where survey was completed
drop if HM19!=4

save, replace

* Save dataset for each SIA survey and rename each HM25 variable
foreach v in `=lower("${SIA_LIST}")' {
	use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_to_VCQI_HM", clear
	rename HM41_`v' HM41
	rename HM42_`v' HM42

	* If there is more than 1 SIA campaign drop all other campaign variables
	if `=wordcount("${SIA_LIST}")'> 1 {
		drop HM41_*
		drop HM42_*
	}
	save MICS_${MICS_NUM}_VCQI_HM_SIA_`=upper("`v'")', replace
}

