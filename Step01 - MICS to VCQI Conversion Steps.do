/**********************************************************************
Program Name:               Step01 - MICS to VCQI Conversion Steps 
Purpose:                    Take the datasets provided by the user and create one large dataset 
*													
Project:                    Q:\- WHO MICS VCQI-compatible\MICS manuals
Date Created:    			2016-04-28
Author:         Mary Kay Trimner
Stata version:    14.0
********************************************************************************/
set more off

* cd to Input folder
cd "${INPUT_FOLDER}"

********************************************************************************
********************************************************************************
********************************************************************************

* Create one large dataset

* There could be times when all the datasets are not provided. 
* This code makes a large dataset contingent on which Surveys were completed
* HH Data will always be provided, this is for TT,RI and RIHC

* If RI (child) and TT (women's) surveys were both completed
if $RI_SURVEY ==1 & $TT_SURVEY==1 {
	use "${MICS_CH_DATA}", clear


	* Create variable to show RI Survey date
	gen ri_survey_date=mdy(${RI_DATE_MONTH}, ${RI_DATE_DAY}, ${RI_DATE_YEAR})
	format %td ri_survey_date
	label variable ri_survey_date "Date of RI survey"


		
	* Merge in Register Data if Health Facility records were sought
	if $RIHC_SURVEY ==1 & "$MICS_HF_DATA"!="" {
		gen ${RIHC_LINE}= ${RI_LINE} 
		merge 1:1 $STRATUM_ID $HH_ID $CLUSTER_ID $RIHC_LINE using "${MICS_HF_DATA}" //Merge with Health Facility
	}
	if $RIHC_SURVEY ==1 {
		gen rihc_survey_date=mdy(${RIHC_DATE_MONTH}, ${RIHC_DATE_DAY}, ${RIHC_DATE_YEAR})
		format %td rihc_survey_date
		label variable rihc_survey_date "Date of RIHC survey"
		
		gen rihc_survey=1 if !missing(rihc_survey_date)
		label variable rihc_survey "Participated in RIHC Survey"
	}


	* Create variable to show they were part of the Child Survey
	gen child_survey=1
	label variable child_survey "Participated in Child Survey"

	save "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", replace

	
	append using "${MICS_WM_DATA}"

	* Create variable to indicate Women's Survey
	gen tt_survey=1 if child_survey==.
	label variable tt_survey "Participated in Women's/TT survey"

	* Create variable to show the date of TT survey
	gen tt_survey_date=mdy(${TT_DATE_MONTH}, ${TT_DATE_DAY}, ${TT_DATE_YEAR})
	format %td tt_survey_date
	label variable tt_survey_date "Date of TT survey"
	save, replace
	
	* Create line number variable for merging purposes
	gen ${HM_LINE}= ${RI_LINE} 
		replace ${HM_LINE}=${TT_LINE} if missing(${RI_LINE})
		label variable ${HM_LINE} "line number"

	* Merge in Household Member data
	merge 1:1 $STRATUM_ID $HH_ID $CLUSTER_ID $HM_LINE using "${MICS_HM_DATA}"

	drop _merge

	save, replace
	
	* Merge in Household (HH) data
	merge m:1 $STRATUM_ID $HH_ID $CLUSTER_ID using "${MICS_HH_DATA}" 

	drop _merge

	save, replace


	
}

********************************************************************************
********************************************************************************
********************************************************************************

* If RI (child) survey was completed, but TT (women's) survey was NOT completed
if $RI_SURVEY ==1 & $TT_SURVEY!=1 {
	use "${MICS_CH_DATA}", clear


	* Create variable to show RI Survey date
	gen ri_survey_date=mdy(${RI_DATE_MONTH}, ${RI_DATE_DAY}, ${RI_DATE_YEAR})
	format %td ri_survey_date
	label variable ri_survey_date "Date of RI survey"

		
	* Merge in Register Data if Health Facility records were sought
	if $RIHC_SURVEY ==1 & "$MICS_HF_DATA"!="" {
		gen ${RIHC_LINE}= ${RI_LINE} 
		merge 1:1 $STRATUM_ID $HH_ID $CLUSTER_ID $RIHC_LINE using "${MICS_HF_DATA}" //Merge with Health Facility
	}
	if $RIHC_SURVEY ==1 {
		gen rihc_survey_date=mdy(${RIHC_DATE_MONTH}, ${RIHC_DATE_DAY}, ${RIHC_DATE_YEAR})
		format %td rihc_survey_date
		label variable rihc_survey_date "Date of RIHC survey"
		
		gen rihc_survey=1 if !missing(rihc_survey_date)
		label variable rihc_survey "Participated in RIHC Survey"
	}


	* Create variable to show they were part of the Child Survey
	gen child_survey=1
	label variable child_survey "Participated in Child Survey"

	save "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", replace
	
	* Create line number variable for merging purposes
	gen ${HM_LINE}= ${RI_LINE} 
	label variable ${HM_LINE} "line number"

	* Merge in Household Member data
	merge 1:1 $STRATUM_ID $HH_ID $CLUSTER_ID $HM_LINE using "${MICS_HM_DATA}"

	drop _merge

	save, replace

	* Merge in Household (HH) data
	merge m:1 $STRATUM_ID $HH_ID $CLUSTER_ID using "${MICS_HH_DATA}" //Merge with HM

	drop _merge

	save, replace

}

********************************************************************************
********************************************************************************
********************************************************************************
* If RI (child) survey was NOT completed, but TT (women's) survey was completed

if $RI_SURVEY !=1 & $TT_SURVEY==1 {
	use "${MICS_WM_DATA}", clear

	save "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", replace

	* Create variable to indicate Women's Survey
	gen tt_survey=1 
	label variable tt_survey "Participated in Women's/TT survey"

	* Create variable to show the date of TT survey
	gen tt_survey_date=mdy(${TT_DATE_MONTH}, ${TT_DATE_DAY}, ${TT_DATE_YEAR})
	format %td tt_survey_date
	label variable tt_survey_date "Date of TT survey"
	save, replace
	

	* Create line number variable for merging purposes
	gen ${HM_LINE}= ${TT_LINE} 
	label variable ${HM_LINE} "line number"

	* Merge in Household Member data
	merge 1:1 $STRATUM_ID $HH_ID $CLUSTER_ID $HM_LINE using "${MICS_HM_DATA}"

	drop _merge

	save, replace
	
	* Merge in Household (HH) data
	merge m:1 $STRATUM_ID $HH_ID $CLUSTER_ID using "${MICS_HH_DATA}" //Merge with HM

	drop _merge

	save, replace


}
