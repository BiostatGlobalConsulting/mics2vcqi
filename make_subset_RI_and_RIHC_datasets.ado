/**********************************************************************
Program Name:               make_subset_RI_and_RIHC_datasets
Purpose:                    Code to create user specified subset VCQI dataset using mics2vcqi RI and RIHC dataset.
Project:                    Q:\- WHO mics VCQI-compatible\mics manuals
Charge Number:  
Date Created:    			2017-03-28
Date Modified:  
Input Data:                 
Output2:                                
Comments: 
Author:         Mary Kay Trimner

Stata version:    14.0
**********************************************************************/
* This program is used to create a new dataset that contains a specific subset of RI participants
* For example: If you only want to run an analysis on children age 12-23 months

********************************************************************************
* Program Syntax
*
* Required Option:
*
* MINAGE -- 	format: 		integer
*				description:	minimum age in months of children to be included in RI analysis
*
* MAXAGE --		format:			integer
* 				description:	maximum age in months of children to be included in RI analysis
*
* INPUTPATH --	format: 		string
*				description:	path and name of RI or RIHC dataset
*				note1:			RI or RIHC dataset must be created through the mics2vcqi conversion program
*				
*
********************************************************************************
********************************************************************************
* General Notes:
* This program will need to be ran on RI and RIHC datasets seperately
*
********************************************************************************
capture program drop make_subset_RI_and_RIHC_datasets
program define make_subset_RI_and_RIHC_datasets

	syntax ,  MINage(integer) MAXage(integer) INPUTpath(string asis)
	
	quietly {
	
		no di "Open `inputpath'..."
		use "`inputpath'", clear
		
		no di "Only keep the child if their age in months is greater than `minage' and less than `maxage'..."
		keep if age_months >=`minage' & age_months <=`maxage'
	
		no di "Save subset file as `inputpath'_`minage'_to_`maxage'"
		save "`inputpath'_`minage'_to_`maxage'", replace 
	}
end	
