clc
clear all
close all
  data1=xlsread('E:\滤光片和高度\PROSAIL_5B_MATLAB\alldata.xlsx','25new');
 data2=xlsread('E:\滤光片和高度\PROSAIL_5B_MATLAB\alldata.xlsx','data');
spectral= data1(:,1:25);
biomass=data2(:,1:10);
for i=1:10
    for jj=1:25
           [c1,c2]= corrcoef(biomass(:,i),spectral(:,jj));%%%
           cof11(i,jj)=c1(1,2);
    end    
end

