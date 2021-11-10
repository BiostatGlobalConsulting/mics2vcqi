/**********************************************************************
Program Name:               Step02 - MICS to VCQI Conversion Steps 
Purpose:                    Checks to make sure all necessary globals are populated 
*													
Project:                    Q:\- WHO MICS VCQI-compatible\MICS manuals
Date Created:    			2016-04-28
Author:         Mary Kay Trimner
Stata version:    14.0
********************************************************************************/
set more off

* The below globals are required for all MICS to VCQI Conversion

foreach v in RI_SURVEY RIHC_SURVEY SIA_SURVEY TT_SURVEY HH_DOB {
		if "$`v'"=="" {
			di as error "Global macro `v' must be defined to complete the any analysis"
		}
}

* Check to see that for PROVINCE_ID it is populated to 1 or a variable name.
* If it is a variable name, verify that the variable exists and change the global to reflect renamed variables.
if "$PROVINCE_ID"=="" {
		di as error "Global macro PROVINCE_ID must be defined to complete the any analysis"
}
else {
	capture confirm variable ${PROVINCE_ID}
		if !_rc {
			global PROVINCE_ID 	MICS_${MICS_NUM}_${PROVINCE_ID}	
		}
		else {
			if "$PROVINCE_ID"!="1" {
				di as error ///
				"Variable ${PROVINCE_ID} provided in global macro PROVINCE_ID does not exist" //Let the user know if a variable does not exist in dataset
			}
		}
}

* Level3id is a little different and may have two variables. You will need to check each variable
* Check to make sure the global is populated
if "$LEVEL_3_ID"=="" {
	di as error "Global macro LEVEL_3_ID must be defined to complete the any analysis"
}
else {
	foreach v in $LEVEL_3_ID {
		capture confirm variable `v'
			if !_rc {
				local l3list  `l3list' MICS_${MICS_NUM}_`v'	
			}
			else {
				di as error ///
				"Variable `v' provided in global macro LEVEL_3_ID does not exist" //Let the user know if a variable does not exist in dataset
			}
	}
	
	* Set the global to the new l3list
	global LEVEL_3_ID `l3list'
}

	
	
foreach v in STRATUM_ID STRATUM_NAME CLUSTER_ID CLUSTER_NAME HH_ID HH_DATE_MONTH ///
		HH_DATE_DAY HH_DATE_YEAR HM_LINE OVERALL_DISPOSITION PSWEIGHT_1YEAR ///		
		PSWEIGHT_SIA URBAN_CLUSTER SEX {			
		
	if "$`v'"=="" {
		di as error "Global macro `v' must be defined to complete the any analysis"
	}
	else {
		capture confirm variable ${`v'}
			if !_rc {
				global `v' 	MICS_${MICS_NUM}_${`v'}	
			}
			else {
				di as error ///
				"Variable ${`v'} provided in global macro `v' does not exist" //Let the user know if a variable does not exist in dataset
			}
	}
}

* These variables are not required in the surveys but if populated, need to verify the variable exists
 foreach v in DATE_OF_BIRTH_MONTH DATE_OF_BIRTH_YEAR DATE_OF_BIRTH_DAY AGE_YEARS DATE_OF_BIRTH AGE_MONTHS ///
				CHILD_AGE_YEARS CHILD_AGE_MONTHS CHILD_DOB_CARD_MONTH CHILD_DOB_CARD_DAY CHILD_DOB_CARD_YEAR LEVEL_4_ID ///
				MOTHER_DOB_DAY MOTHER_AGE_YEARS TT_CHILD_DOB_DAY LAST_TT_MONTH LAST_TT_YEAR TT_CHILD_DOB_MONTH ///
				TT_CHILD_DOB_YEAR BCG_SCAR {
			if "$`v'"!="" {
			capture confirm variable ${`v'}
				if !_rc {
					global `v' 	MICS_${MICS_NUM}_${`v'}	
				}
				else {
					di as error ///
					"Variable ${`v'} provided in global macro `v' does not exist" //Let the user know if a variable does not exist in dataset
				}
		}
}
			

if $RI_SURVEY==1 {

* Check that all non-variable globals are populated if required
	foreach v in RI_MIN_AGE RI_MAX_AGE RI_LIST CARD_DOB {
		if "$`v'"=="" {
			di as error "Global macro `v' must be defined to complete the RI analysis"
		}
	}
	
	* If it is MICS6 there is a new variable tha we want to use.
	if $MICS_NUM == 6 local has_card HAS_CARD
	foreach v in RI_DISPOSITION CARD_EVER_RECEIVED CARD_SEEN `has_card' ///
				  RI_DATE_MONTH RI_DATE_DAY RI_DATE_YEAR CHILD_DOB_HIST_MONTH CHILD_DOB_HIST_DAY ///
				  CHILD_DOB_HIST_YEAR RI_LINE {
				  	
					
			  
		if "$`v'"=="" {
			di as error "Global macro `v' must be defined to complete the RI analysis"
		}
		else {
			capture confirm variable ${`v'}
				if !_rc {
					global `v' 	MICS_${MICS_NUM}_${`v'}	
				}
				else {
					di as error ///
					"Variable ${`v'} provided in global macro `v' does not exist" //Let the user know if a variable does not exist in dataset
				}
		}

	}
	
	* check all the card date variables
	foreach v in `=upper("${RI_LIST}")' {
		foreach m in MONTH DAY YEAR {
			if "${`v'_DATE_CARD_`m'}"=="" {
				di as error "Global macro `v'_DATE_CARD_`m' must be defined to complete the RI analysis"
			}
			else {
				capture confirm variable ${`v'_DATE_CARD_`m'}
					if !_rc {
						global `v'_DATE_CARD_`m' 	MICS_${MICS_NUM}_${`v'_DATE_CARD_`m'}	
					}
					else {
						di as error ///
						"Variable ${`v'_DATE_CARD_`m'} provided in global macro `v'_DATE_CARD_`m' does not exist" //Let the user know if a variable does not exist in dataset
					}
			}
		}
	}

	* check for history information
	local k
	foreach d in `=upper("${RI_LIST}")' {
		if "1"==substr("`d'",-1,1) {
			local g `=substr("`d'",1,length("`d'")-1)'
			}
		else if "2"==substr("`d'",-1,1) {
			local g `=substr("`d'",1,length("`d'")-1)'

		}
		else if "3"==substr("`d'",-1,1) {
			local g `=substr("`d'",1,length("`d'")-1)'

		}
		else {
			local g "`d'"
		}
			
			local k `k' `g'
	}

	local list1 `k'
	forvalues i = 1/`=wordcount("`list1'")' {
		local isfirst 1
			forvalues j =1/`=`i'-1' {
				if word("`list1'",`i')==word("`list1'",`j') local isfirst 0
			}
			if `isfirst'==1 local firstlist `firstlist' `i'
	}
		
	di "`firstlist'"
	di "`k'"
	
	local list2 
	foreach w in `firstlist' {
		local list2 `list2' `=word("`list1'",`w')'
	}
	di "`list2'"
	
		
		
	foreach g in `list2' {
		foreach m in HIST {
			if "${`g'_`m'}"=="" {
				di as error "Global macro `g'_`m' must be defined to complete the RI analysis"
			}
			else {
				if "${`g'_`m'}"!="1" {
					capture confirm variable ${`g'_`m'} 
						if !_rc {
							global `g'_`m' 	MICS_${MICS_NUM}_${`g'_`m'}	
						}
						else {
							di as error ///
							"Variable ${`g'_`m'} provided in global macro `g'_`m' does not exist" //Let the user know if a variable does not exist in dataset
						}
				}
			}
		}
		
	}
	
	foreach v in `list2' {
		if "0"==substr("`v'",-1,1) {
			local g `=substr("`v'",1,length("`v'")-1)'
		}
		else {
			local g `v'
		}
		
		local list3 `list3' `g'
	}
	di "`list3'"
	
	forvalues i= 1/`=wordcount("`list3'")' {
		local isfirst 1
		forvalues j = 1/`=`i'-1' {
			if word("`list2'",`i')==word("`list3'",`j') local isfirst 0
		}
		if `isfirst'==1 local secondlist `secondlist' `i'
	}
	di "`secondlist'"
	foreach w in `secondlist' {
		local list4 `list4' `=word("`list3'",`w')'
	}
	di "`list4'"
	
	* Check the DOSE_NUM globals
	foreach g in `list4' {
		foreach m in DOSE_NUM {
			if "${`g'_`m'}"=="" {
				di as error "Global macro `g'_`m' must be defined to complete the RI analysis"
			}
			else {
				if "${`g'_`m'}"!="1" {
					capture confirm variable ${`g'_`m'} 
						if !_rc {
							global `g'_`m' 	MICS_${MICS_NUM}_${`g'_`m'}	
						}
						else {
							di as error ///
							"Variable ${`g'_`m'} provided in global macro `g'_`m' does not exist" //Let the user know if a variable does not exist in dataset
						}
				}
			}
		}
		
	}
	
	* Now we want to check the CAMPAIGN VARIABLES if they are populated
	set trace on
	foreach v in $CAMPAIGN_DOSES {
		local v `=upper("`v'")'
		if "${`v'_CAMPAIGN}" == "" {
			di as error "Global macro `v'_CAMPAIGN must be defined to complete the RI analysis if the dose is listed in global CAMPAIGN_DOSES"
		}
		else {
			local `v' 
			foreach d in ${`v'_CAMPAIGN} {
				capture confirm variable `d'
				if !_rc {
					local `v' ``v'' MICS_${MICS_NUM}_`d'
				}
				else {
					di as error ///
					"Variable `d' provided in global macro `v'_CAMPAIGN does not exist" //Let the user know if a variable does not exist in dataset
				}
			}
			global `v'_CAMPAIGN ``v''
		}
	}

					
	if $RIHC_SURVEY==1 {
		foreach v in RIHC_LINE RIHC_DATE_MONTH RIHC_DATE_DAY RIHC_DATE_YEAR ///
					CHILD_DOB_REG_MONTH CHILD_DOB_REG_DAY CHILD_DOB_REG_YEAR {
			if "$`v'"=="" {
				di as error "Global macro `v' must be defined to complete the RIHC analysis"
			}
			else {
				capture confirm variable ${`v'}
					if !_rc {
						global `v' 	MICS_${MICS_NUM}_${`v'}	
					}
					else {
						di as error ///
						"Variable ${`v'} provided in global macro `v' does not exist" //Let the user know if a variable does not exist in dataset
					}
			}
		}
		
		foreach v in `=upper("${RI_LIST}")' {
			foreach m in MONTH DAY YEAR {
				if "${`v'_DATE_REG_`m'}"=="" {
					di as error "Global macro `v'_DATE_REG_`m' must be defined to complete the RIHC analysis"
				}
				else {
					capture confirm variable ${`v'_DATE_REG_`m'}
						if !_rc {
							global `v'_DATE_REG_`m' 	MICS_${MICS_NUM}_${`v'_DATE_REG_`m'}	
						}
						else {
							di as error ///
							"Variable ${`v'_DATE_REG_`m'} provided in global macro `v'_DATE_REG_`m' does not exist" //Let the user know if a variable does not exist in dataset
						}
				}
			}
		}
	}

}

 if $SIA_SURVEY==1 {
 			
	if "$SIA_DISPOSITION"=="" & "$RI_DISPOSITION"!="" {
		* If missing SIA_DISPOSITION set it to the RI_DISPOSITION as they are the same survey
		global SIA_DISPOSTION $RI_DISPOSITION
	}
	*If RI_DISPOSITION is still missing then show as an error
	if "$SIA_DISPOSITION"=="" {
			di as error "Global macro SIA_DISPOSITION must be defined to complete the SIA analysis"
	}
	else {
		capture confirm variable ${SIA_DISPOSITION}
			if !_rc {
				global SIA_DISPOSITION	MICS_${MICS_NUM}_${SIA_DISPOSITION}	
			}
			else {
				di as error ///
				"Variable ${SIA_DISPOSITION} provided for global SIA_DISPOSITION does not exist"

			}
	}

	if "$SIA_LIST"=="" {
		di as error "Global macro SIA_LIST must be defined to complete the SIA analysis"
	}
				
	foreach v in `=upper("${SIA_LIST}")' {
		if "$SIA_`v'"=="" {
			di as error "Global macro SIA_`v' must be defined to complete the SIA analysis"
		}
		else {
			capture confirm variable ${SIA_`v'}
				if !_rc {
					global SIA_`v'	MICS_${MICS_NUM}_${SIA_`v'}	
				}
				else {
					di as error ///
					"Variable ${SIA_`v'} provided in global macro SIA_`v' does not exist" //Let the user know if a variable does not exist in dataset
				}
		
			foreach g in MIN MAX {
				if "${SIA_`g'_AGE_`v'}"=="" {
					di as error "Global macro SIA_`g'_AGE_`v' must be defined to complete the SIA analysis"
				}
			}
		}
	}
}
			
if $TT_SURVEY==1 {
	foreach v in TT_MIN_AGE TT_MAX_AGE  MOTHER_DOB {				 
		if "$`v'"=="" {
			di as error "Global macro `v' must be defined to complete the TT analysis"
		}
	}
	
	
	* For the globals that will be populated with variable values confirm the variables exist
	foreach v in TT_LINE TT_DATE_MONTH TT_DATE_DAY TT_DATE_YEAR MOTHER_DOB_MONTH ///			
				MOTHER_DOB_YEAR MOTHER_CARD_SEEN TT_PREGNANCY NUM_TT_PREGNANCY ///
				TT_ANYTIME NUM_TT_ANYTIME YEARS_SINCE_LAST_TT TT_DISPOSITION {
		if "$`v'"=="" {
			di as error "Global macro `v' must be defined to complete the TT analysis"
		}
		else if "$`v'"!="" {
			if "$`v'"!="1" {
			capture confirm variable ${`v'}
				if !_rc {
					global `v' 	MICS_${MICS_NUM}_${`v'}	
				}
				else {
					di as error ///
					"Variable ${`v'} provided in global macro `v' does not exist" //Let the user know if a variable does not exist in dataset
				}
			}
		}
	}
}
