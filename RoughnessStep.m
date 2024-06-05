% Set the directory path
imageDir = 'C:\Users\Kokila Saravanan\OneDrive\Documents\MATLAB\Visual Inspection';
% Get the list of all image files 
imageFiles = dir(fullfile(imageDir, '*.jpg'));
% Define the patch size and number of patches
patchSize = 32;
numPatches = 64;
% Initialize arrays to store the patch data, uniformity values, roughness values, and corroded/non-corroded labels
patchData = zeros(numPatches, patchSize^2);
uniformityValues = zeros(numPatches, 1);
roughnessValues = zeros(numPatches, 1);
labels = zeros(numPatches, 1);
% Loop over each image file
for i = 1:length(imageFiles)
    % Read in the image and resize it
    image = imread(fullfile(imageDir, imageFiles(i).name));
    image = imresize(image, 0.5);
    % Convert the image to grayscale
    grayImage = rgb2gray(image);
    % Select patches from the image
    [rows, cols] = size(grayImage);
    randRows = randi(rows-patchSize, numPatches, 1);
    randCols = randi(cols-patchSize, numPatches, 1);
    for j = 1:numPatches
        patch = grayImage(randRows(j):randRows(j)+patchSize-1, randCols(j):randCols(j)+patchSize-1);
        patchData(j, :) = reshape(patch, [1, patchSize^2]);
    end
    % Calculate the uniformity of the patches
    uniformityValues = std(patchData, 0, 2)./mean(patchData, 2);
    % Calculate the roughness of the patches
    [Gmag, ~] = imgradient(patch);
    roughnessValues = mean(Gmag(:));
    % Set labels for corroded/non-corroded patches
    threshold = 0.15;
    labels(roughnessValues > 0 & uniformityValues > threshold) = 1;
    % Separate corroded and non-corroded patches
    corrodedPatches = patchData(labels == 1, :);
    nonCorrodedPatches = patchData(labels == 0, :);
    % Mark corroded areas
    corrodedAreas = false(size(grayImage));
    corrodedAreasCount = 0;
    for j = 1:numPatches
        if labels(j) == 1
            patchRowStart = randRows(j);
            patchColStart = randCols(j);
            corrodedAreas(patchRowStart:patchRowStart+patchSize-1, patchColStart:patchColStart+patchSize-1) = true;
            corrodedAreasCount = corrodedAreasCount + 1;
        end
    end
    % Overlay the corroded areas on the image and display it
    figure;
    imshow(imoverlay(image, corrodedAreas, [1 0 0]));
    title(sprintf('Image %d with %d Corroded Areas Marked', i, corrodedAreasCount));
end
