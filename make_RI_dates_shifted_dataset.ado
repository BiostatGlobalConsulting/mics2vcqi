/**********************************************************************
Program Name:               make_RI_dates_shifted_dataset
Purpose:                    Code to shift dose dates/ticks if previous doses are missing based on user input
Project:                    
Charge Number:  
Date Created:    			2017-03-23
Date Modified:  
Input Data:                 
Output2:                                
Comments: 
Author:         Mary Kay Trimner

Stata version:    14.0
**********************************************************************/

capture program drop make_RI_dates_shifted_dataset
program define make_RI_dates_shifted_dataset

	*** NOTE *** Need to install rowsort function from Stata for this to work properly

	syntax ,  SHIFTTO(string asis) [SHIFTFROM(string asis) INPUTpath(string asis) OUTPUTpath(string asis) SOURCE(string asis) SUFFIX(string asis) SHIFTWITHIN TIMEorder]
	
	no di "This program requires the rowsort function to be installed"
	
	no di "Begin making RI dates shifted dataset..."
	
	* Open RI dataset provided
	quietly {
		* If source is not specified, set default to RI dataset"
		if "`source'"=="" {
			local source RI  
		}
		
		no di "Shift changes will be made to the `source' dataset..."

		if "`source'"=="RI" {
			local s card
		}
		else {
			local s register
		}
		
		if "`inputpath'"=="" {
			local inputpath ${OUTPUT_FOLDER}\MICS_${MICS_NUM}_to_VCQI_`source'
		}
		
		if "`outputpath'"=="" {
			local outputpath `inputpath'
		}
		
		if "`suffix'"!="" {
			local outputpath `outputpath'_`suffix'
		}
		
		* If shiftfrom is blank, makesure shiftwithin is populated
		if "`shiftfrom'"=="" {
			local shiftwithin yes
		}
		
		use "`inputpath'", clear
		no di "Openning `inputpath'"
			
		* Save the file as date shifted to distinguish difference
		no di "Saving file as `outputpath'"
		save "`outputpath'", replace
				
		* Clean up dates and ticks
		no di "Remove any ticks if a date is present..."
		foreach v in `shiftto' `shiftfrom' {
			replace `v'_tick_`s'=. if !missing(`v'_date_`s'_m) | !missing(`v'_date_`s'_d) |!missing(`v'_date_`s'_y)
			summarize `v'_tick_`s'
			local `v'_tick `r(sum)'

		}
		
		* Determine if the date is valid
		no di "Identify which dates provided are sensible..."
		foreach v in `shiftto' `shiftfrom' {
			gen `v'_nonsensible=mdy(`v'_date_`s'_m, `v'_date_`s'_d, `v'_date_`s'_y)==. & ///
								!missing(`v'_date_`s'_m) & !missing(`v'_date_`s'_d) & !missing(`v'_date_`s'_y)
			gen `v'_sensible=mdy(`v'_date_`s'_m, `v'_date_`s'_d, `v'_date_`s'_y)!=. & ///
								!missing(`v'_date_`s'_m) & !missing(`v'_date_`s'_d) & !missing(`v'_date_`s'_y)					
			gen `v'_missing=missing(`v'_date_`s'_m) & missing(`v'_date_`s'_d) & missing(`v'_date_`s'_y) & `v'_tick_`s'!=1
			summarize `v'_nonsensible
			local `v'_nonsensible `r(sum)'
			
			summarize `v'_sensible
			local `v'_sensible `r(sum)'
		
			summarize `v'_missing
			local `v'_missing `r(sum)'
			
			di "``v'_tick'"
			di "``v'_nonsensible'"
			di "``v'_sensible'"	
			di "``v'_missing'"
		}
		
		* Populate tick if nonsensible date
		noi di "Populate tick if date is nonsesible"
		foreach v in `shiftto' `shiftfrom' {
			replace `v'_tick_`s'=1 if `v'_nonsensible==1
		}
		
		
		if "`timeorder'"!="" {
			noi di "Arrange `shiftfrom' doses in timeorder..."
			local n 1	
			foreach v in `shiftfrom' {
				* Create full date variable
				gen v`n'=mdy(`v'_date_`s'_m, `v'_date_`s'_d, `v'_date_`s'_y)
				format %td v`n'
				
				local n `=`n' + 1'
			}
			local e `=`n'-1'
			
			rowsort v1-v`e', generate(order1-order`e')
			
			
			forvalues n = 1/`e' {
				format %td order`n'
				foreach m in m d y {
					if "`m'"=="m" {
						local l month
					}
					else if "`m'"=="d" {
						local l day
					}
					else if "`m'"=="y" {
						local l year
					}
						
					replace `=word("`shiftfrom'",`n')'_date_`s'_`m' =`l'(order`n')
				}
			}
		}
		
		
		* Create full variable dates
		foreach v in `shiftto' `shiftfrom' {
			gen `v'_date_`s'=mdy(`v'_date_`s'_m,`v'_date_`s'_d,`v'_date_`s'_y)
			format %td `v'_date_`s'
		}
		
		* Move each dose forward per users instructions
		if "`shiftwithin'"!="" & wordcount("`shiftto'") > 1 {
		
			no di "Make any replacements within `shiftto'"
			
			forvalues i = 1/`=`=wordcount("`shiftto'")'-1' {
				forvalues j = `=`i'+1'/`=wordcount("`shiftto'")' {
					local dosei `=word("`shiftto'",`i')'
					local dosej `=word("`shiftto'",`j')'
				
					gen shift_within_`dosei'_`dosej' = (missing(`=word("`shiftto'",`i')'_date_`s') & `=word("`shiftto'",`i')'_tick_`s'!=1) & ///
						         (!missing(`=word("`shiftto'",`j')'_date_`s') | `=word("`shiftto'",`j')'_tick_`s'==1) 
					label variable shift_within_`dosei'_`dosej' "Value of 1 Indicates that `dosej' will replace `dosei' due to missing `dosei'"
											 
					replace `=word("`shiftto'",`i')'_date_`s'=`=word("`shiftto'",`j')'_date_`s' if shift_within_`dosei'_`dosej' == 1
					replace `=word("`shiftto'",`i')'_tick_`s'=`=word("`shiftto'",`j')'_tick_`s' if shift_within_`dosei'_`dosej' == 1
					replace `=word("`shiftto'",`j')'_date_`s'=. if shift_within_`dosei'_`dosej' == 1
					replace `=word("`shiftto'",`j')'_tick_`s'=. if shift_within_`dosei'_`dosej' == 1
							
				}
			}
		}
		
		
		if "`shiftfrom'"!="" {
			no di "Make replacements from `shiftfrom' to `shiftto'"			
			forvalues i = 1/`=wordcount("`shiftto'")' {
				forvalues j = 1/`=wordcount("`shiftfrom'")' {
						local dosei `=word("`shiftto'",`i')'
						local dosej `=word("`shiftfrom'",`j')'
					
						gen shift_from_`dosei'_`dosej' = (missing(`=word("`shiftto'",`i')'_date_`s') & `=word("`shiftto'",`i')'_tick_`s'!=1) & ///
									 (!missing(`=word("`shiftfrom'",`j')'_date_`s') | `=word("`shiftfrom'",`j')'_tick_`s'==1) 
						label variable shift_from_`dosei'_`dosej' "Value of 1 Indicates that `dosej' will replace `dosei' due to missing `dosei'"
					 
						replace `=word("`shiftto'",`i')'_date_`s'=`=word("`shiftfrom'",`j')'_date_`s' if shift_from_`dosei'_`dosej' == 1
						replace `=word("`shiftto'",`i')'_tick_`s'=`=word("`shiftfrom'",`j')'_tick_`s' if shift_from_`dosei'_`dosej' == 1
						replace `=word("`shiftfrom'",`j')'_date_`s'=. if shift_from_`dosei'_`dosej' == 1
						replace `=word("`shiftfrom'",`j')'_tick_`s'=. if shift_from_`dosei'_`dosej' == 1
				}
			}
		}
		
		* replace date values
		noi di "Replace all date components where needed..."
		foreach v in `shiftto' {
			foreach m in m d y {
				if "`m'"=="m" {
					local i "month"
				}
				else if "`m'"=="d" {
					local i "day"
				}
				else if "`m'"=="y" {
					local i "year"
				}
				
				replace `v'_date_`s'_`m'=`i'(`v'_date_`s') if `v'_nonsensible!=1
			}
		}
		
		* Create dropping list for all variables that are not needed
		local dlist
		foreach v in `shiftto' `shiftfrom' {
			local dlist `dlist' `v'_nonsensible `v'_sensible `v'_missing `v'_nonsensible `v'_date_card
		}
		
		drop `dlist'
	
		no di "Save changes to file: `outputpath'"
		save, replace
		
	}
end
	
	
