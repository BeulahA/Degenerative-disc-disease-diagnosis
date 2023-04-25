clear all
close all
%Find the center points for the IVDS segmented
for noofimages = 1:93

    BW=imread(strcat('...path\',int2str(noofimages),'.tif'));
%          figure,imshow(BW);
% REgion properties to find centriod
        s = regionprops(BW,'Centroid','MajorAxisLength','MinorAxisLength','Eccentricity');
        Center = cat(1, s.Centroid);
%         major, minor axis and eccentricity also found for feature
%         extraction of the images.
        MajorA=cat(1,s.MajorAxisLength);
        MinorA=cat(1,s.MinorAxisLength);
        Eccentricity=cat(1,s.Eccentricity);
        centroids=[Center MajorA MinorA Eccentricity];
        
%         centroids = cat(2, s.Centroid,s.MajorAxisLength);
        %sort according to Y axis
         scentroid = sortrows(centroids,2); % sorted centroid
                
         %Select only 6 Lumbar IVDs
         [row, column] = size(centroids);       
         newrow=row-5;
         centroidX = scentroid(newrow:row, 1);   %Extract X coordinate
         centroidY = scentroid(newrow:row, 2);   %Extract Y coordinate 
         ivdcenters=horzcat(centroidX,centroidY);
         Major_Minor_Axis_Eccen=[scentroid(newrow:row, 3) scentroid(newrow:row, 4) scentroid(newrow:row, 5)];
         
%          %displaying or ploting all centers
%          imshow(BW)
%          for ivds=newrow: row
%             hold on
%             plot(scentroid(ivds,1), scentroid(ivds,2), 'b*')
%             hold off
%          end
          
        % save the centroid (IVD center point) in a mat file.
          save(strcat('....\Center points for ivds\',int2str(noofimages),'.mat'),'ivdcenters');

% save the Major Axis and Minor Axis in a mat file for feature extraction
% purpose
   save(strcat('...path\',int2str(noofimages),'.mat'),'Major_Minor_Axis_Eccen');
    
end