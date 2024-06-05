% Define the directory 
img_dir = 'C:\Users\Kokila Saravanan\OneDrive\Documents\MATLAB\Visual Inspection';

% Define the directory to save the corroded images
corroded_dir = 'D:\Corroded';

% Define the directory to save the non-corroded images
non_corroded_dir = 'D:\Non-corroded';

% Create the directories if they don't exist
if ~exist(corroded_dir, 'dir')
    mkdir(corroded_dir);
end

if ~exist(non_corroded_dir, 'dir')
    mkdir(non_corroded_dir);
end

% Get a list of all the image files 
img_files = dir(fullfile(img_dir, '*.jpg'));

% Initialize a cell array 
image_table = cell(length(img_files), 1);

% Loop through each image file
for i = 1:length(img_files)
    % Load the image
    img = imread(fullfile(img_dir, img_files(i).name));
    
    % Convert the image to grayscale
    gray_img = rgb2gray(img);
    
    % Enhance the contrast of the image
    enhanced_img = imadjust(gray_img, [0.2 0.8], []);
    
    % Perform thresholding
    binary_img = imbinarize(enhanced_img, 'adaptive');
    
    % Fill the gaps in the corroded regions
    filled_img = imfill(binary_img, 'holes');
    
    % Remove small objects from the image
    cleaned_img = bwareaopen(filled_img, 50);
    
    % Find the connected regions in the image
    cc = bwconncomp(cleaned_img);
    
    % Get the properties of the regions
    stats = regionprops(cc, 'Area', 'BoundingBox');
    
    % Filter out regions
    valid_regions = stats([stats.Area] > 1000 & [stats.Area] < 50000);
    
    % Draw the bounding boxes on the original image
    figure;
    imshow(img);
    hold on;
    for j = 1:length(valid_regions)
        rectangle('Position', valid_regions(j).BoundingBox, 'LineWidth', 2, 'EdgeColor', 'r');
    end
    hold off;
    
    % Save the corroded and non-corroded images separately
    if isempty(valid_regions)
        imwrite(img, fullfile(non_corroded_dir, img_files(i).name));
    else
        imwrite(img, fullfile(corroded_dir, img_files(i).name));
    end
    
    % Store the image in the cell array
    image_table{i} = img;
end

% Display the images in a table
figure;
tiledlayout('flow', 'TileSpacing', 'Compact');
for i = 1:length(image_table)
    nexttile;
    imshow(image_table{i});
    title(img_files(i).name, 'Interpreter', 'none');
end
