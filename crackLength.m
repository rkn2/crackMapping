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


%draw lines through each set of cracks
%Agglomerative clustering with single linkage
%https://www.mathworks.com/help/matlab/math/creating-and-concatenating-matrices.html
Z = linkage(greenPoints, 'single'); %figures out which pixels are close to each other
%works but you have to know how many cracks you have.. so that is not
%optimal
%c = cluster(Z, 'maxclust', 100);
c = cluster(Z, 'cutoff', 0.1);
unique(c)

gscatter(xx,yy,c)

 

    
