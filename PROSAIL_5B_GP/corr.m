clc
clear all
close all
  data1=xlsread('E:\滤光片和高度\PROSAIL_5B_MATLAB\alldata.xlsx','25new');
 data2=xlsread('E:\滤光片和高度\PROSAIL_5B_MATLAB\alldata.xlsx','data');
 data=data1(1:580,1:25);
% data=indice';
% data2=y;
[m,n]=size(data);
D=data2(1:580,10);
samplenum=m;
for i=1:n
    for j=1:n
        pls=data(:,i)+data(:,j);
        sub=data(:,i)-data(:,j);  
%          sub=data(z,i);       
%          pls=data(z,j);
         NDSI=sub./pls;
     [c1,c2]= corrcoef(NDSI,D) ;%%%
           cof11(i,j)=c1(1,2);
    end
end

contour=(abs(cof11.*cof11));
% contour=tril(abs(cof11));
contour(isnan(contour)) = 0;
 imagesc(contour);
 [a,b]=find(contour==max(contour(:)));
%  colormap(flipud(summer))
% contour=tril(abs(cof11));
%  imagesc(contour);
%  colormap(flipud(gray));
         pls=data(:,a(1))+data(:,b(1));
        sub=data(:,b(1))-data(:,a(1));  
% %  pls=data(:,b(1));
% %   sub=data(:,a(1));
  res=sub./pls;
