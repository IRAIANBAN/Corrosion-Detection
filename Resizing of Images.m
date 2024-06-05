% Load image
img = imread("Images\I152_steel-(high-hard)_abrasive-blasted_flash-rust-inhibitor_MIL-DTL-53022_MIL-DTL-53039.jpg");

% Get the current size of the image
currentSize = size(img);

% Define the new width of the image
newWidth = 500;

% Compute the new height of the image 
newHeight = round(currentSize(1) * newWidth / currentSize(2));

% Resize the image 
resizedImg = imresize(img, [newHeight, newWidth]);

% Display the original and resized images side by side
figure;
subplot(1,2,1);
imshow(img);
title('Original Image');
subplot(1,2,2);
imshow(resizedImg);
title('Resized Image');