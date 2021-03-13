# Crop-FVC-retrieval
The source code of the PROSAIL model used in this study, are open and available on http://teledetection.ipgp.jussieu.fr/prosail/. 
The software for the PROSAIL inversion is open in ARTMO (https://artmotoolbox.com/).


# Implementation of model inversion
Please use the code in the file of PROSAIL_5B_GP.
Here, we provide five main code for different dataset as follows:
Main_oilseed_rape_2017_2018.m
Main_oilseed_rape_2019.m
Main_rice_2018.m
Main_wheat_2019.m
Main_cotton_2019.m

Please update the code and run the main code
1. update the file for the input of reflectance data
2. set the range of model parameters
3. obtain the retrieval result, namely FVC, realted to different leaf angle distributions
As for different datasets, set the range of mode parameters based on previous studies and field measuremnts

please pay attention to some key information
This code uses the UAV-based multispectral image with the spectral region of 604-872 nm.
If you have different spectral regions, please refer to the original code online http://teledetection.ipgp.jussieu.fr/prosail/

Here, the canopy reflectance was input, which would match with the simulated relfectance.
Canopy reflectance is determined based on a weighted combination of the bi-directional and hemispherical-directional reflectance with weights corresponding to the fraction of diffuse incident solar radiation (skyl).
The detailed information can be fould in chi2P5B.m and PRO4SAIL.m.

The detailed descriptions about the datasets can be found in our published papers.
