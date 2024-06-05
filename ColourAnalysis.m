% Define directory containing images
image_dir = 'C:\Users\Kokila Saravanan\OneDrive\Documents\MATLAB\Visual Inspection';

% Load all images in directory
image_files = dir(fullfile(image_dir, '*.jpg')); % Assumes images are in PNG format
num_images = length(image_files);

% Set filter parameters
sigma = 12;
hue_threshold =0.89;

% Loop through all images
for i = 1:num_images
    % Load image
    image_filename = fullfile(image_dir, image_files(i).name);
    image = imread(image_filename);
    
    % Convert image to HSV
    image_hsv = rgb2hsv(image);
    
    % Apply Gaussian filter to hue channel
    hue_filtered = imgaussfilt(image_hsv(:,:,1), sigma);
    
    % Compute probability distribution of hue values
    hue_prob = histcounts(hue_filtered(:), linspace(0, 1, 101), 'Normalization', 'probability');
    
    % Identify corroded pixels
    corroded_pixels = hue_prob(round(hue_filtered*100)+1) < hue_threshold & (image_hsv(:,:,2) > 0.5);
    
    % Create mask to mark corroded pixels in red
    red_mask = uint8(cat(3, ones(size(image(:,:,1))), zeros(size(image(:,:,2))), zeros(size(image(:,:,3))))) .* 255 .* uint8(corroded_pixels);
    
    % Create color image to mark corroded pixels in red
    marked_image = image + red_mask;
    
    % Display corroded image if there are any corroded pixels
    if any(corroded_pixels(:))
        figure;
        imshow(marked_image);
        title(sprintf('Corroded Image %d', i));
    end
end







