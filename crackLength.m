%% load image
img = imread('G:\\My Drive\\Documents\\Undergrads\\Anna Blyth\\GreenWorms.jpg');
%test image
%img = imread('C:\\Users\\Rebecca Napolitano\\Downloads\\test.bmp');

%% pull out only the green parts
green = img(:,:,2) > 128 & img(:,:,1) < 10;
[yy, xx] = find(green);

%plot the green parts
figure; 
imshow(img);
hold on
%plot(xx, yy, '.')
greenPoints = [xx,yy]; 

%% cluster the groups of cracks
%Agglomerative clustering with single linkage
%https://www.mathworks.com/help/matlab/math/creating-and-concatenating-matrices.html
Z = linkage(greenPoints, 'single'); %figures out which pixels are close to each other
%works but you have to know how many cracks you have.. so that is not
%optimal
%c = cluster(Z, 'maxclust', 100);
c = cluster(Z, 'cutoff', 0.1);

gscatter(xx,yy,c) %will color the different groups but not by length



%%
figure;
l = zeros(length(unique(c)),1);
f = zeros(length(unique(c)),1);
n = ceil(sqrt(length(unique(c))));
for i = 1:length(unique(c))
    subplot(n,n,i)
% logical indexing, grabs the rows in xx and yy where c == i 
thisCrack = [xx(c==i),yy(c==i)];
thisCrackImg = zeros(max(thisCrack)-min(thisCrack)+1);
imgID = thisCrack-min(thisCrack)+1;
for j = 1:length(imgID)
    thisCrackImg(imgID(j,1),imgID(j,2)) = 1;
end
bw = bwmorph(thisCrackImg,'skel',Inf);
l(i) = sum(sum(bw));
[nb, rb] = boxcount(bw);
fd_fit = polyfit(log(nb),log(rb),1);
f(i) = -fd_fit(1);
imshow(bw);
axis equal
title(sprintf('%.0f / %.2f',l(i),f(i)))
end
%%
% align the pixel values to a the predominant directions
axRotation = pca(thisCrack);
alignedMid = thisCrack * axRotation;
% scale and shift the pixels to a reference frame 
delta = max(alignedMid) - min(alignedMid);
axScale = min(1./delta);
axShift = 0.5 * delta - min(alignedMid);
refMid = (alignedMid + axShift) .* axScale;
refMid = refMid - mean(refMid);
hold off
plot(refMid(:,1),refMid(:,2),'.')
axis equal
% cluster nearby pixels into single points
Z = linkage(thisCrack, 'complete');
d = cluster(Z, 'maxclust', 100); % use 100 points arbitrarily
% calculate their midpoints
mid = zeros(length(unique(d)),2);
for j = 1:length(unique(d))
    mid(j,:) = mean(thisCrack(d==j,:));
end
% plot the clusters and their midpoints
gscatter(thisCrack(:,1),thisCrack(:,2),d);
hold on
plot(mid(:,1),mid(:,2),'ks')
axis equal
drawnow
pause

% figure out how long each crack is
%this only works for non-branched cracks right now!!!!!!!!!!!!
% traverse the crack from left to right
sorted = sortrows(refMid);
p = polyfit(sorted(:,1),sorted(:,2),10);
hold on
fit = [sorted(:,1),polyval(p,sorted(:,1))];
plot(fit(:,1),fit(:,2),'-')
l(i) = sum(sqrt(sum(diff(fit).^2,2))) / axScale;
drawnow
pause
end