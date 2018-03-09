%load image
img = imread('G:\\My Drive\\Documents\\Undergrads\\Anna Blyth\\GreenWorms.jpg');
%test image
%img = imread('C:\\Users\\Rebecca Napolitano\\Downloads\\test.bmp');

%pull out only the green parts
green = img(:,:,2) > 128 & img(:,:,1) < 10;
[yy, xx] = find(green);

%plot the green parts
figure; 
imshow(img);
hold on
%plot(xx, yy, '.')
greenPoints = [xx,yy]; 


%cluster the groups of cracks
%Agglomerative clustering with single linkage
%https://www.mathworks.com/help/matlab/math/creating-and-concatenating-matrices.html
Z = linkage(greenPoints, 'single'); %figures out which pixels are close to each other
%works but you have to know how many cracks you have.. so that is not
%optimal
%c = cluster(Z, 'maxclust', 100);
c = cluster(Z, 'cutoff', 0.1);

%gscatter(xx,yy,c) %will color the different groups but not by length



%figure out how long each crack is

%figure out how many unique clusters there are
numClust = unique(c);
for i = 1:numClust
    clusterValue = numClust(i,1);
    selRow = find(c(:,1) == clusterValue); %finds the rows where that cluster's number is present
    numRows = length(selRow); %tells us how many rows we are looking at for that cluster
    
    XX = zeros(numRows,1); %values from xx in rows indicated by the cluster matrix
    YY = zeros(numRows,1); %values from yy in rows indicated by the cluster matrix
    
    for j = 1:numRows
        selRowValue = selRow(j,1); %get the number of the row we are interested in
        XX(j,1) = xx(selRowValue,1); %get the value in xx at that row
        YY(j,1) = yy(selRowValue,1); %get the value in yy at that row    
    end
    %scatter(XX,YY)
    %line(XX,YY)
    polyfit(XX,YY,1);
    XXYY = [XX,YY];
    d = diff(XXYY);
    total_length = sum(sqrt(sum(d.*d,2)));

end


 

    
