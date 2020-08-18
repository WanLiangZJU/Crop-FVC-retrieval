% %*************************************************************************
% %*                                                                       *
% 	main_PROSAIL
% 
% 09 01 2011
% This program allows modeling reflectance data from canopy
% - modeling leaf optical properties with PROSPECT-5 (feret et al. 2008)
% - modeling leaf inclination distribution function with the subroutine campbell
% (Ellipsoidal distribution function caracterised by the average leaf 
% inclination angle in degree), or dladgen (2 parameters LIDF)
% - modeling canopy reflectance with 4SAIL (Verhoef et al., 2007)

% This version has been implemented by Jean-Baptiste Feret
% Jean-Baptiste Feret takes the entire responsibility for this version 
% All comments, changes or questions should be sent to:
% jbferet@stanford.edu

% References:
% 	Verhoef et al. (2007) Unified Optical-Thermal Four-Stream Radiative
% 	Transfer Theory for Homogeneous Vegetation Canopies, IEEE TRANSACTIONS 
% 	ON GEOSCIENCE AND REMOTE SENSING, VOL. 45, NO. 6, JUNE 2007
% 	Féret et al. (2008), PROSPECT-4 and 5: Advances in the Leaf Optical
% 	Properties Model Separating Photosynthetic Pigments, REMOTE SENSING OF 
% 	ENVIRONMENT
% The specific absorption coefficient corresponding to brown pigment is
% provided by Frederic Baret (EMMAH, INRA Avignon, baret@avignon.inra.fr)
% and used with his autorization.
% the model PRO4SAIL is based on a version provided by
%	Wout Verhoef
%	NLR	
%	April/May 2003

% The original 2-parameter LIDF model is developed by and described in:
% 	W. Verhoef, 1998, "Theory of radiative transfer models applied in 
%	optical remote sensing of vegetation canopies", Wageningen Agricultural
%	University,	The Netherlands, 310 pp. (Ph. D. thesis)
% the Ellipsoidal LIDF is taken from:
%   Campbell (1990), Derivtion of an angle density function for canopies 
%   with ellipsoidal leaf angle distribution, Agricultural and Forest 
%   Meteorology, 49 173-176
%*                                                                       *
%*************************************************************************
clc

N=x(1);
Cab=x(2);
Car=x(3);
Cbrown=x(4);
Cw=x(5);
Cm=x(6);
LAI = x(7);
TypeLidf=2;
LIDFa	=	x(8);
LIDFb	=	0;
tts=	x(10);		% solar zenith angle (?
tto=	x(11);		% observer zenith angle (?
psi=	x(12);         % azimuth (?
hspot =x(9);
psoil	=x(13);	
skyl=x(14);
data=dataSpec_P5B;
Rsoil1=data(:,10);Rsoil2=data(:,11);	% soil factor (psoil=0: wet soil / psoil=1: dry soil)
rsoil0=psoil*Rsoil1+(1-psoil)*Rsoil2;
[rdot,rsot,rddt,rsdt]=PRO4SAIL(N,Cab,Car,Cbrown,Cw,Cm,LIDFa,LIDFb,TypeLidf,LAI,hspot,tts,tto,psi,rsoil0);
Es=data(:,8);Ed=data(:,9);
rd=pi/180;
skyl	=	0.847- 1.61*sin((90-tts)*rd)+ 1.04*sin((90-tts)*rd)*sin((90-tts)*rd); % % diffuse radiation
PARdiro	=	(1-skyl)*Es;
PARdifo	=	(skyl)*Ed;

% resv : directional reflectance
resv	= (rdot.*PARdifo+rsot.*PARdiro)./(PARdiro+PARdifo);

% dlmwrite('Refl_CAN.txt',[data(:,1),resv],'delimiter','\t','precision',5)
