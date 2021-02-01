 % LIDFa LIDF parameter a, which controls the average leaf slope
    % LIDFb LIDF parameter b, which controls the distribution's bimodality
    %	LIDF type 		a 		 b
    %	Planophile 		1		 0
    %	Erectophile    -1	 	 0
    %	Plagiophile 	0		-1
    %	Extremophile 	0		 1
    %	Spherical 	   -0.35 	-0.15
    %	Uniform 0 0
function chi2=chi2P5B(x,rmes)
N=x(1); %leaf structure parameter
Cab=x(2); % chlorophyll content
Car=x(3);% carotenoid content (ug.cm-2)
Cbrown=x(4);% brown pigment content (arbitrary units)
Cw=x(5);% EWT (g.cm-2)
Cm=x(6);% LMA (g.cm-2)
LAI = x(7);% leaf area index (m^2/m^2)
TypeLidf=1;
LIDFa	=	1; % select different LADs
LIDFb	=	0;% select different LADs
tts=	x(8);		% solar zenith angle (?
tto=	x(9);		% observer zenith angle (?
psi=	x(10);        % relative azimuth angle(raa?)
hspot =0.25;% hot spot
psoil	=x(11);	 % soil factor (psoil=0: wet soil / psoil=1: dry soil)
data=dataSpec_P5B;
Rsoil1=data(:,10);Rsoil2=data(:,11);
rsoil0=psoil*Rsoil1+(1-psoil)*Rsoil2;
% simulated four reflectance proeprties see "Unified optical-thermal four-stream radiative transfer theory for homogeneous vegetation canopies"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          CALL PRO4SAIL       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rdot: hemispherical-directional reflectance factor in viewing direction    
% rsot: bi-directional reflectance factor
% rsdt: directional-hemispherical reflectance factor for solar incident flux
% rddt: bi-hemispherical reflectance factor
[rdot,rsot,rddt,rsdt]=PRO4SAIL(N,Cab,Car,Cbrown,Cw,Cm,LIDFa,LIDFb,TypeLidf,LAI,hspot,tts,tto,psi,rsoil0);
data=dataSpec_P5B;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	direct / diffuse light	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the direct and diffuse light are taken into account as proposed by:
% Francois et al. (2002) Conversion of 400?1100 nm vegetation albedo 
% measurements into total shortwave broadband albedo using a canopy 
% radiative transfer model, Agronomie
% Es = direct
% Ed = diffuse
Es=data(:,8);Ed=data(:,9);
rd=pi/180;
skyl	=	0.847- 1.61*sin((90-tts)*rd)+ 1.04*sin((90-tts)*rd)*sin((90-tts)*rd); % % diffuse radiation
PARdiro	=	(1-skyl)*Es;
PARdifo	=	(skyl)*Ed;
% resv : directional reflectance
resv	= (rdot.*PARdifo+rsot.*PARdiro)./(PARdiro+PARdifo);
chi2=sqrt(sum((resv(:,:)-rmes(:,:)).^2)); % based on wavelengths from different sensors, change the cost function
