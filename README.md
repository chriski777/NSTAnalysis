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
  
# SETUP
Clone/download this reposityory and make sure to add all these folders to the current path in Matlab. Open_data.m, detecMove.m, and loadMoveFile are files that were created by a lab member Tim Whalen. I made edits to these files to make them compatible with the other files in this repository. These files are only included in this repo as they are needed to load the sorted neuron spike trains from Plexon. 

# References 
