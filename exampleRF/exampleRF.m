%--------------------------------------------------------------------------
clear;clc;close all

%--------------------------------------------------------------------------
% Load an example dataset provided with matlab
% load house_dataset
% In = houseInputs';
% Out = houseTargets';
for xx=1:9

data1=xlsread('xx.xlsx','regression');
 data =data1(1+100*(xx-1):100*xx,:);
% data=[data1(:,:) data2(:,4)];
% [m,n]=sort(data2(1:900,10));
% for k=1:300
%     aa(k,1)=n(3*(k-1)+1);
% XRest(k,:)= data(n(3*(k-1)+1),:);  %第3个为预测集。输入的是主成分数.
% end
% bb = setdiff(n, aa);
% XSelected=data(bb,:);  %前两个为训练集。
num=size(data,1)*2/3;
m=size(data,1)*2/3;
n=size(data,1)*1/3;
 [XSelected,XRest,vSelectedRowIndex]=ks(data,m);
X=XSelected(:,1:end-1);
Y=XSelected(:,end);
Xtest=XRest(:,1:end-1);
Ytest=XRest(:,end);
%  Xtest=data(:,1:end-1);
%  Ytest=data(:,end);
ngpus=gpuDeviceCount;
disp([num2str(ngpus) ' GPUs found'])
if ngpus>0
    lgpu=1;
    disp('GPU found')
    useGPU='yes';
else
    lgpu=0;
    disp('No GPU found')
    useGPU='no';
end

% Find number of cores
ncores=feature('numCores');
disp([num2str(ncores) ' cores found'])

% Find number of cpus
import java.lang.*;
r=Runtime.getRuntime;
ncpus=r.availableProcessors;
disp([num2str(ncpus) ' cpus found'])

if ncpus>1
    useParallel='yes';
else
    useParallel='no';
end

[archstr,maxsize,endian]=computer;
disp([...
    'This is a ' archstr ...
    ' computer that can have up to ' num2str(maxsize) ...
    ' elements in a matlab array and uses ' endian ...
    ' byte ordering.'...
    ])

% Set up the size of the parallel pool if necessary
npool=ncores;

% Opening parallel pool
if ncpus>1
    tic
    disp('Opening parallel pool')
    
    % first check if there is a current pool
    poolobj=gcp('nocreate');
    
    % If there is no pool create one
    if isempty(poolobj)
        command=['parpool(' num2str(npool) ');'];
        disp(command);
        eval(command);
    else
        poolsize=poolobj.NumWorkers;
        disp(['A pool of ' poolsize ' workers already exists.'])
    end
    
    % Set parallel options
    paroptions = statset('UseParallel',true);
    toc
    
end

%--------------------------------------------------------------------------
tic
leaf=5;
ntrees=500;
fboot=1;
surrogate='on';
%         'NVarToSample','all',...
disp('Training the tree bagger')
b = TreeBagger(...
        ntrees, ...
        X,Y,...
        'Method','regression',...
        'oobvarimp','on',...
        'surrogate',surrogate,...
        'minleaf',leaf,...
        'FBoot',fboot,...
        'Options',paroptions...
    );
toc

%--------------------------------------------------------------------------
% Estimate Output using tree bagger
disp('Estimate Output using tree bagger')
x=Ytest;
y=predict(b, Xtest);
name='Bagged Decision Trees Model';
toc
% y2=cell2mat(y1);
% y = str2num(y2);
%--------------------------------------------------------------------------
% calculate the training data correlation coefficient
cct=corrcoef(x,y);
cct=cct(2,1);
R2=cct^2;
Et=y-x;
n=size(x,1);
RMSEP=sqrt(sum((Et).^2)/n);
RRMSE=RMSEP/mean(x,1);
res(1,xx)=R2;
res(2,xx)=RMSEP;
res(3,xx)=RRMSE;
end
% weights=b.OOBPermutedVarDeltaError;
% [B,iranked] = sort(weights,'descend');


