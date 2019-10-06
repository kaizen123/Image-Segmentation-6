function [labels, centers, distances, variance ] = yourKMeans(feats, k)
%   YOURKMEANS k-means algorithm
%
%   Parameters:
%       feats:      n-by-p dimensional features' matrix
%       k:          number of clusters 
%   Output:
%       labels:     the assignment of features to clusters
%       centers:    the clusters' centers
%       distances:  the distances of each data point to each cluster
%
%       n: number of features
%       p: number of pixels

%%  Defining Variables
n = size(feats, 1); % Number of features
p = size(feats, 2); % Number of Pixels

%%  Choosing Random k points as centres for initialization
feature_matrix = transpose(feats);  % transposing the feature matrix
initial_k_centres_indices = randsample(p, k);   %choosing k random points for initialisation
k_centres = feature_matrix(initial_k_centres_indices,:);    

%%  calculting distances from the centres
counter_variable = 0;   % variable that counts the number of iterTIONS
convergence = 1;    %   algorithm  stops working when the centres stop changing continuously for 10 iterations 
while(true)
    counter_variable = counter_variable + 1;
    distances = pdist2(feature_matrix, k_centres);  % calculating distances
    [min_distance, indices] = min(distances,[], 2); %   calculating which obserbation is closest to which center
    new_k_centres = ones(k, n); %   initilaizing new centres
    
    % calculating the value of new centres by taking the mean of all values
    % within one cluster
    for i = 1:k
        new_k_centres(i,:) = sum(feature_matrix(indices == i, :),1)/size(feature_matrix(indices == i, :),1);
    end
    
    % convergence critera (needs to be staisfied continuously 10 times just to be sure)
    if(new_k_centres == k_centres)
        convergence = convergence + 1;
        if convergence > 10
            break;
        end
    end
    
    % updating k centers
    k_centres = new_k_centres;
end

% Assigning values to output variables
labels = indices;
centers = k_centres';
distances = min_distance;
variance = sum(min_distance.^2)/p;

% 3d plot for the clusters
%plot3dclusters(feature_matrix',labels', centers);  
    
end