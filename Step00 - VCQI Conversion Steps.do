/**********************************************************************
Program Name:               Step00 - VCQI Conversion Steps 
Purpose:                    Create the datasets based on survey type
*													
Project:                    Q:\- WHO (MICS/DHS) VCQI-compatible\(MICS/DHS) manuals
Date Created:    			2016-06-21
Author:         Mary Kay Trimner
Stata version:    14.0
********************************************************************************/
if "$MICS_NUM" !="" {
	local program MICS
}
else if "$DHS_NUM" != "" {
	local program DHS
}

do "${RUN_FOLDER}/Step01 - `program' to VCQI Conversion Steps"
do "${RUN_FOLDER}/Step02 - `program' to VCQI Conversion Steps"
do "${RUN_FOLDER}/Step03 - `program' to VCQI Conversion Steps"
do "${RUN_FOLDER}/Step04 - `program' to VCQI Conversion Steps"
do "${RUN_FOLDER}/Step05 - MICS to VCQI Add Campaign doses to History"
