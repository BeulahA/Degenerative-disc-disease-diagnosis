close all;
clear all;
for noofimages=1:93
  rgb=imread(strcat('....Path\',int2str(noofimages),'.tif'));
  figure;
  imshow(rgb);

  [maskOut]=kGaussian_color_EM(rgb,2);
  figure; 
  imshow(maskOut);
  img=rgb2gray(maskOut);
 
  fgm = imregionalmax(img);
  figure
  imshow(fgm), title('Regional maxima (fgm)')
 

  ed=edge(fgm,'canny');
  
I2 = ed;
I2(fgm) = 255;
figure
imshow(I2), title('Regional maxima superimposed on edge (I2)')
ed1 = imcomplement(I2);
BW2 = imfill(ed1,'holes');
 figure,imshow(BW2), title('After fill holes')
BW4 = bwmorph(BW2,'thin');

BW5 = bwmorph(BW4,'open');

 figure,imshow(BW5), title('After superimposed and morphological operators')
ed2=edge(BW5,'canny');
 figure,imshow(ed2), title('After canny superimposed');
se = strel('line',20,90);
closeBW = imclose(ed2,se);
figure, imshow(closeBW),title('After close');


LB = 200;
UB = 3000;
Iout = xor(bwareaopen(BW5,LB),  bwareaopen(BW5,UB));
 figure, imshow(Iout);title('first xor');
Iout1 = or(Iout, closeBW);
 figure, imshow(Iout1);title('first or');
Iout2 = and(Iout1, BW5);
 figure, imshow(Iout2);title('first and');

LB = 300;
UB = 3000;
Iout3 = xor(bwareaopen(Iout2,LB),  bwareaopen(Iout2,UB));
 figure,
  imshow(Iout3);title('next xor');

CC = bwconncomp(Iout3);
%finding the disc
s = regionprops('table',CC,'Centroid','Orientation', 'MajorAxisLength','MinorAxisLength');

scentroid = cat(2, s.Centroid,s.Orientation, s.MajorAxisLength,s.MinorAxisLength);
%sort according to Y axis
%scentroid = sortrows(centroids,2); % sorted centroid

[n m]=size(scentroid);
z=0;
%selecting only ivd's and omiting non ivd's by the angle of ivds criteria (tilt angle)
for ii= 1:n
    if((scentroid(ii,3)<=50 & scentroid(ii,3)>=-20) )  %first correct
         % hold on
         % plot(scentroid(ii,1),scentroid(ii,2), 'b*');
         % hold off
        z=z+1;
        xx(z)=scentroid(ii,1);
        yy(z)=scentroid(ii,2);
     end
end

% deslecting the component in the lower end of image
ivd1=cat(1,xx,yy);
ivd2=ivd1';
[n_1 m_1]=size(ivd2);
z1=0
for in= 1:n_1
    if(ivd2(in,2)<=460 )  %first correct
%          hold on
%          plot(ivd2(in,1),ivd2(in,2), 'b*');
%          hold off
        z1=z1+1;
        xx1(z1)=ivd2(in,1);
        yy1(z1)=ivd2(in,2);
     end
end
ivd_ce=cat(1,xx1,yy1);
ivd_centroids=ivd_ce';
[n1 m1]=size(ivd_centroids);

%delete remaining elements

count=0;
for ii=1:n
    for ii1=1:n1
        if ivd_centroids(ii1,1) == scentroid(ii,1)
            count=count+1;
            all(count,:)=scentroid(ii,1:5);
        end
    end
end

Alias=CC.PixelIdxList;
Alias1=CC.PixelIdxList;
count1=0;
for ii=1:n
    for ii1=1:n1
        if ivd_centroids(ii1,1) == scentroid(ii,1)
           Alias{ii}=0;
        end
    end
end
[r1 c1]=size(Alias);
for i1=1:c1
    if Alias{i1}==0
        Alias1{i1}=1;
    else
        Alias1{i1}=0;
    end
end

[row col]= size(CC.PixelIdxList);
for jj1=1:col
    if Alias1{jj1}==0
        Iout3(CC.PixelIdxList{jj1})=0;
    end
end

    figure,imshow(Iout3);
       
    B = bwboundaries(Iout3);
    hold on
    for k = 1:length(B)
        boundary = B{k};
        %find right end of a component
        max_x=max(boundary(:,2));
        ind=find(boundary(:,2)== max_x);
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
        plot(boundary(ind,2), boundary(ind,1), 'b', 'LineWidth', 3)
    end
    hold off

  imwrite(Iout3, strcat('....path\',int2str(noofimages),'.tif'))
 
 
end