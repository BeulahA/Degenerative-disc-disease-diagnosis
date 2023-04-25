clc;
clear all;
close all;

Degen=load('Degen_feature.mat');
NDegen=load('Non_Degen_feature.mat');

featureD=Degen.featureD;
featureND=NDegen.featureND;

train=[featureD(1:end,1:3269);featureND(1:end,1:3269)];
trainlabel=[featureD(1:end,3270);featureND(1:end,3270)];

% test=[featurestenosis(1001:end,1:59);featurenonstenosis(4001:end,1:59)];
% testlabel=[featurestenosis(1001:end,60);featurenonstenosis(4001:end,60)];

% svm=fitcsvm(train,trainlabel,'KernelScale','auto','Standardize',true,'OutlierFraction',0.1);
% CVSVMModel = crossval(svm,'KFold',10);
% Loss=kfoldLoss(CVSVMModel,'mode','individual');
% Train_accuracy=1-Loss;



indices = crossvalind('kfold',trainlabel,10);
confusionMatrix = cell(1,1);
errorMat = zeros(1,10);
for i = 1:10
    Te = (indices==i);
    Tr = ~Te;
%     svm=fitcsvm(train(Tr,:),trainlabel(Tr),'KernelScale','auto','Standardize',true,'OutlierFraction',0.1);
%       svm = fitcsvm(train(Tr,:),trainlabel(Tr),'KernelScale','auto','Standardize',true,'OutlierFraction',0);  
%    svm = fitcsvm(train(Tr,:),trainlabel(Tr),'KernelFunction','rbf','KernelScale','auto','BoxConstraint',5,'Standardize',1, 'OutlierFraction',0.05);
%    svm1{i}= fitcsvm(train(Tr,:),trainlabel(Tr),'KernelFunction','gaussian','KernelScale',378.27,'BoxConstraint',560.1,'Standardize',false);
%kernalscale 899.27 --> accuracy 88.99
%kernalscale 798.27--> accuracy 89

svm = fitcsvm(train(Tr,:),trainlabel(Tr),'KernelFunction','rbf','KernelScale','0.0227','BoxConstraint',259.59);

% svm1{i} = fitcsvm(train(Tr,:),trainlabel(Tr),'Standardize',true,'KernelFunction','polynomial','KernelScale',120.27,'BoxConstraint',7,'Standardize',1,'CrossVal','off');
%'KernelFunction','polynomial','KernelScale',81.27,'BoxConstraint',7 -->
%Accuracy 90.33
% 'KernelScale',83.27    Accuracy 90.86
% svm = fitcsvm(train(Tr,:),trainlabel(Tr),'Standardize',true,'KernelFunction','polynomial','KernelScale','auto','BoxConstraint',7,'Standardize',1,'CrossVal','off');

% svm1{i} = fitcsvm(train(Tr,:),trainlabel(Tr),'Standardize',true,'KernelFunction','linear','BoxConstraint',123.21,'Standardize',false,'CrossVal','off');
%'BoxConstraint',.612    Accuracy 91
    
    
    
%    knn{i} = fitcknn(train(Tr,:),trainlabel(Tr),'NumNeighbors',5);
    % tree{i} = fitctree(train(Tr,:),trainlabel(Tr),'MinParent',4);
% disc{i} = fitcdiscr(train(Tr,:),trainlabel(Tr));
    y = tree{1,i}.predict(train(Te,:));
    %trainlabel(Te)
    index = cellfun(@strcmp,num2cell(y),num2cell(trainlabel(Te)));
    errorMat(i) = sum(index)/length(y);
    confusionMatrix{i} = confusionmat(trainlabel(Te),y);
    
    Ctest = confusionmat(trainlabel(Te),y);
    TN=Ctest(1,1);
    FP=Ctest(1,2);
    FN=Ctest(2,1);
    TP=Ctest(2,2);
    
    True_negative{i}=TN;
    False_Positive{i}=FP;
    False_Negative{i}=FN;
    True_Positive{i}=TP;
    
    accuracy{i} = (TP + TN)/(TP + FP + FN + TN) *100 ;
    precision{i} = TP / (TP + FP) *100;
    recall{i} = TP / (TP + FN)*100; % or TPR or sensitivity, recall, hit rate, or true positive rate
    specificity{i} = TN / (FP + TN) *100;% specificity, selectivity or true negative rate
    f_score{i} = 2*TP/(2*TP + FP + FN)*100;
    TNR{i}= TN/(TN+FP)*100; 
    
end
