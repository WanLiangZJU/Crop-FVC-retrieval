clc
% clear all
close all
% data=xlsread('spectral.xlsx','sheet1');
% data=data(:,1:25);
% A=xlsread('1010…˙ŒÔ¡ø.xlsx','sheet1');
% % A=xlsread('data2.xlsx','sheet3');
% D=A(:,2);
% data=xlsread('data.xlsx');
% data=data(121:300,:);
samplenum=125;
for z=1:samplenum
   for i=1:25  
   for j=1:25 
       for m=1:25
%            r=data(z,m)/sum(data(z,:));
%            g=data(z,i)/sum(data(z,:));
%             b=data(z,j)/sum(data(z,:));
% sub=data(z,m)-data(z,i);
% pls=data(z,m)-data(z,j);
        sub=data(z,i);
        pls=data(z,j)-data(z,m);
%       sub=data(z,j);
%       pls=data(z,i);

%          NDSI(i,j)=(1+0.16)*sub/(pls+0.16);
% NDSI(i,j)=sub/pls-1/sqrt(sub/pls)+1;
NDSI(i,j,m)=sub/pls;

 if  pls==0
       NDSI(i,j,m)=0;
 else
  NDSI(i,j,m)=sub/pls;
   end
   end
   end
 end
 NDSI1{z}= NDSI;
end
for z=1:samplenum
   temp(1:25,1:25,1:25,z)=NDSI1{1,z};
end

for ii=1:25
    for jj=1:25
        for mm=1:25
           temp1=temp(ii,jj,mm,:);
           temp1=cat(1,temp1(:)); 
           nan=find(isnan(temp1));
           temp1(nan)=(temp1(nan+1)+temp1(nan-1))/2;
             inf=find(isinf(temp1));
             temp1(inf)=(temp1(inf+1)+temp1(inf-1))/2;
           [c1,~]= corrcoef(temp1,D) ;%%%
           cof11(ii,jj,mm)=c1(1,2);
        end         
    end
end
contour=abs(cof11.*cof11);
% contour=triu(abs(cof11));
contour(isnan(contour)) = 0;
[Amax,indmax]=max(contour(:));
[a,b,c]=ind2sub(size(contour),indmax);
[x,y,z] = meshgrid(1:25,1:25,1:25);
xs=1:25;
ys=1:25;
zs=1:25;
h = slice(x,y,z,contour,xs,ys,zs);
set(h,'FaceColor','interp',...
    'EdgeColor','none')
camproj perspective
box on
view(-30,30)
colormap hsv
colorbar