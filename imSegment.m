function [labeled_image] = imSegment(image, k, feature_type, spatial)
%IMSEGMENT image segmentation.
%   Description of its functionaility is given in the assignment
%
%   Parameters: 
%       image: RGB image
%       k: number of clusters (if k = 0, plot the graph for elbow method)
%       feature_type: the feature type you use in your implementation as
%       suggested in the assignment description
%       spatial: boolean(true or false) variable stating wheather or not to use spatial
%       features
%   Output:
%       labeled_image: segmentated image where its pixels' values are
%       replaced with clusters' number

%% Calculating Image Resolution
number_of_rows = size(image, 1);    % Height of Image
number_of_columns = size(image, 2); % Width of Image

%% Applying Image Smoothing
sigma = 1;       % Standard deviation for Image Smoothing
image = imgaussfilt3(image, sigma);

%% Checking which color space to use
if strcmpi(feature_type, 'hsv')
    new_image = rgb2hsv(image);
elseif strcmpi(feature_type, 'lab')
    new_image = rgb2lab(image);
elseif strcmpi(feature_type, 'rgb')
    new_image = image;
else
    display('Enter strings only "HSV", "RGB" or "LAB" as feaure_type');
end

% converting image to double
doubled_image = double(new_image);

%% Extracting individual color channels
color_channel_1 = doubled_image(:,:,1);
color_features_1 = color_channel_1(:)'; %converting it to a row array

color_channel_2 = doubled_image(:,:,2);
color_features_2 = color_channel_2(:)'; %converting it to a row array

color_channel_3 = doubled_image(:,:,3);
color_features_3 = color_channel_3(:)'; %converting it to a row array

%% Normalising the color features
%Employing Min-Max Normalisation
color_features_1 = ( color_features_1 - min(color_features_1) )./( max(color_features_1) - min(color_features_1));
color_features_2 = ( color_features_2 - min(color_features_2) )./(max(color_features_2) - min(color_features_2) );
color_features_3 = ( color_features_3 - min(color_features_3) )./(max(color_features_3) - min(color_features_3) );

%% Checking if spatial features are also needed
if (~spatial)
    % feature matrix is only the color channels if spatial argument is
    % false
    feats = [color_features_1; color_features_2; color_features_3];
else
    % calculating spatial features
    %   i) Calculating Row Features Matrix
    row_array = 1:number_of_rows;
    row_features = repmat(row_array(:),[1, number_of_columns]);
    %   Converting Row Features matrx to a single vector
    row_features = row_features(:)';
    
    %   ii) Calcluating Column Features Matrix
    column_array = 1:number_of_columns;
    column_features = repmat(column_array, [number_of_rows, 1]);
    %   Converting Column Features matrx to a single vector
    column_features = column_features(:)';
    
    % Normalising Row and Column Features
    row_features = ( row_features - min(row_features) )./( max(row_features) - min(row_features) );
    column_features = ( column_features - min(column_features) )./( max(column_features) - min(column_features) );
    
    % Final feature matrix combining all the features
    weight = 3; % Extra weight given to the three color features
    feats = [weight*color_features_1; weight*color_features_2; weight*color_features_3; row_features; column_features];
end

%% If k = 0, we plot the Intra Matrix variance vs. Number of Clusters (Elbow Method)

if k == 0
    max_k_value = 10;   % maximum value of k to be analysed fr elbow method
    labels = ones(number_of_columns * number_of_rows, max_k_value - 1);   % label matrix
    variance = ones(1,max_k_value - 1); %   initialzing SSE vector
    for k = 2:max_k_value
        rng(0);     % setting random seed as 0 for stable comparison between differnt k values
        [labels(:,k-1), ~, ~, variance(:,k-1)] = yourKMeans(feats,k);
    end
    figure; plot(2:max_k_value, variance, '--gs');  % plot the SSE 
    xlabel('Number of clusters');
    ylabel('Intra-Cluster Variance/ Number of Pixels');
    labeled_image = 0;  %   Return o as the labeled image if k = 0
else
    % if K is not zero run KMeans for that value of K and return the
    % labeled image
    [labels, ~, ~] = yourKMeans(feats, k);
    labeled_image = reshape(labels, number_of_rows, number_of_columns);
end

end
