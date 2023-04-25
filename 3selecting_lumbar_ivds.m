clear all
close all

%From the center points calculated in "Center_points_for_ivds.m", consider only the 6 lumbar images

for noofimages =  1:93
    centers=load(strcat('....\Center points for ivds\',int2str(noofimages),'.mat'));
    iv_disc=imread(strcat('....\segment\',int2str(noofimages),'.tif'));
    figure,imshow(iv_disc);

    CC = bwconncomp(iv_disc);
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
            iv_disc(CC.PixelIdxList{jj1})=0;
        end
    end
    
    figure,imshow(iv_disc);
      imwrite(iv_disc, strcat('....\Lumbar IVDs Segmented\',int2str(noofimages),'.tif'))
 end