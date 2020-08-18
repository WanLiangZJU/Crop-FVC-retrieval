clear all
clc
 for p=xx %number of sample
     leaf=xlsread('xx.xlsx','w');
leaf2=xlsread('xx.xlsx','spectra');
 l=leaf(:,1);%spectral wavelengths
rmes=leaf2(p,1:25)';
Cab		=	30;		% chlorophyll content (µg.cm-2) 
Car		=	4;		% carotenoid content (µg.cm-2)
Cbrown	=	0.0;	% brown pigment content (arbitrary units)
Cw		=	0.015;	% EWT (cm)
Cm		=	0.005;	% LMA (g.cm-2)
N		=	1.5;	% structure coefficient
LAI		=	3.;     	% leaf area index (m^2/m^2)
ALA=50;
tts=	30;		% solar zenith angle (?
tto=	0;		% observer zenith angle (?
psi=	90;         % azimuth (?
hspot =0.15;
psoil	=0;	
P0=[N Cab Car Cbrown Cw Cm LAI ALA hspot tts tto psi psoil];
% P0=[1.5 50 10 0 0.01 0.01];
% [sol,fval,exitflag,iter]=fminsearch('chi2P5B',P0,[],rmes);
% result(p,1:6)=sol(1,1:6);
% variant: inversion using bounded variables
LB=[1  10 2 0 0.01 0.002 1 30 0.25 0 0 90 0];
UB=[1.5 60 7 0 0.03 0.008 8 90 0.25 60 0 280 0];
sol=fminsearchbnd('chi2P5B',P0,LB,UB,[],rmes);
result(p,1:8)=sol(1,1:8);
 end
