/**********************************************************************
Program Name:               Step04 - MICS to VCQI Conversion Steps 
Purpose:                    Create the datasets 
*													
Project:                    Q:\- WHO MICS VCQI-compatible\MICS manuals
Date Created:    			2016-04-28
Author:         Mary Kay Trimner
Stata version:    14.0
********************************************************************************/

set more off



do "${RUN_FOLDER}/MICS to VCQI - HH dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - HM dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - CM dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - RI dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - RIHC dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - SIA dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - TT dataset.do"
do "${RUN_FOLDER}/MICS to VCQI - levels of datasets.do" // Creates the levels of datasets
