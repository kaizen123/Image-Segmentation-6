function plot3dclusters( data, labels, centers )
% PLOTCLUSTERS Plots a set of differently colored point clusters.
%   PLOT3DCLUSTERS( DATA, LABELS, centers ) plots the 3D data D with each of
%   its different clusters as different colors. The cluster centers and
%   labels are specified by LABELS and centers respectively.

figure;
% plot each cluster
n = size(centers,2);
for label = 1:n
    % pick random color
    color = rand([3 1]);
    cluster = data( :,  labels == label  );
    plot3(cluster(1,:),cluster(2,:),cluster(3,:),'.','Color',color); hold on;
    plot3(centers(1,label), centers(2,label), centers(3,label), 'kx', 'MarkerSize', 24.0, 'LineWidth', 4.0);
end
grid on;
    
    
