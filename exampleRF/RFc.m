%--------------------------------------------------------------------------
clear;clc;close all

%--------------------------------------------------------------------------
% Load an example dataset provided with matlab
% load house_dataset
% In = houseInputs';
% Out = houseTargets';
data=xlsread('xx.xlsx');
[XSelected,XRest,vSelectedRowIndex]=ks(data,54) ;%Num=三分之二的数值
% [XSelected,XRest,vSelectedRowIndex]=ks(data,m);

X=XSelected(:,1:end-1);
Y=XSelected(:,end);
Xtest=XRest(:,1:end-1);
Ytest=XRest(:,end);
% In=data(:,1:18);
% Out=data(:,19);
%--------------------------------------------------------------------------
% Find capabilities of computer so we can best utilize them.

% Find if gpu is present
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
ntrees=200;
fboot=1;
surrogate='on';
disp('Training the tree bagger')
b = TreeBagger(...
        ntrees,...
        X,Y,... 
        'Method','classification',...
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
predict_label_train=predict(b, X);
predict_label_train = cell2mat(predict_label_train);
predict_label_train = str2num(predict_label_train);
predict_label_test=predict(b, Xtest);
predict_label_test = cell2mat(predict_label_test);
predict_label_test = str2num(predict_label_test);
toc
accuracy_train         =       length(find(predict_label_train == Y))/length(Y)*100;
accuracy_test         =       length(find(predict_label_test == Ytest))/length(Ytest)*100;  
%--------------------------------------------------------------------------
% calculate the training data correlation coefficient
