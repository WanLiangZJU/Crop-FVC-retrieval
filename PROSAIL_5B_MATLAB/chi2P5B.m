% _______________________________________________________________________
%
% chi2P5B.m
% merit function
% _______________________________________________________________________

function chi2=chi2P5B(x,rmes)
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

data=dataSpec_P5B;
Rsoil1=data(:,10);Rsoil2=data(:,11);
	% soil factor (psoil=0: wet soil / psoil=1: dry soil)
rsoil0=psoil*Rsoil1+(1-psoil)*Rsoil2;

[rdot,rsot,rddt,rsdt]=PRO4SAIL(N,Cab,Car,Cbrown,Cw,Cm,LIDFa,LIDFb,TypeLidf,LAI,hspot,tts,tto,psi,rsoil0);

Es=data(:,8);Ed=data(:,9);
rd=pi/180;
 skyl	=	0.847- 1.61*sin((90-tts)*rd)+ 1.04*sin((90-tts)*rd)*sin((90-tts)*rd); % % diffuse radiation

PARdiro	=	(1-skyl)*Es;
PARdifo	=	(skyl)*Ed;

% resv : directional reflectance
resv	= (rdot.*PARdifo+rsot.*PARdiro)./(PARdiro+PARdifo);
% 
chi2=sqrt(sum((resv(:,:)-rmes(:,:)).^2));
