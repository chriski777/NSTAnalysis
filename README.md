# NST Analysis
Neural Spike Train Analysis. Allows one to import sorted Plexon files and perform a series of statistical analyses on neuronal discharge data through batch processing. 
* Calculations/Types of Analyses one can perform include: 
  * Measures of Central Tendency of ISI distribution: Standard deviation and Mean
  * Mean FR 
  * CV 
  * CV2 (Nawrot et al., 2008)
  * Approximate Entropy (Pincus 1991)
  * dApEn (Darin, Soares, Wichmann 2006)
  * Raster Plot Visualization
  * Autocorrelogram Visualization
  * 2-D ScatterPlot Visualization
  * 3-D ScatterPlot Visualization
  * Double Exponential (DExp) Fit of Autocorrelograms
  * ISI Histogram Visualization
  * ISI Converter 
  * Kurtosis
  * Pearson's moment coefficient of Skewness
  * Fano Factor (Darin, Soares, Wichmann 2006), (Eden & Kramer 2010)
  * Non-parametric skew of ISI distribution
  * Pearson mode Skew 
  * Spike Density Function 
    * Movement-specific Spike Density Function
  * StatAv 
* Coming Soon
  * Hurst Exponent
## Setup Directories
Clone/download this repository and make sure to add all these folders to the current path in Matlab. Open_data.m, detecMove.m, and loadMoveFile are files that were created by a lab member Tim Whalen. I made edits to these files to make them compatible with the other files in this repository. These files are only included in this repo as they are needed to load the sorted neuron spike trains from Plexon. 

![screen shot 2017-08-06 at 6 01 51 pm](https://user-images.githubusercontent.com/10649054/29008821-fc7f414e-7ad1-11e7-8d51-ce0e8ce61f20.png)
Select the "Add with Subfolders" option and add the directory that contains the .PL2 files you would like to examine. 

## Prerequisite To-Do List
* Know how many classes of in-vivo data you would like to examine. This depends on the number of conditions you would like to study: Acute, Gradual, Alpha-Syn, etc. If you just want results for a given dataset, just use one condition.
* Make sure the condition you want is included in the switch cases of the dataInitializer.m file. 

![screen shot 2017-08-06 at 6 28 01 pm](https://user-images.githubusercontent.com/10649054/29009110-2a0fcd06-7ad5-11e7-9928-866e23321688.png)

* Also include the condition in the master.m. Make sure to delete the condtions that are not being used from the typeNames array and the corresponding elseif statement. Add elseif statements for your condition and add the condition into the typeNames array. 

![screen shot 2017-08-06 at 7 44 18 pm](https://user-images.githubusercontent.com/10649054/29010466-575ac8dc-7ae0-11e7-9481-94de3ea8fcb6.png)


   * Currently, there are eight cases (Acute, Alpha-Syn, Gradual, Gradual 35%, Gradual 65%, Naive, Unilateral Depleted, Unilateral Intact) in the dataInitializer.m file. **It is important that you delete the cases along with the files and animalcodes. You will encounter an error unless you have the files listed in the dataInitializer.m file.**

   * To add cases, follow this format: 
     ```
     case 'CONDITION_NAME'
         input.files = {
             %1 From animal one
             'FILENAMEUNITONESorttt.pl2;'
             'FILENAMEUNITTWOSorttt.pl2;'  

             %2 From animal two
             'FILENAMEUNITONESorttt.pl2;'
             'FILENAMEUNITTWOSorttt.pl2;'       
             'FILENAMEUNITTHREESorttt.pl2;'   
             };
         input.animalcodes = [1 1 2 2 2];
         data = open_data(input);
     ```
    *  **Please follow the naming convention of naming a PL2 file as 'fileNameAWsorttt-01.pl2'.**
    * Keep in mind your animalcodes should correspond to the number of files you add. 
    
* Create an excel file named 'custClassification.xlsx'. Create a separate sheet for each condition/case you have in dataInitializer.m. 
![screen shot 2017-08-06 at 7 19 26 pm](https://user-images.githubusercontent.com/10649054/29009943-879e6f16-7adc-11e7-9c5e-346423b1d7d2.png)

Follow this format and define four columns that contain **conditionFileName, conditionSPKC, conditionUnit, conditionRegularIrregularBurst'**. The SpKC and unit information can be found via NeuroExplorer. Make sure to have a row in the excel sheet for each file you add in dataInitializer. If the class is unknown, simply put 'No Class'. Once you set the dataInitializer and custClassificaiton file up, you should be good to go. 

## Performing Calculations

### Master
The master Function will be the most important function you will use in batch processing a certain analysis script.
The master function takes in three parameters:
* Handle of function you would like to apply (String). Functions are limited to functions in the Functions directory.
* The conditions you would like to apply (String). Conditions are 'FULL' (Applies to all conditions) , and the strings of the conditions you have defined: 'Acute', 'Alpha-Syn', etc. 
* Third parameter: Will be updated in the future. Just use 0 for now. 
```
%To calculate the statAv parameter for all conditions you have defined, put this command in the command window of Matlab
master('statAv', 'FULL', 0)

%To calculate the AppEntropy parameter for a condition 'condition_name' you have defined, put this command in the command window of Matlab:

master('AppEntropy', 'condition_name', 0)

```
This will create a results folder along with the results for each condition. 
The following functions can be used as function handles: 
* 'AppEntropy'
* 'CV'
* 'CV2'
* 'ISIKurtosis'
* 'allstdISI'
* 'cellbycellISIAutos'
* 'dApEn' (only compatible once you calculate AppEntropy and shuffledApEn)
* 'classISIHists'
* 'spikedensityfunction'
* 'expFitAutos'
* 'expFitResults'
* 'fanoFactor'
* 'meanFR'
* 'meanISI'
* 'nonParametricSkew'
* 'pearsonModeSkew'
* 'pearsonSecSkew'
* 'sampleSkew'
* 'shuffledApEn'
* 'statAv'
* 'rasterPlot'

Parameters for these function handles can be adjusted in the mapper.m file. 
