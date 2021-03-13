%% The original version related to http://teledetection.ipgp.jussieu.fr/prosail/
%% The original version is implemented by Dr. Jean-Baptiste Feret 
%% This is the main program for the PROSAIL-GP model inversion
%% 1. update the file for the inpot of reflectance data
%% 2. set the range of model parameters
%% 3. obtain the retrieval result, namely FVC1-FVC6, realted to six leaf angle distributions

clear all; clear all; clc;

 for p=1:10 % number of sample
%% input canopy reflectance (name of excel file)
%% Notably, as for the canopy feflectance with different bands, we must modify the origianl data in dataSpect_P5B
%% dataSpect_P5B includes some prior information about leaf and canopy parameters in the region of 400-2500 nm
%% to fit with different range of spectral bands, this file should be changed
R=xlsread('F:\...\oilseed rape 2019 dataset.xlsx','spectra');
R1=R(p,1:25);
rmes=R1';
%% determinte the LAD
%% LAD=1, Planophile; LAD=2, Erectophile; LAD=3, Plagiophile;
%% LAD=4, Extremophile; LAD=5, Spherical; LAD=6, Uniform;
LAD=5;

%% The initial value for leaf parameters, which doesn't  significnatly affect the retrieval.
Cab=40;		% chlorophyll content (ug.cm-2) 
Car=6;		% carotenoid content (ug.cm-2)
Cbrown=0.0;	% brown pigment content (ug.cm-2)
Cw=0.015;	% EWT ((g.cm-2)
Cm=0.004;	% LMA (g.cm-2)
N=1.5;	% leaf structure parameter

%% The initial value for canopy parameters, which doesn't significnatly affect the retrieval.
LAI	=3.;    % leaf area index (m^2/m^2)
tts=30;	% solar zenith angle (sza)
tto=0;	% viewing zenith angle (vza)
psi=150;    % relative azimuth angle(raa?)
psoil=0;	% soil factor (psoil=0: wet soil / psoil=1: dry soil)

%% set the range of mode parameters based on previous studies and field measuremnts
%% These parameters vary with plant species, planting regions, growth seasons, and sampling time.
P0=[N Cab Car Cbrown Cw  Cm   LAI tts tto psi psoil LAD];
%% the smallest values of model parameters
LB=[1  10   2  0   0.01  0.002  0  30  0   90 0 LAD]; 
%% the largest values of model parameters
UB=[3  60    8  0  0.05 0.009    6  90 0  280 1 LAD];

%% Iterative function to find the optimal solution
sol=fminsearchbnd('chi2P5B',P0,LB,UB,[],rmes);
%% Here, the canopy reflectance was input, which would match with the simulated relfectance
%% Canopy reflectance is determined based on a weighted combination of the bi-directional and hemispherical-directional reflectance 
%% with weights corresponding to the fraction of diffuse incident solar radiation (skyl)
%% The detailed information can be fould in chi2P5B.m and PRO4SAIL.m

%% output result for the retrieval of traits
result(p,1:8)=sol(1,1:8);
 end
 %% Retrieval result for LAI and FVC
 LAI=result (:,7);
 %% obtain FVC from LAI based on six LADs
if LAD==1
FVC = 1-exp(-0.85*LAI);% Planophile 	
else
    if LAD==2
       FVC = 1-exp(-0.42*LAI); % Erectophile
    else
        if LAD==3
      FVC = 1-exp(-0.68*LAI); % Plagiophile
        else
            if LAD==4
              FVC = 1-exp(-0.6*LAI);  % Extremophile
            else
                if LAD==5
                      FVC = 1-exp(-0.5*LAI); % Spherical 
                else
                    if LAD==6
                             FVC = 1-exp(-0.64*LAI); % Spherical 
                    end
                end
            end
        end
    end
end
         
