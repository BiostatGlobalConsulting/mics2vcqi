/**********************************************************************
Program Name:               VCQI Conversion and Global Macro List - MICS to VCQI 
Purpose:                    User populates the below globals and the values are used to convert the dataset to VCQI 
*							
Project:                    Q:\- WHO MICS VCQI-compatible\MICS manuals
Date Created:    			2016-04-28
Author:         			Mary Kay Trimner
Stata version:    			14.0
********************************************************************************/
* This program converts MICS survey data to VCQI compatible datasets. 
* Before running this program, you will need to convert the MICS survey data (SPSS Datasets) to a Stata dataset through StatTransfer
* All date components will need to be broken into 3 separate variables; month, day and year.

* Set maxvar so there are no issues with the size of the dataset
clear 				// Need to clear out any existing data to run the next command
clear mata		 	// Need to clear out mata to avoid errors.
set maxvar 32767	// Change maxvar to the largest possible value to avoid errors while importing data.

* The majority of the globals listed below are required in order to run this program.
* However, some are not needed but if populated can help provide additional information to the dataset. These will be noted as optional.

* Populate the below global with the version of MICS survey that is being used (example 3, 4, or 5)
global MICS_NUM 4 

* Path where MICS to VCQI Conversion programs are saved
global RUN_FOLDER 

* Path where STATA will grab the original MICS stata datasets
global INPUT_FOLDER 
			
* Path where you would like STATA to put the new datasets that can be run through VCQI
global OUTPUT_FOLDER 
			
* Name of MICS Datasets that will be used to create the VCQI Datasets
global MICS_HH_DATA 	hh.dta 	//Household dataset
global MICS_HM_DATA 	hl.dta 	//Household list/member dataset
global MICS_WM_DATA 	wm.dta 	//Women's /TT dataset
global MICS_CH_DATA 	ch.dta 	//Child dataset/RI & SIA
global MICS_HF_DATA				//Register data if separate dataset from CH data


********************************************************************************
********************************************************************************
********************************************************************************

*  The below global macros need to be defined to create HH, CM HM, RI, RIHC, SIA, TT DATASET
*  Populate with corresponding variable name 
* 
global STRATUM_ID 				hh7
global STRATUM_NAME				hh7
global CLUSTER_ID 				hh1
global CLUSTER_NAME 			hh1

* Household ID 
global HH_ID 					hh2

* The below are used to populate the levels of datasets that VCQI uses.
* They are not required but will be used to create level1 and level4 datasets if populated.
* Level 2 will be populated with PROVINCE_ID provided below
* Level 3 will be populated with STRATUM_ID provided above 
* You can edit the MICS to VCQI -levels of datasets program if you do not want to use these values for Level2 and Level3.
* If the below globals are not populated, you will need to edit the program MICS to VCQI -levels of datasets to create these datasets.

* You will also need to edit the program MICS to VCQI -levels if you want to change the order.
* Current order is _n by levelid.
* See user guide for specifics around each level

* Name of Nation to be used in LEVEL1 dataset name
global LEVEL1_NAME				NIGERIA			// OPTIONAL- If you do not populate you need to edit program to create the dataset

* Provide the variable for Province ID (Level2 name)
global PROVINCE_ID 				1				// Populate with Variable Name or 1

* Name of Level3 stratifier
global LEVEL_3_ID				hh7				//OPTIONAL- If you do not populate you need to edit program to create the dataset

* Names for level 4
global LEVEL_4_ID 				hh6				// OPTIONAL- If you do not populate you need to edit program to create the dataset
*
********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create HH DATASET

* Date of HH interview
global HH_DATE_MONTH 			hh5m
global HH_DATE_DAY 				hh5d
global HH_DATE_YEAR 			hh5y

********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create HM DATASET

* House member line number in HM dataset
global HM_LINE 					hl1

* Variable that provides the outcome of the overall survey
* Example completed, refused, incomplete
global OVERALL_DISPOSITION 		hh9



* Populate the below with the variable names that correspond to the global names
global SEX 						hl4

* Set the below global if date of birth data was collected in the HH/HM survey 1==yes 0==NO
global HH_DOB					1

* Populate the below with the variable names that correspond tot he global names
global DATE_OF_BIRTH_MONTH		hl5m		// OPTIONAL -can be blank if not available
global DATE_OF_BIRTH_YEAR		hl5y		// OPTIONAL -can be blank if not available
global DATE_OF_BIRTH_DAY					// OPTIONAL -can be blank if not available
global AGE_YEARS 				hl6 		// OPTIONAL -can be blank if not available
global AGE_MONTHS 							// OPTIONAL -can be blank if not available
	
********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create CM DATASET

* Provide the variable for the Post-stratified sampling weight for one-year cohorts (RI & TT)
global PSWEIGHT_1YEAR 			hhweight

* Provide the variable for the Post-stratified sampling weight for SIA cohort
global PSWEIGHT_SIA 			hhweight

* Provide the variable that indicates if the area is urban or cluster
global URBAN_CLUSTER 			hh6

********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create RI DATASET 

* Was the RI Survey completed? 1 yes, 0 no
global RI_SURVEY				1

* Outcome for each RI survey if survey completed
* Example completed, refused, incomplete
global RI_DISPOSITION 			uf9

* Populate the below with the appropriate ages in months for the Child Survey if RI Survey completed
global RI_MIN_AGE				9
global RI_MAX_AGE				24

* Populate the below with the variable names that correspond to the global name if the RI Survey was completed
global CARD_EVER_RECEIVED 		im2
global CARD_SEEN 				im1

* Date of RI interview
global RI_DATE_MONTH 			uf8m
global RI_DATE_DAY 				uf8d
global RI_DATE_YEAR 			uf8y

* Child Date of Birth per history
* NOTE either History or Card date of birth must be populated.
* Both cannot be left blank.
global CHILD_DOB_HIST_MONTH		ag1m 		// OPTIONAL -can be blank if not available if CHILD_DOB_CARD_MONTH is provided
global CHILD_DOB_HIST_DAY		ag1d 		// OPTIONAL -can be blank if not available if CHILD_DOB_CARD_DAY is provided
global CHILD_DOB_HIST_YEAR		ag1y 		// OPTIONAL -can be blank if not available if CHILD_DOB_CARD_YEAR is provided

* Child Age in Years
global CHILD_AGE_YEARS			ag2 		// OPTIONAL -can be blank if not available

* Child Age in Months
global CHILD_AGE_MONTHS			cage 		// OPTIONAL -can be blank if not available

* House member line number in Child dataset
global RI_LINE 					uf4

* Are there variables for CARD DOB? 1== yes 0==No
global CARD_DOB					1

* Child Date of Birth per CARD
* NOTE either History or Card date of birth must be populated.
* Both cannot be left blank.
global CHILD_DOB_CARD_MONTH					// OPTIONAL -can be blank if not available if CHILD_DOB_HIST_MONTH is provided
global CHILD_DOB_CARD_DAY       			// OPTIONAL -can be blank if not available if CHILD_DOB_HIST_DAY is provided
global CHILD_DOB_CARD_YEAR      			// OPTIONAL -can be blank if not available if CHILD_DOB_HIST_YEAR is provided

* Populate the below doses with the proper variable name per CARD DATA
* NOTE: If the vaccine is not part of the survey, leave it bank
* NOTE: If a vaccine is not listed below, create the globals with the same dose name provided in RI_LIST

* Provide a complete list of the RI doses, use the same dose names as the globals below
* All dose numbers must be provided, so if there are three doses provide the dose1 dose2 dose3.

global RI_LIST 		bcg opv0 opv1 opv2 opv3 dpt1 dpt2 dpt3

* BCG 
global BCG_DATE_CARD_MONTH				im3bm
global BCG_DATE_CARD_DAY				im3bd
global BCG_DATE_CARD_YEAR				im3by

* OPV at Birth
global OPV0_DATE_CARD_MONTH				im3p0m
global OPV0_DATE_CARD_DAY				im3p0d
global OPV0_DATE_CARD_YEAR				im3p0y

* OPV doses 1-3
global OPV1_DATE_CARD_MONTH				im3p1m
global OPV1_DATE_CARD_DAY				im3p1d
global OPV1_DATE_CARD_YEAR				im3p1y

global OPV2_DATE_CARD_MONTH				im3p2m
global OPV2_DATE_CARD_DAY				im3p2d
global OPV2_DATE_CARD_YEAR				im3p2y

global OPV3_DATE_CARD_MONTH				im3p3m
global OPV3_DATE_CARD_DAY				im3p3d
global OPV3_DATE_CARD_YEAR				im3p3y

* DPT or PENTA doses 1-3
global DPT1_DATE_CARD_MONTH				im3d1m
global DPT1_DATE_CARD_DAY				im3d1d
global DPT1_DATE_CARD_YEAR				im3d1y

global DPT2_DATE_CARD_MONTH				im3d2m
global DPT2_DATE_CARD_DAY				im3d2d
global DPT2_DATE_CARD_YEAR				im3d2y

global DPT3_DATE_CARD_MONTH				im3d3m
global DPT3_DATE_CARD_DAY				im3d3d
global DPT3_DATE_CARD_YEAR				im3d3y

* Measles or MMR or MR
global MCV_DATE_CARD_MONTH				im3mm
global MCV_DATE_CARD_DAY				im3md
global MCV_DATE_CARD_YEAR				im3my

* Hepb at birth
global HEPB0_DATE_CARD_MONTH			im3h0m
global HEPB0_DATE_CARD_DAY				im3h0d
global HEPB0_DATE_CARD_YEAR				im3h0y

* Hepb doses 1-3
global HEPB1_DATE_CARD_MONTH			im3h1m
global HEPB1_DATE_CARD_DAY				im3h1d
global HEPB1_DATE_CARD_YEAR				im3h1y

global HEPB2_DATE_CARD_MONTH			im3h2m
global HEPB2_DATE_CARD_DAY				im3h2d
global HEPB2_DATE_CARD_YEAR				im3h2y

global HEPB3_DATE_CARD_MONTH			im3h3m
global HEPB3_DATE_CARD_DAY				im3h3d
global HEPB3_DATE_CARD_YEAR				im3h3y

* Yellow Fever
global YF_DATE_CARD_MONTH				im3ym
global YF_DATE_CARD_DAY					im3yd
global YF_DATE_CARD_YEAR				im3yy

* Vitamin A doses 1-2
global VITA1_DATE_CARD_MONTH			im3vm
global VITA1_DATE_CARD_DAY				im3vd
global VITA1_DATE_CARD_YEAR				im3vy

global VITA2_DATE_CARD_MONTH
global VITA2_DATE_CARD_DAY
global VITA2_DATE_CARD_YEAR

* HIB doses 1-3
global HIB1_DATE_CARD_MONTH
global HIB1_DATE_CARD_DAY
global HIB1_DATE_CARD_YEAR

global HIB2_DATE_CARD_MONTH
global HIB2_DATE_CARD_DAY
global HIB2_DATE_CARD_YEAR

global HIB3_DATE_CARD_MONTH
global HIB3_DATE_CARD_DAY
global HIB3_DATE_CARD_YEAR


* Populate the below doses with the proper variable name per HIST DATA
* NOTE: If the vaccine is not part of the survey, leave it bank
* NOTE: If a vaccine is not listed below, create the globals with the same dose name provided in RI_LIST
* NOTE: *_DOSE_NUM is the question that indicates how many doses the caretaker says the child received.

* BCG 
global BCG_DOSE_NUM					1
global BCG_HIST						im7
global BCG_SCAR						

* OPV at Birth
global OPV0_HIST					im9

* OPV
global OPV_DOSE_NUM					im10
global OPV_DOSE_NUM_MISSING			9 // if im10 is 9 it means missing...not 9
global OPV_HIST						im8

* DPT or PENTA doses 1-3
global DPT_DOSE_NUM					im12
global DPT_DOSE_NUM_MISSING			9 // if im12b is 9 it means missing, not 9
global DPT_HIST						im11


* Measles or MMR or MR
global MCV_DOSE_NUM					1
global MCV_HIST						im16

* Hepb at birth
global HEPB0_HIST					im14

* Hepb
global HEPB_DOSE_NUM				im15
global HEPB_HIST					im13


* Yellow Fever
global YF_DOSE_NUM					1
global YF_HIST						im17

* Vitamin A doses 1-2
global VITA_DOSE_NUM				1
global VITA_HIST					im18

* PCV
global PCV_DOSE_NUM					im15b
global PCV_DOSE_NUM_MISSING			9 // if im15b is 9, it means missing...not 9
global PCV_HIST						im15a


* HIB doses 1-3
global HIB_DOSE_NUM
global HIB_DOSE_NUM_MISSING			9 // if im15b is 9, it means missing...not 9
global HIB_HIST


* Additional variables to keep (usually multiple choice questions)
* e.g. religion, education etc
global RI_ADDITIONAL_VARS

********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create RIHC DATASET
* Was the RIHC/Health Center Data collected? 1 yes, 0 No
global RIHC_SURVEY 				0

* Populate the below with the variable names that correspond to the global name per Health Center Records if RIHC survey completed

* Child line number
global RIHC_LINE 				hf4

* Date of RIHC/Health Center Visit
global RIHC_DATE_MONTH 			hf8m
global RIHC_DATE_DAY 			hf8d
global RIHC_DATE_YEAR 			hf8y


* Child Date of Birth per Health Center Records/Register
global CHILD_DOB_REG_MONTH 		hf12m 
global CHILD_DOB_REG_DAY 		hf12d
global CHILD_DOB_REG_YEAR 		hf12y

* Populate the below doses with the proper variable name per HEALTH CENTER/REGISTER DATA
* NOTE: If the vaccine is not part of the survey, leave it bank
* NOTE: If a vaccine is not listed below, create the globals with the same dose name provided in RI_LIST

* BCG 
global BCG_DATE_REG_MONTH
global BCG_DATE_REG_DAY
global BCG_DATE_REG_YEAR

* OPV at Birth
global OPV0_DATE_REG_MONTH
global OPV0_DATE_REG_DAY
global OPV0_DATE_REG_YEAR

* OPV doses 1-3
global OPV1_DATE_REG_MONTH
global OPV1_DATE_REG_DAY
global OPV1_DATE_REG_YEAR

global OPV2_DATE_REG_MONTH
global OPV2_DATE_REG_DAY
global OPV2_DATE_REG_YEAR

global OPV3_DATE_REG_MONTH
global OPV3_DATE_REG_DAY
global OPV3_DATE_REG_YEAR

* DPT or PENTA doses 1-3
global DPT1_DATE_REG_MONTH
global DPT1_DATE_REG_DAY
global DPT1_DATE_REG_YEAR

global DPT2_DATE_REG_MONTH
global DPT2_DATE_REG_DAY
global DPT2_DATE_REG_YEAR

global DPT3_DATE_REG_MONTH
global DPT3_DATE_REG_DAY
global DPT3_DATE_REG_YEAR

* Measles or MMR or MR
global MCV_DATE_REG_MONTH
global MCV_DATE_REG_DAY
global MCV_DATE_REG_YEAR

* Hepb at birth
global HEPB0_DATE_REG_MONTH
global HEPB0_DATE_REG_DAY
global HEPB0_DATE_REG_YEAR

* Hepb doses 1-3
global HEPB1_DATE_REG_MONTH
global HEPB1_DATE_REG_DAY
global HEPB1_DATE_REG_YEAR

global HEPB2_DATE_REG_MONTH
global HEPB2_DATE_REG_DAY
global HEPB2_DATE_REG_YEAR

global HEPB3_DATE_REG_MONTH
global HEPB3_DATE_REG_DAY
global HEPB3_DATE_REG_YEAR

* Yellow Fever
global YF_DATE_REG_MONTH
global YF_DATE_REG_DAY
global YF_DATE_REG_YEAR

* Vitamin A doses 1-2
global VITA1_DATE_REG_MONTH
global VITA1_DATE_REG_DAY
global VITA1_DATE_REG_YEAR

global VITA2_DATE_REG_MONTH
global VITA2_DATE_REG_DAY
global VITA2_DATE_REG_YEAR

* HIB doses 1-3
global HIB1_DATE_REG_MONTH
global HIB1_DATE_REG_DAY
global HIB1_DATE_REG_YEAR

global HIB2_DATE_REG_MONTH
global HIB2_DATE_REG_DAY
global HIB2_DATE_REG_YEAR

global HIB3_DATE_REG_MONTH
global HIB3_DATE_REG_DAY
global HIB3_DATE_REG_YEAR

********************************************************************************
********************************************************************************
********************************************************************************
* * The below need to be defined to create SIA DATASET

* Was the SIA Survey completed? 1 yes, 0 no
global SIA_SURVEY				1

* Outcome for SIA survey if survey completed
* Example completed, refused, incomplete
global SIA_DISPOSITION 			uf9

* Populate the below global with the list of vaccines received in SIA campaign if the SIA Survey was completed
* These should be consistent with the SIA_MIN/MAX_AGE_* globals, and include either the Campaign letter or the dose name.
global SIA_LIST 				A B 

* For all global macros specific to a campaign:
* Make sure the global name is consistent with the Doses provided in global SIA_LIST.
* If SIA_LIST is populated with the Campaign letter (A, B, or C) the global macros must have the letter in their name.
* If SIA_LIST is populated with the dose name, the global macros must have the Dose name and not Campaign letter.
* NOTE Additional globals may need to be created if there are more than 3 campaigns. 
* Create them with the same format and the appropriate campaign name (dose name or letter)

* Populate the below with the appropriate ages in months for the Campaign Survey if SIA Survey completed
* Fill in the appropriate global for which dose the campaign was for
global SIA_MIN_AGE_A				12
global SIA_MAX_AGE_A				`=15*12'

global SIA_MIN_AGE_B				9
global SIA_MAX_AGE_B				`=15*12'

global SIA_MIN_AGE_C				
global SIA_MAX_AGE_C				

* Populate the below with the variable names that correspond to the global name
* Variable that indicates if child was vaccinated in SIA campaign.
* NOTE These only need to be populated for the campaigns that were completed.
* NOTE These are typically found in the children's dataset.
global SIA_A					im19a
global SIA_B					im19b
global SIA_C					

********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create TT DATASET
* Was the TT/Women's survey completed? 1 yes, 0 no
global TT_SURVEY				1

* Outcome for TT survey if survey completed
* Example completed, refused, incomplete
global TT_DISPOSITION 			wm7

* Populate the below with the appropriate ages in months for the Women's TT Survey if TT Survey completed
global TT_MIN_AGE				`=15*12'
global TT_MAX_AGE				`=50*12'	


* Populate the below with the variable names that correspond to the global name if the TT Survey was completed
* House member line number in Women's dataset
global TT_LINE 					wm4

* Date of TT/Women's interview
global TT_DATE_MONTH 			wm6m
global TT_DATE_DAY 				wm6d
global TT_DATE_YEAR 			wm6y

* Populate the below if Mother DOB was collected 1==yes, 0==no
global MOTHER_DOB				1

* Women's Date of birth
global MOTHER_DOB_MONTH			wb1m
global MOTHER_DOB_YEAR			wb1y
global MOTHER_DOB_DAY						// OPTIONAL -can be blank if not available

* Age of Mother in years
global MOTHER_AGE_YEARS			 wb2 		// OPTIONAL -can be blank if not available

* Was the Mothers card or document with their own immunizations seen?
global MOTHER_CARD_SEEN 		mn5

* What was the date of the last birth?
global TT_CHILD_DOB_MONTH		cm12m  		// OPTIONAL -can be blank if not available
global TT_CHILD_DOB_DAY				   		// OPTIONAL -can be blank if not available
global TT_CHILD_DOB_YEAR		cm12y  		// OPTIONAL -can be blank if not available
		
* TT received during last pregnancy?
global TT_PREGNANCY 			mn6

* Number of TT doses received during last pregnancy
global NUM_TT_PREGNANCY 		mn7

* TT received at any time prior to last pregnancy?
* When not pregnant or previous pregnancy
global TT_ANYTIME 				mn9

* Number of TT doses received prior to last pregnancy
global NUM_TT_ANYTIME 			mn10

* Month and Year of TT dose
global LAST_TT_MONTH			tt7m		// OPTIONAL -can be blank if not available
global LAST_TT_YEAR				tt7y		// OPTIONAL -can be blank if not available

* How many years since last TT
global YEARS_SINCE_LAST_TT 		mn11

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
* Delete any existing combined dataset files
capture confirm file "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset.dta" 
if !_rc {
	erase "${OUTPUT_FOLDER}/MICS_${MICS_NUM}_combined_dataset.dta" 
}

set more off

* Run the program to create the datasets
do "${RUN_FOLDER}/Step00 - VCQI Conversion Steps.do" // Runs all the necessary steps to make dataset VCQI compatible
