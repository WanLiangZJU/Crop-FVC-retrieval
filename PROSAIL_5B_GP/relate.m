clc
clear all
close all
   data1=xlsread('E:\滤光片和高度\PROSAIL_5B_MATLAB\alldata.xlsx','25new');
 data2=xlsread('E:\滤光片和高度\PROSAIL_5B_MATLAB\alldata.xlsx','data');
 data= data1(:,1:25);
% data=indice';
% data2=y;
[m,n]=size(data);
D=data2(:,1);
samplenum=m;
for z=1:samplenum
for i=1:n
    for j=1:n
        pls=data(z,i)+data(z,j);
        sub=data(z,i)-data(z,j);  
%          sub=data(z,i);       
%          pls=data(z,j);
%          NDSI(i,j)=(1+0.16)*sub/(pls+0.16);
% NDSI(i,j)=sub/pls-1/sqrt(sub/pls)+1;
         NDSI(i,j)=sub/pls;
    end
end

 NDSI1{z}= NDSI;
end
for z=1:samplenum
   temp(1:n,1:n,z)=NDSI1{1,z};
end

for ii=1:n
    for jj=1:n
           temp1=temp(ii,jj,:);
           temp1=cat(1,temp1(:)); 
           nan=find(isnan(temp1));
           temp1(nan)=(temp1(nan+1)+temp1(nan-1))/2;
             inf=find(isinf(temp1));
             temp1(inf)=(temp1(inf+1)+temp1(inf-1))/2;
           [c1,c2]= corrcoef(temp1,D) ;%%%
           cof11(ii,jj)=c1(1,2);
    end         
end
contour=(abs(cof11.*cof11));
% contour=tril(abs(cof11));
contour(isnan(contour)) = 0;
 imagesc(contour);
%  colormap(flipud(summer))
% contour=tril(abs(cof11));
%  imagesc(contour);
%  colormap(flipud(gray));
%  [a,b]=find(contour==max(contour(:)));
%          pls=data(:,369)+data(:,249);
%         sub=data(:,369)-data(:,249);  
% % %  pls=data(:,b(1));
% % %   sub=data(:,a(1));
%   res=sub./pls;
