/**********************************************************************
Program Name:               MICS to VCQI - CM dataset
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
********************************************************************************
*-------------------------------------------------------------------------------
* Change log 
* 				Updated 
*				version 
* Date 			number 	Name			What Changed 
*-------------------------------------------------------------------------------
* 2023-02-26	1.01	MK Trimner 		Added check to see if more than 1 weight per cluster.
*										If yes, create dataset with 1 weight per respondent in survey type.
********************************************************************************

* Bring in Combined dataset
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear

* cd to OUTPUT
cd "$OUTPUT_FOLDER"

* Save as CM dataset
save MICS_${MICS_NUM}_to_VCQI_CM, replace 

* Check to see if the province_id is missing, if so populate based on state and cluster
capture assert !missing(province_id)
if _rc != 0 {
	sort HH01 HH03 province_id
	bysort HH01 HH03: replace province_id = province_id[1]
}
****************************************************************

* Create expected_hh_to_visit VCQI variable
bysort HH03 HH14: gen firsthm = _n == 1

bysort HH03 : egen expected_hh_to_visit = total(firsthm) // Double check to ensure this appropriately calculated.
drop firsthm
label variable expected_hh_to_visit "Number of HH survey team expects to visit in cluster (or cluster segment)"

*****************************************************************

* Only keep the variables required for CM dataset
keep HH01 HH02 HH03 HH04 province_id expected_hh_to_visit urban_cluster psweight*

* Lets check to see if there is a unique weight per cluster/urban area etc
preserve
keep HH01 HH03 psweight*
duplicates drop
bysort HH01 HH03 : gen n = _N
sum n
local maxvalue `r(max)'
restore

* If there is not a unqiue value per cluster, lets go ahead and make a mini dataset with the unique weight per child
if `maxvalue' > 1 {
	use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear
	*Make a small_weights_dataset.dta with one row per child and five variables:
	if ${RI_SURVEY} == 1 {
		preserve
		keep RI01 RI03 RI11 RI12 psweight_1year
		duplicates drop
		rename psweight_1year psweight 
		drop if missing(RI12)
		save small_weights_dataset, replace
		restore
	}
	if ${TT_SURVEY} == 1 {
		preserve
		keep TT01 TT03 TT11 TT12 psweight_1year
		duplicates drop
		rename psweight_1year psweight 
		drop if missing(TT12)
		save small_weights_dataset, replace
		restore
	}
	if ${SIA_SURVEY} == 1 {
		preserve
		keep SIA01 SIA03 SIA11 SIA12 psweight_sia 
		duplicates drop
		rename psweight_sia psweight 
		drop if missing(SIA12)
		save small_weights_dataset, replace
		restore
	}
	
	* Create an empty CM datasets
	* Urban/Rural cluster can be missing; if there is a populated value for this cluster, use it
	keep HH01 HH03 urban_cluster psweight* 
	sort HH01 HH03 urban_cluster
	bysort HH01 HH03: replace urban_cluster = urban_cluster[1]

	capture replace psweight_1year = .

	capture replace psweight_sia = .
	
	*Only keep one row per cluster and stratum
	bysort HH01 HH03 : keep if _n==1

	* Save file
	save MICS_${MICS_NUM}_to_VCQI_CM, replace 
}
else {

	* Urban/Rural cluster can be missing; if there is a populated value for this cluster, use it
	sort HH01 HH03 urban_cluster
	bysort HH01 HH03: replace urban_cluster = urban_cluster[1]

	* The weight can be missing for some observations; replace the weight with
	* the maximum non-missing weight in each cluster 

	bysort HH01 HH03: egen max_psweight_1year = max(psweight_1year)
	replace psweight_1year = max_psweight_1year
	drop max_psweight_1year

	bysort HH01 HH03: egen max_psweight_sia = max(psweight_sia)
	replace psweight_sia = max_psweight_sia
	drop max_psweight_sia

	*Only keep one row per cluster and stratum
	bysort HH01 HH03 : keep if _n==1

	* Save file
	save MICS_${MICS_NUM}_to_VCQI_CM, replace 
}
