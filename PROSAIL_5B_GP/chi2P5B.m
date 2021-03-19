    %% six commonly used LADs
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
%% leaf parameters,
N=x(1); %leaf structure parameter
Cab=x(2); % chlorophyll content (ug.cm-2)
Car=x(3);% carotenoid content (ug.cm-2)
Cbrown=x(4);% brown pigment content (ug.cm-2)
Cw=x(5);% EWT (g.cm-2)
Cm=x(6);% LMA (g.cm-2)

%% canopy parameters
LAI = x(7);% leaf area index (m^2/m^2)           
tts=	x(8);		% solar zenith angle (?
tto=	x(9);		% observer zenith angle (?
psi=	x(10);        % relative azimuth angle(raa?)
psoil	=x(11);	 % soil factor (psoil=0: wet soil / psoil=1: dry soil)
%% the hspot is fixed here based on the previous studies
hspot =x(12);% hot spot
LAD=x(13);

TypeLidf=1;
if LAD==1
LIDFa	=	1 ; % Planophile 
LIDFb	=	0;
else
    if LAD==2
       LIDFa	=	-1 ; % Erectophile
       LIDFb	=	0;
    else
        if LAD==3
       LIDFa	=	0 ; % Plagiophile
       LIDFb	=	-1;
        else
            if LAD==4
              LIDFa	=	0 ; % Extremophile
              LIDFb	=	1;
            else
                if LAD==5
                      LIDFa	=	-0.35 ; % Spherical 
                      LIDFb	=	-0.15; 
                else
                    if LAD==6
                             LIDFa	=	0 ; % Uniform 
                             LIDFb	=	0; 
                    end
                end
            end
        end
    end
end


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
%% The skyl is calculated in dependence of the SZA based on the recommended equation 
%% Spitters C, Toussaint H, Goudriaan J. 1986. Separating the diffuse and direct component 
%% of global radiation and its implications for modeling canopy photosynthesis Part I. Components of incoming radiation. 
%% Agricultural and Forest Meteorology 38(1-3): 217-229.
skyl	=0.847- 1.61*sin((90-tts)*rd)+ 1.04*sin((90-tts)*rd)*sin((90-tts)*rd); % % diffuse radiation

PARdiro	=(1-skyl)*Es;
PARdifo	=(skyl)*Ed;
%% Canopy reflectance is determined based on a weighted combination of the bi-directional and
%% hemispherical-directional reflectance with weights corresponding to the fraction of diffuse incident solar radiation (skyl)
% resv : directional reflectance
resv	= (rdot.*PARdifo+rsot.*PARdiro)./(PARdiro+PARdifo);
chi2=sqrt(sum((resv(:,:)-rmes(:,:)).^2)); % based on wavelengths from different sensors, change the cost function
