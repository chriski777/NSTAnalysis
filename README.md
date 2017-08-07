# NST Analysis
Neural Spike Train Analysis. Allows one to import sorted Plexon files and perform a series of statistical analyses on neuronal discharge data through batch processing. 

## Table of Contents  
* [Calculation Types](#calcHeader)
* [SetUp Directories](#setHeader)
* [Prerequisite TODO](#preReqHeader)
* [Performing Calculations](#perfCalcHeader)
  * [Master Function](#masterHeader)
* [Visualization Functions](#visHeader)
  * [Rastor Plot](#rastorHeader)
  * [Cell ISI/Autocorrelogram](#cellISIHeader)
  * [Spike Density Function](#sdfHeader)
  * [2D ScatterPlot](#scatterTwoHeader)
  * [3D ScatterPlot](#scatterThreeHeader)
    * [ScatterPlot3d](#scatterThreeDHeader)
    * [allScatterPlot3d](#scatterallThreeDHeader)
* [Classification](#classHeader)  
  
<a name="calcHeader"/>

### Calculation Types
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
  
<a name="setHeader"/>  

### Setup Directories
Clone/download this repository and make sure to add all these folders to the current path in Matlab. Open_data.m, detecMove.m, and loadMoveFile are files that were created by a lab member Tim Whalen. I made edits to these files to make them compatible with the other files in this repository. These files are only included in this repo as they are needed to load the sorted neuron spike trains from Plexon. 

![screen shot 2017-08-06 at 6 01 51 pm](https://user-images.githubusercontent.com/10649054/29008821-fc7f414e-7ad1-11e7-8d51-ce0e8ce61f20.png)
Select the "Add with Subfolders" option and add the directory that contains the .PL2 files you would like to examine. 

<a name="preReqHeader"/>  

### Prerequisite To-Do List
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

<a name="perfCalcHeader"/>  

### Performing Calculations

<a name="masterHeader"/>  

#### Master
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
Please refer to the function scripts to read about what they exactly calculate. 
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

<a name="visHeader"/> 

### Visualizations

<a name="rastorHeader"/> 

#### RasterPlot
Rasterplot is a visualization function that can be used through the master function. 
```
master('rasterPlot', 'condition_name', 0)
```
You should get a rasterPlot for each spike train in your file.
![screen shot 2017-08-06 at 9 31 40 pm](https://user-images.githubusercontent.com/10649054/29012433-4a7d5aa2-7af0-11e7-93b4-ecc858bbf7ec.png)

<a name="cellISIHeader"/> 

#### CellByCellISIAutos
CellbycellISIAutos is a visualization script that can also be used through the master function. 
```
master('cellbycellISIAutos', 'condition_name', 0)
```
Each row of a figure will have an ISI and autocorrelogram corresponding to a single spike train.
![screen shot 2017-08-06 at 9 35 19 pm](https://user-images.githubusercontent.com/10649054/29012443-68600574-7af0-11e7-9fba-dcaae9b9916e.png)

Empty subplots indicate that the given spike train did not fire above the threshold firing rate. The threshold firing rate can be changed in the cellbycellISIAutos.m script. 

<a name="sdfHeader"/> 

#### SpikeDensityFunction
SpikeDensityFunction is a visualization script that can be used through the master function. It will show the spike density function results over multiple periods of movement. 

You can adjust the time before movement onSet(line 31) and after movement onSet (line 32) in the spikedensityFunction.m file. 
```
master('spikeDensityFunction', 'condition_name', 0)
```

![screen shot 2017-08-06 at 9 47 51 pm](https://user-images.githubusercontent.com/10649054/29012521-06236404-7af1-11e7-9a38-390db753b009.png)
The first 3 subplots show that there are no movements/ lack of movement periods that fit the minimum time length. The last subplot shows different movement phases along with their spike density. 

<a name="scatterTwoHeader"/> 

#### 2D ScatterPlot
ScatterPlot allows you to produce a 2 dimensional scatterPlot that plots the results of one function against the results of another. Keep in mind, the ScatterPlot **does NOT** apply the functions to the datasets. Rather, it reads the results and then plots the data points in the 2 feature parameter space. **Make sure to call the master function for the features first to get their results.**

The scatterPlot function is not used via the master function. 
It takes in 3 input parameters:
* First Function handle (String)
* Second Function handle (String)
* Type of Conditions You'd like to examine (String) : 'FULL' creates scatterplots for ALL conditions.

Format of scatterPlot command:
```
scatterPlot('function_one', 'function_two', 'Type')
```

![screen shot 2017-08-06 at 10 51 07 pm](https://user-images.githubusercontent.com/10649054/29014392-a396c292-7afd-11e7-9507-40bcdf448abf.png)

The plot above is produced when the statement 
```
scatterPlot('sampleSkew', 'fanoFactor', 'FULL')
```
is put in the command window. 

![screen shot 2017-08-06 at 10 51 33 pm](https://user-images.githubusercontent.com/10649054/29014381-9815ee16-7afd-11e7-9dc7-903c19c87cf2.png)

The plot above is produced when the statement
```
scatterPlot('sampleSkew', 'fanoFactor', 'Naive')
```
is put in the command window. 

<a name="scatterThreeHeader"/>

#### 3D ScatterPlot Visualization

<a name="scatterThreeDHeader"/>

##### ScatterPlot3D
ScatterPlot3D allows you to produce a 3 dimensional scatterPlot that plots a series of data points in a 3D feature space. Keep in mind, the ScatterPlot3D **does NOT** apply the functions to the datasets. Rather, it reads the results and then plots the data points in the 3 feature parameter space. **Make sure to call the master function for the features first to get their results.**

The scatterPlot3d function is not used via the master function. 
It takes in 3 input parameters:
* First Function handle (String)
* Second Function handle (String)
* Third Function handle (String)

```
scatterPlot3d('function_one', 'function_two', 'function_three')
```

![screen shot 2017-08-06 at 11 20 45 pm](https://user-images.githubusercontent.com/10649054/29014465-f4ac2bc2-7afd-11e7-9053-4956ceea3f6d.png)

A figure like the one above is produced for EACH of the conditions if the command:
```
scatterPlot3d('fanoFactor', 'sampleSkew', 'expFitResults')
```
is used.

![screen shot 2017-08-06 at 11 23 16 pm](https://user-images.githubusercontent.com/10649054/29014559-7727dc0e-7afe-11e7-803c-c72a54359afb.png)

Press the button covered by the blue rectangle to rotate the 3D plot. Pressing the red rectangle will allow you to click on a certain data point and see its corresponding x,y,z values along with its fileName and SPKC unit. 

![screen shot 2017-08-06 at 11 26 31 pm](https://user-images.githubusercontent.com/10649054/29014636-e276f3e6-7afe-11e7-86ac-912883eb3c41.png)

With the dataTip cursor, you can select a point and see something similar to what is shown above: 

<a name="scatterallThreeDHeader"/>

##### allscatterPlot3d
allscatterPlot3D plots **all** datapoints for **all conditions** in the **SAME** figure. Allscatterplot3d is useful in analyzing cumulative data (Similarities of features in Regular/Irregular/Burst neurons among ALL conditions). 

This function takes 4 input parameters: 
* First Function handle (String)
* Second Function handle (String)
* Third Function handle (String)
* Extra Functions cell (Cell)

The extra Functions cell should contain function handles that you'd like to see included in the dataTip. **The extra Functions you use must also have their results already calculated (Must have used master function for extra functions)**.  If you don't have any extra results you would like to see, just use an empty cell. 

```
dataTipCell = {'extFunction1',..., 'extFunctionN'};
allscatterPlot3d('function_one', 'function_two', 'function_three', dataTipCell)
```
![screen shot 2017-08-07 at 12 16 13 am](https://user-images.githubusercontent.com/10649054/29016081-bb10049e-7b05-11e7-9fcd-0342f7ac4807.png)

The following 3D plot is made when you type in the following commands:
```
dataTipCell = {'CV'};
allscatterPlot3d('sampleSkew', 'fanoFactor', 'expFitResults', dataTipCell)
```

### Using the Classifcation Scheme
