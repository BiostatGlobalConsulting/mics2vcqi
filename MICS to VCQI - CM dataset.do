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
* Bring in Combined dataset
use "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset", clear

* cd to OUTPUT
cd "$OUTPUT_FOLDER"

* Save as CM dataset
save MICS_${MICS_NUM}_to_VCQI_CM, replace 

****************************************************************

* Create expected_hh_to_visit VCQI variable
bysort HH03 HH14: gen firsthm = _n == 1
bysort HH03 : egen expected_hh_to_visit = total(firsthm) // Double check to ensure this appropriately calculated.
drop firsthm
label variable expected_hh_to_visit "Number of HH survey team expects to visit in cluster (or cluster segment)"

*****************************************************************

* Only keep the variables required for CM dataset
keep HH01 HH02 HH03 HH04 province_id expected_hh_to_visit urban_cluster psweight*

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
save, replace
