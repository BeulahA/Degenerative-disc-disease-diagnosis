%   Gabor Features code taken from:(github)
%   
%   M. Haghighat, S. Zonouz, M. Abdel-Mottaleb, "CloudID: Trustworthy 
%   cloud-based and cross-enterprise biometric identification," 
%   Expert Systems with Applications, vol. 42, no. 21, pp. 7905-7916, 2015.

% Hue Moments from github code
clc;
clear all;
close all;

srcFileDegen = dir('...\Crop\Complete Crop\Degenerated Disc\*.tif');

srcFileNonDegen = dir('...\Crop\Complete Crop\Non Degenerated Disc\*.tif'); 
gaborArray = gaborFilterBank(5,8,39,39);  %scale 3 and direction is 4
 for num = 1 : length(srcFileDegen)
    gray = imread(strcat('....\Crop\Complete Crop\Degenerated Disc\',srcFileDegen(num).name));
    
    %from stored content extract the major, minor axis and eccentricity
    file = split(srcFileDegen(num).name,["_","."]);
    centers=load(strcat('....path\Major Minor Axis Eccentricity\',file{1},'.mat'));
    %val=file{2}
    M_M_E_D(num,:)=centers.Major_Minor_Axis_Eccen(str2num(file{2}),:);
   
    maxID(num,:) = max(gray(:));
    minID(num,:) = min(gray(:));
    meanID(num,:) = mean(gray(:));
    
    %extract remaining features
    % Hue Moments from github code
    M_D(num,:)=feature_vec(double(gray));
   
    J = imresize( gray , [20 60] ); %resize for gabor filter
     % Generates the Gabor filter bank
     % 3000 gabor features: 20*60*5*8=48000
     % 48000/(4*4) =3000
    gaborD(num,:) = gaborFeatures(J,gaborArray,4,4);   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.

    %histogram
    [hist_D(num,:), x] = imhist(gray);
  end
    

disp('Degeneration completed');

for num = 1 : length(srcFileNonDegen)
     gray = imread(strcat('...path\Crop\Complete Crop\Non Degenerated Disc\',srcFileNonDegen(num).name));
     
     %from stored content extract the major, minor axis and eccentricity
    file = split(srcFileNonDegen(num).name,["_","."]);
    centers=load(strcat('...path\Major Minor Axis Eccentricity\',file{1},'.mat'));
    %val=file{2}
    M_M_E_ND(num,:)=centers.Major_Minor_Axis_Eccen(str2num(file{2}),:);
    
    maxIND(num,:) = max(gray(:));
    minIND(num,:) = min(gray(:));
    meanIND(num,:) = mean(gray(:));
     
     M_ND(num,:)=feature_vec(double(gray));
    
    J = imresize( gray , [20 60] ); %resize for gabor filter
     % Generates the Gabor filter bank
     % 3000 gabor features: 20*60*5*8=48000
     % 48000/(4*4) =3000
    gaborND(num,:) = gaborFeatures(J,gaborArray,4,4);   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.
    
    %histogram
    [hist_ND(num,:), x] = imhist(gray);
 end

disp('Non Degeneration completed');
  
labelD= ones(1,221);
labelND= zeros(1,337);
featureD = [M_M_E_D double(maxID) double(minID) double(meanID) M_D   gaborD double(hist_D) labelD'];
 featureND = [M_M_E_ND double(maxIND) double(minIND) double(meanIND) M_ND  gaborND double(hist_ND) labelND'];

save('Degen_feature.mat','featureD');
save('Non_Degen_feature.mat','featureND');


