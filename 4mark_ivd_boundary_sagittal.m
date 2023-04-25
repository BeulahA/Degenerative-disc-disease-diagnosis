clear all;
close all;

%croping the ivds, separating as Degenerated and non degenerated

for noofimages=1:93
        
    centers=load(strcat('...Center points for ivds\',int2str(noofimages),'.mat'));
    
    image=imread(strcat('....\Mid Sagittal gray\',int2str(noofimages),'.tif'));
    iv_disc=imread(strcat('Lumbar IVDs Segmented\',int2str(noofimages),'.tif'));
     %figure,imshow(image);
      %convert 4D to 3D ie. RGBa to RGB
      img1=iv_disc(:,:,1:3);

        %convert RGB to gray and to logical
        rgb=rgb2gray(img1);
        BW = im2bw(rgb,0.4);

        CC = bwconncomp(BW);
 st = regionprops(CC,'BoundingBox','Centroid');
 centroids = cat(1, st.Centroid);
 [n m]=size(centroids); %centers of ivds selected
 
 %Making the non lumbar ivds (connected components)to 0's
 Alias=CC.PixelIdxList;
 for ii= 1:n
     log=ismember(centroids(ii),centers.ivdcenters); 
    if(log==0)
        Alias{ii}=0;   %non lumbar ivds to 0's
   end
 end

 %in image making non lumbar ivds to zero pixel values
[row col]= size(CC.PixelIdxList);
for jj1=1:col
    if Alias{jj1}==0
        BW(CC.PixelIdxList{jj1})=0;
    end
end
 
        
    CC = bwconncomp(BW);
    st = regionprops(CC,'Centroid');
    centroids = cat(1, st.Centroid);
    scentroid = sortrows(centroids,2);
 
% mark the boundaries of ivds in red colour 
    figure,imshow(image);
    ivd_boundary = bwboundaries(BW); %ivd_boundary contains boundaries for all ivds in the image as a cell
   % plot IVD boundaries
    hold on
    for k = 1:length(ivd_boundary)
        boundary = ivd_boundary{k};
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
    end
    
    st = regionprops(BW,'BoundingBox','MajorAxisLength','MinorAxisLength');
    hold on;

    %separate degenerated and non degenerated discs 
    cnt=1;
    for k = 1 : length(st)
        
        %to consider the ivds in order find the location of boundary in sorted
        %centriod ie. scentroid
        [~,location]=ismember(scentroid(k),centroids);
        t = st(location).BoundingBox;
        
        rect1=rectangle('Position', [t(1),t(2),t(3),t(4)],'EdgeColor','b','LineWidth',2 );
        
            crop_image = imcrop(image,[t(1),t(2),t(3),t(4)]);
            imwrite(crop_image, strcat('.....Crop\',int2str(noofimages),'_',int2str(cnt),'.tif'));
        
        
        cnt=cnt+1;
    end %inner for
end %outer for