clear all
clc
 for p=1:xx % number of sample
R=xlsread('xx.xlsx','xx'); % canopy reflectance (name of excel file)
rmes=R';
Cab=40;		% chlorophyll content (ug.cm-2) 
Car=6;		% carotenoid content (ug.cm-2)
Cbrown=0.0;	% brown pigment content (arbitrary units)
Cw=0.015;	% EWT (cm)
Cm=0.004;	% LMA (g.cm-2)
N=1.5;	% leaf structure parameter
LAI	=3.;    % leaf area index (m^2/m^2)
tts=30;	% solar zenith angle (sza)
tto=0;	% viewing zenith angle (vza)
psi=150;    % relative azimuth angle(raa?)
psoil=0;	% soil factor (psoil=0: wet soil / psoil=1: dry soil)
P0=[N Cab Car Cbrown Cw Cm LAI   tts tto psi psoil];
LB=[1  10   2  0  0.01 0.001     0  30 0 90 0]; % the range was setted based on field experiments and prior knowledge
UB=[3 60    8  0  0.05 0.009     6  90 0 280 1];
sol=fminsearchbnd('chi2P5B',P0,LB,UB,[],rmes);
result(p,1:8)=sol(1,1:8); % output result for the retrieval of traits
 end
 LAI=result (:,7);
%	LIDF type 		a 		 b
%	Spherical 	   -0.35 	-0.15
FVC1 = 1-exp(-0.5*LAI);
%	Planophile 		1		 0
FVC2 = 1-exp(-0.85*LAI);
%	Erectophile    -1	 	 0
FVC3 = 1-exp(-0.42*LAI);
%	Plagiophile 	0		-1
FVC4 = 1-exp(-0.68*LAI);
%	Extremophile 	0		 1
FVC5 = 1-exp(-0.6*LAI);   
%	Uniform         0        0
FVC6 = 1-exp(-0.64*LAI);

