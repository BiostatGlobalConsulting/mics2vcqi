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
global MICS_NUM 6 

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
global STRATUM_ID 				HH7
global STRATUM_NAME				HH7
global CLUSTER_ID 				HH1
global CLUSTER_NAME 			HH1

* Household ID 
global HH_ID 					HH2

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
global LEVEL1_NAME							// OPTIONAL- If you do not populate you need to edit program to create the dataset

* Provide the variable for Province ID (Level2 name)
global PROVINCE_ID 				1				// Populate with Variable Name or 1

* Name of Level3 stratifier
global LEVEL_3_ID				HH7				//OPTIONAL- If you do not populate you need to edit program to create the dataset

* Names for level 4
global LEVEL_4_ID 				HH6				// OPTIONAL- If you do not populate you need to edit program to create the dataset
*
********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create HH DATASET

* Date of HH interview
global HH_DATE_MONTH 			HH5m
global HH_DATE_DAY 				HH5d
global HH_DATE_YEAR 			HH5y

********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create HM DATASET

* House member line number in HM dataset
global HM_LINE 					HL1

* Variable that provides the outcome of the overall survey
* Example completed, refused, incomplete
global OVERALL_DISPOSITION 		HH46



* Populate the below with the variable names that correspond to the global names
global SEX 						HL4

* Set the below global if date of birth data was collected in the HH/HM survey 1==yes 0==NO
global HH_DOB					1

* Populate the below with the variable names that correspond tot he global names
global DATE_OF_BIRTH_MONTH		HL5M		// OPTIONAL -can be blank if not available
global DATE_OF_BIRTH_YEAR		HL5Y		// OPTIONAL -can be blank if not available
global DATE_OF_BIRTH_DAY					// OPTIONAL -can be blank if not available
global AGE_YEARS 				HL6 		// OPTIONAL -can be blank if not available
global AGE_MONTHS 							// OPTIONAL -can be blank if not available
	
********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create CM DATASET

* Provide the variable for the Post-stratified sampling weight for one-year cohorts (RI & TT)
global PSWEIGHT_1YEAR 			chweight

* Provide the variable for the Post-stratified sampling weight for SIA cohort
global PSWEIGHT_SIA 			hhweight

* Provide the variable that indicates if the area is urban or cluster
global URBAN_CLUSTER 			HH6

********************************************************************************
********************************************************************************
********************************************************************************

* * The below need to be defined to create RI DATASET 

* Was the RI Survey completed? 1 yes, 0 no
global RI_SURVEY				1

* Outcome for each RI survey if survey completed
* Example completed, refused, incomplete
global RI_DISPOSITION 			UF17

* Populate the below with the appropriate ages in months for the Child Survey if RI Survey completed
global RI_MIN_AGE				9
global RI_MAX_AGE				24

* Populate the below with the variable names that correspond to the global name if the RI Survey was completed
global CARD_EVER_RECEIVED 		IM3
global HAS_CARD					IM2
global CARD_SEEN 				IM5

* Date of RI interview
global RI_DATE_MONTH 			UF7M
global RI_DATE_DAY 				UF7D
global RI_DATE_YEAR 			UF7Y

* Child Date of Birth per history
* NOTE either History or Card date of birth must be populated.
* Both cannot be left blank.
global CHILD_DOB_HIST_MONTH		UB1M 		// OPTIONAL -can be blank if not available if CHILD_DOB_CARD_MONTH is provided
global CHILD_DOB_HIST_DAY		UB1D 		// OPTIONAL -can be blank if not available if CHILD_DOB_CARD_DAY is provided
global CHILD_DOB_HIST_YEAR		UB1Y 		// OPTIONAL -can be blank if not available if CHILD_DOB_CARD_YEAR is provided

* Child Age in Years
global CHILD_AGE_YEARS			UB2 		// OPTIONAL -can be blank if not available

* Child Age in Months
global CHILD_AGE_MONTHS			CAGE 		// OPTIONAL -can be blank if not available

* House member line number in Child dataset
global RI_LINE 					UF3

* Are there variables for CARD DOB? 1== yes 0==No
global CARD_DOB					0

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

global RI_LIST 		bcg hepb0 opv0 opv1 opv2 opv3 ipv penta1 penta2 penta3 pcv1 pcv2 pcv3 meas1 meas2 yf mena vita1 vita2 

* BCG 
global BCG_DATE_CARD_MONTH				IM6BM
global BCG_DATE_CARD_DAY				IM6BD
global BCG_DATE_CARD_YEAR				IM6BY

* OPV at Birth
global OPV0_DATE_CARD_MONTH				IM6P0M
global OPV0_DATE_CARD_DAY				IM6P0D
global OPV0_DATE_CARD_YEAR				IM6P0Y

* OPV doses 1-3
global OPV1_DATE_CARD_MONTH				IM6P1M
global OPV1_DATE_CARD_DAY				IM6P1D
global OPV1_DATE_CARD_YEAR				IM6P1Y

global OPV2_DATE_CARD_MONTH				IM6P2M
global OPV2_DATE_CARD_DAY				IM6P2D
global OPV2_DATE_CARD_YEAR				IM6P2Y

global OPV3_DATE_CARD_MONTH				IM6P3M
global OPV3_DATE_CARD_DAY				IM6P3D
global OPV3_DATE_CARD_YEAR				IM6P3Y

* DPT or PENTA doses 1-3
global PENTA1_DATE_CARD_MONTH			IM6PENTA1M
global PENTA1_DATE_CARD_DAY				IM6PENTA1D
global PENTA1_DATE_CARD_YEAR			IM6PENTA1Y

global PENTA2_DATE_CARD_MONTH			IM6PENTA2M
global PENTA2_DATE_CARD_DAY				IM6PENTA2D
global PENTA2_DATE_CARD_YEAR			IM6PENTA2Y

global PENTA3_DATE_CARD_MONTH			IM6PENTA3M
global PENTA3_DATE_CARD_DAY				IM6PENTA3D
global PENTA3_DATE_CARD_YEAR			IM6PENTA3Y

* Measles or MMR or MR
global MEAS1_DATE_CARD_MONTH			IM6N1M
global MEAS1_DATE_CARD_DAY				IM6N1D
global MEAS1_DATE_CARD_YEAR				IM6N1Y

global MEAS2_DATE_CARD_MONTH			IM6N2M
global MEAS2_DATE_CARD_DAY				IM6N2D
global MEAS2_DATE_CARD_YEAR				IM6N2Y


* Vitamin A
global VITA1_DATE_CARD_MONTH			IM6Z1M
global VITA1_DATE_CARD_DAY				IM6Z1D
global VITA1_DATE_CARD_YEAR				IM6Z1Y

global VITA2_DATE_CARD_MONTH			IM6Z2M
global VITA2_DATE_CARD_DAY				IM6Z2D
global VITA2_DATE_CARD_YEAR				IM6Z2Y

* Yellow Fever
global YF_DATE_CARD_MONTH				IM6YM
global YF_DATE_CARD_DAY					IM6YD
global YF_DATE_CARD_YEAR				IM6YY

* Meningitis Men A
global MENA_DATE_CARD_MONTH				IM6MVM
global MENA_DATE_CARD_DAY				IM6MVD
global MENA_DATE_CARD_YEAR				IM6MVY

* Hepb at birth
global HEPB0_DATE_CARD_MONTH			IM6H0M
global HEPB0_DATE_CARD_DAY				IM6H0D
global HEPB0_DATE_CARD_YEAR				IM6H0Y

* IPV
global IPV_DATE_CARD_MONTH				IM6IM
global IPV_DATE_CARD_DAY				IM6ID
global IPV_DATE_CARD_YEAR				IM6IY

* PCV doses 1-3
global PCV1_DATE_CARD_MONTH				IM6PCV1M
global PCV1_DATE_CARD_DAY				IM6PCV1D
global PCV1_DATE_CARD_YEAR				IM6PCV1Y

global PCV2_DATE_CARD_MONTH				IM6PCV2M
global PCV2_DATE_CARD_DAY				IM6PCV2D
global PCV2_DATE_CARD_YEAR				IM6PCV2Y

global PCV3_DATE_CARD_MONTH				IM6PCV3M
global PCV3_DATE_CARD_DAY				IM6PCV3D
global PCV3_DATE_CARD_YEAR				IM6PCV3Y

* Populate the below doses with the proper variable name per HIST DATA
* NOTE: If the vaccine is not part of the survey, leave it bank
* NOTE: If a vaccine is not listed below, create the globals with the same dose name provided in RI_LIST
* NOTE: *_DOSE_NUM is the question that indicates how many doses the caretaker says the child received.


//bcg hepb0 opv0 opv1 opv2 opv3 ipv penta1 penta2 penta3 pcv1 pcv2 pcv3 meas1 meas2 yf mena 

* BCG 
global BCG_DOSE_NUM					1
global BCG_HIST						IM14
global BCG_SCAR						

* OPV at Birth
global OPV0_HIST					IM17

* OPV
global OPV_DOSE_NUM					IM18
global OPV_HIST						IM16

* Need to also look this variable IM19 
* Asks if also received injection with drops
* CONFIRM THAT IM19 is for IPV_DATE_CARD_DAY
global IPV_DOSE_NUM 				1
global IPV_HIST						IM19

* DPT or PENTA doses 1-3
global PENTA_DOSE_NUM				IM21
global PENTA_HIST					IM20

* PCV doses 1-3
global PCV_DOSE_NUM					IM23
global PCV_HIST						IM22

* Measles or MMR or MR
global MEAS_DOSE_NUM				IM26A
global MEAS_HIST					IM26

* Hepb at birth
global HEPB0_HIST					IM15

* Yellow Fever
global YF_DOSE_NUM					1
global YF_HIST						IM27

* Vitamin A doses 1-2
global VITA_DOSE_NUM				1
global VITA_HIST					IM27B


* Meningitis A
global MENA_DOSE_NUM				1
global MENA_HIST 					IM27A

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
global PENTA1_DATE_REG_MONTH		
global PENTA1_DATE_REG_DAY			
global PENTA1_DATE_REG_YEAR		

global PENTA2_DATE_REG_MONTH		
global PENTA2_DATE_REG_DAY			
global PENTA2_DATE_REG_YEAR		

global PENTA3_DATE_REG_MONTH		
global PENTA3_DATE_REG_DAY			
global PENTA3_DATE_REG_YEAR		

* Measles or MMR or MR
global MEAS1_DATE_REG_MONTH		
global MEAS1_DATE_REG_DAY			
global MEAS1_DATE_REG_YEAR			

global MEAS2_DATE_REG_MONTH		
global MEAS2_DATE_REG_DAY			
global MEAS2_DATE_REG_YEAR			


* Vitamin A
global VITA1_DATE_REG_MONTH		
global VITA1_DATE_REG_DAY			
global VITA1_DATE_REG_YEAR			

global VITA2_DATE_REG_MONTH		
global VITA2_DATE_REG_DAY			
global VITA2_DATE_REG_YEAR			

* Yellow Fever
global YF_DATE_REG_MONTH			
global YF_DATE_REG_DAY				
global YF_DATE_REG_YEAR			

* Meningitis Men A
global MENA_DATE_REG_MONTH			
global MENA_DATE_REG_DAY			
global MENA_DATE_REG_YEAR			

* Hepb at birth
global HEPB0_DATE_REG_MONTH		
global HEPB0_DATE_REG_DAY			
global HEPB0_DATE_REG_YEAR			

* IPV
global IPV_DATE_REG_MONTH			
global IPV_DATE_REG_DAY			
global IPV_DATE_REG_YEAR			

* PCV doses 1-3
global PCV1_DATE_REG_MONTH			
global PCV1_DATE_REG_DAY			
global PCV1_DATE_REG_YEAR			

global PCV2_DATE_REG_MONTH			
global PCV2_DATE_REG_DAY			
global PCV2_DATE_REG_YEAR			

global PCV3_DATE_REG_MONTH			
global PCV3_DATE_REG_DAY			
global PCV3_DATE_REG_YEAR			

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
