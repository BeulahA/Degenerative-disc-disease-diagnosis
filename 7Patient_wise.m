clc;
clear all;
close all;

Degen=load('Degen_feature_Train.mat');
NDegen=load('Non_Degen_feature_Train.mat');

featureD=Degen.featureD;
featureND=NDegen.featureND;

train=[featureD(1:end,1:3269);featureND(1:end,1:3269)];
trainlabel=[featureD(1:end,3270);featureND(1:end,3270)];

gaborArray = gaborFilterBank(5,8,39,39);


Model = fitcsvm(train,trainlabel,'KernelFunction','rbf','KernelScale','0.0227','BoxConstraint',259.59,'Standardize',false);

%from images 66 to 93

 predictlabel = predict(Model,train);
 Ctrain = confusionmat(trainlabel,Model.Y); 

 % good -80
 
for i =61% :93
    %give segmented image as input
    %Consider only the last 6 IVDs
    image=imread(strcat('...path\Mid Sagittal gray\',int2str(i),'.tif'));
    iv_disc = imread(strcat('...path\Lumbar IVDs Segmented\',int2str(i),'.tif'));
    figure(1);
    imshow(iv_disc);
    
    %After segmenting find the segmented region
    CC = bwconncomp(iv_disc);
    st = regionprops(CC,'Centroid');
    centroids = cat(1, st.Centroid);
    scentroid = sortrows(centroids,2);
 
    % mark the boundaries of ivds in red colour 
    figure,imshow(image);
    ivd_boundary = bwboundaries(iv_disc);  %ivd_boundary contains boundaries for all ivds in the image as a cell
    
    % plot IVD boundaries
    hold on
    for k = 1:length(ivd_boundary)
        boundary = ivd_boundary{k};
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
    end
    
    st = regionprops(iv_disc,'BoundingBox','MajorAxisLength','MinorAxisLength','Eccentricity');
    hold on;

    %separate degenerated and non degenerated discs 
    count=1;
    counter=1;
    for k = 1 : length(st)
        
        %to consider the ivds in order find the location of boundary in sorted
        %centriod ie. scentroid
        [~,location]=ismember(scentroid(k),centroids);
        t = st(location).BoundingBox;
        
        rect1=rectangle('Position', [t(1),t(2),t(3),t(4)],'EdgeColor','b','LineWidth',2 );
        c = imcrop(image,[t(1),t(2),t(3),t(4)]);
        Major(k,:) = st(location).MajorAxisLength;
        Minor(k,:) = st(location).MinorAxisLength;
        Eccen (k,:)= st(location).Eccentricity;
        %feature{counter} = extractLBPFeatures(c);
         maxID(k,:) = max(c(:));
        minID(k,:) = min(c(:));
        meanID(k,:) = mean(c(:));
        
        %hue moments
        M_f(k,:)=feature_vec(double(c));
        %gabor feature
        J = imresize( c , [20 60] ); %resize for gabor filter
        gaborD(k,:) = gaborFeatures(J,gaborArray,4,4);
        
        %histogram feature
        [hist_D(k,:), x] = imhist(c);
%        Feature{counter}=[M_f lbp_f glcm_f];
         boxPoint{counter} = [t(1),t(2),t(3),t(4)];
         counter = counter + 1;
         count = count+1; 
         
    end
  bbox = cell2mat(boxPoint');
  predictlabeltest = ones(length(bbox),1);
  
  Feature=[Major Minor Eccen double(maxID) double(minID) double(meanID) M_f   gaborD double(hist_D) ];
  [predictlabeltest, predictscore] = predict(Model,Feature); 
  
       get_detect = predictscore(:,2).*[predictscore(:,2)<3 & predictscore(:,2)>0.1];
 
  [r,c,v]= find(get_detect);
  tf = isempty(r);
%   % If no degeneration in the image perform if statement
  if tf==1
        str = 'No Degeneration';
I2=insertText(image,[20 40],str,'FontSize',22,'BoxColor','red','TextColor','white');
        figure(4);
        imshow(I2);
%         % path to store the Degeneration detected image
        imwrite(I2,strcat('...path\Degeneration_Classification_Output\',int2str(i),'.tif'));
% %   
% %   %if there is Degeneration in the image perform else statement  
  else    
    for ix = 1:length(r)
         rects{ix}= boxPoint{r(ix)};
         thisrect{ix} = rects{ix};
    end
    boundbox = cell2mat(rects');
    [selectedBbox,selectedScore] = selectStrongestBbox(boundbox,v,'OverlapThreshold',0.1);

    label=['Degeneration'];
%     I2 = insertObjectAnnotation(image,'rectangle',selectedBbox,label,'Color','white','TextColor','white','FontSize' ,18);
    I2 = insertObjectAnnotation(image,'rectangle',selectedBbox,label,'Color','red','TextColor','white','FontSize' ,18);
    figure(4);
    imshow(I2);
% %     % path to store the degeneration detected image
     imwrite(I2,strcat('E:\Phd\Coding\Degeneration\Degeneration_Classification_Output\',int2str(i),'.tif'));
    
   end
% % %   imsave(gcf);
% %   
 end    