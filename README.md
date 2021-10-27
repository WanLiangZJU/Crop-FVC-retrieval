# Crop-FVC-retrieval
The source code of the PROSAIL model used in this study, are open and available on http://teledetection.ipgp.jussieu.fr/prosail/. 
The software for the PROSAIL inversion is open in ARTMO (https://artmotoolbox.com/).


# Implementation of model inversion
Please use the code in the file of PROSAIL_5B_GP.
Here, we provide five main codes for different datasets as follows:
Main_oilseed_rape_2017_2018.m
Main_oilseed_rape_2019.m
Main_rice_2018.m
Main_wheat_2019.m
Main_cotton_2019.m

Please update the code and run the main code
1. update the file for the input of reflectance data
2. set the range of model parameters
3. obtain the retrieval result, namely FVC, realted to different leaf angle distributions
As for different datasets, it is critical to set the suitable range of mode parameters based on previous studies and field measuremnts.

Please pay attention to some key information
This code uses the UAV-based multispectral image with the spectral region of 604-872 nm.
If you use different spectral regions, please refer to the original code online http://teledetection.ipgp.jussieu.fr/prosail/
It is necessary to modify the range of spectral reflectance in the model to fit with your data.

Here, the canopy reflectance can be input, which can match with the simulated reflectance.
Canopy reflectance is determined based on a weighted combination of the bi-directional and hemispherical-directional reflectance with weights corresponding to the fraction of diffuse incident solar radiation (skyl).
The detailed information can be fould in chi2P5B.m and PRO4SAIL.m.

In addition, the retrieval results may be slightly affected by the iterative optimization function, 
while they don't produce the significant difference for model inversion.

The detailed descriptions about the datasets can be found in our published papers.  
If you want to use the datasets and codes, please cite the paper as below:  
Liang Wan, Jiangpeng Zhu, Xiaoyue Du, Jiafei Zhang, Xiongzhe Han, Xiongzhe,Weijun Zhou, Li Xiaopeng, Jianli Liu, Liang Fei, Yong He, Haiyan Cen*. A model for phenotyping crop fractional vegetation cover using imagery from unmanned aerial vehicles. Journal of Experimental Botany. 2021, 72(13): 4691-4707. doi:10.1093/jxb/erab194
