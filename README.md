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
  * Double Exponential (DExp) Fit of Autocorrelograms
  * ISI Histogram Visualization
  * ISI Converter 
  * Kurtosis
  * Pearson's moment coefficient of Skewness
  * Fano Factor (Darin, Soares, Wichmann 2006)
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
    * Keep in mind your animalcodes should correspond to the number of files you add. 

* Create an excel file named 'custClassification.xlsx'. You should have a separate sheet for each condition/case you have in dataInitializer.m. 

# References 
