# NLPCA-SOM
Clustering using Self-Organizing Maps through Non-Linear Principal Components Analysis - Rainfalls in Southwestern Colombia

## Abstract

The knowledge of rainfall regimes is a prerequisite necessary for many activities such as water resources management, mitigation of risks, planning of socioeconomic activities and other hydrologic applications. In this paper, the use of non-linear principal component analysis (NLPCA) and self-organized feature map (SOM), as non-linear techniques are applied to identify the homogenous regions for monthly rainfall in the southwestern of Colombia. SOM was applied to a network of 44 monthly rainfall gauge stations represent in five principal components using NLPCA. The NLPCA coefficients represent the dimension reduction in the period from January of 1983 to December of 2016 into five principal components for each gauge station. The two-dimensional SOM indicates that rainfall gauges can be grouped into two clusters. A heterogeneity test showed that the two regions are acceptably homogeneous and depict the main features of the monthly rainfall variability over the study area. Besides, both identified clusters show two types of rainfall regime: bimodal in the Andean Region and unimodal in the Pacific Region. The bimodal regimes predominate in the mountainous area and the unimodal regime over the coastal zone. The application of SOM provided a better understanding of the seasonality and spatiality of rainfall.
The advantages of NLPCA and SOM are three points:
-	The application of NLPCA allows the reduction of dimensions and extraction of the main features of rainfall datasets.
-	SOM is an artificial neural network useful for the classification and identification of homogeneous climate zones.
-	The combination of NLPCA and SOM is an efficient approach for the classification of monthly rainfall in southwestern Colombia.

## Data
The dataset of monthly rainfall used in this study was obtained from 44-gauge stations located in different zones in the Southwestern Colombia (Nariño) (<a href='#GeoLo'>Fig. 1</a>), available in Canchala et al [1]. The time series analyzed covers 34 years of observation between 1983 and 2016.
<p align='center'><img id='GeoLo' src='figures/GeographicLocation.png' style='width:800px'></p>
<p align='center'><caption><b> Figure 1. Geographic location of the study area and distribution of rainfall stations</b> </caption></p>

## Method
The methodology proposed in this study was developed according to the flowchart presented in <a href='#Method'>Fig. 2</a>. The regionalization of monthly rainfall was performed using two nonlinear techniques: NLPCA and SOM. NLPCA was used to reduce the dimensionality of the dataset, and SOM to identify regions with homogeneous rainfall.
<p align='center'><img id='Method' src='figures/Methodology.png' style='width:600px'></p>
<p align='center'><caption><b> Figure 2. Flowchart of methodology</b> </caption></p>

### Non-Linear principal component analysis (NLPCA) 
NLPCA operates by training a feed-forward neural network to perform the identity mapping, where the network inputs are reproduced at the output layer. The network contains an internal "bottleneck" layer that allows generating a compact representation of the input data. This technique successfully reduces the dimensionality and create a feature space map similar to the actual distribution of the underlying system parameters [37]. The scheme of NLPCA is shown in <a href='#nlpca'>Fig. 3</a>. In this, the dimensions of x y h(x) are n and m, respectively, where x is the input column vector of length n, and m is the number of hidden neurons in the encoding and decoding layers for u. The neurons u is calculated from a linear combination of hidden neurons h_k^((x)). A second transfer function ϕ_2 maps the encoding layer to the bottleneck layer containing a single neuron.
<p align='center'><img id='nlpca' src='figures/NLPCA.png' style='width:600px'></p>
<p align='center'><caption><b> Figure 3. NN Model for calculating NLPCA</b> </caption></p>
