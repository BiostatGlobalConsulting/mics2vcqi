/**********************************************************************
Program Name:               Step05 - MICS to VCQI Add Campaign doses to History 
Purpose:                    Takes any campaign doses and sets the history to 1 if said received it
*													
Project:                    Q:\- WHO MICS VCQI-compatible\MICS manuals
Date Created:    			2016-04-28
Author:         Mary Kay Trimner
Stata version:    14.0
********************************************************************************/
set more off

use MICS_${MICS_NUM}_to_VCQI_RI, clear

* First lets confirm that the doses exist in the dataset
foreach v in $CAMPAIGN_DOSES {
	local v `=upper("`v'")'
	local d `=lower("`v'")'
	
	local have_var = 1
	capture confirm variable `d'_history 
	if _rc != 0 {
		local d `d'1
		capture confirm variable `d'_history
		if _rc != 0  {
			local have_var = 0
			noi di as error "Dose `v' provided in global CAMPAIGN_DOSES does not exist in the dataset. Therefore it will not be included in the campagin doses."
		}
	}
	if `have_var' == 1 {
		gen `d'_campaign= 0
		foreach c in ${`v'_CAMPAIGN} {
			replace `d'_campaign = 1 if `c' == 1
		}
		replace `d'_history = 1 if `d'_campaign == 1
	}
}

save, replace