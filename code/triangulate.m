function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points
%
% outputs:
%   P - Nx3 3d coordinates
%   error - scalar reprojection error

nPoints = length(p1);
P = zeros(nPoints, 4);
        
%% Iterate through points, calculating SVD
for i = 1:nPoints
    A = [ p1(i,1)*M1(3,:) - M1(1,:); ...
          p1(i,2)*M1(3,:) - M1(2,:); ... 
          p2(i,1)*M2(3,:) - M2(1,:); ...
          p2(i,2)*M2(3,:) - M2(2,:) ];
    [~,~,V] = svd(A, 'econ');
    P(i,:) = V(:,end);
    P(i,:) = P(i,:) / P(i,4); %normalize
end

%% Calcualte Error
p1Hat = M1 * P';
p1Hat = bsxfun(@rdivide, p1Hat(1:2,:), p1Hat(3,:)); %normalize
p2Hat = M2 * P';
p2Hat = bsxfun(@rdivide, p2Hat(1:2,:), p2Hat(3,:)); %normalize
error = sum([sum((p1-p1Hat').^2, 2); sum((p2-p2Hat').^2, 2)]);

%% Debug Plot
figure;
scatter(p1(:,1),p1(:,2),'o');
hold on
scatter(p1Hat(1,:), p1Hat(2,:),'x');
figure;
scatter(p2(:,1),p2(:,2),'o');
hold on
scatter(p2Hat(1,:),p2Hat(2,:),'x');
figure;
scatter3(P(:,1),P(:,2),P(:,3));

%% Crop output
P = P(:,1:3);