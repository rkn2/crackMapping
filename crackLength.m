%load image
img2 = imread('G:\\My Drive\\Documents\\Undergrads\\Anna Blyth\\GreenWorms.jpg');
%test image
%img = imread('C:\\Users\\Rebecca Napolitano\\Downloads\\test.bmp');

%pull out only the green parts
green = img2(:,:,2) > 128 & img2(:,:,1) < 10;
[yy, xx] = find(green);

%plot the green parts
figure; 
imshow(img2);
hold on
plot(xx, yy, '.')

%draw lines through each set of cracks



 

    
