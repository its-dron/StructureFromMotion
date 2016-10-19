function [ ptsConditioned, transform ] = preconditionPts( pts, avgDist )
%PRECONDITIONPTS Centers points around origin with avg dist sqrt(2)
%   Returns ptsConditioned, a matrix of size 2xnPoints, the centroid of the
%   points is the origin and the avgDist is the distance specified (default
%   sqrt(2).
%
%   transform is the 3x3 transformation matrix:
%           ptsConditioned = transform * pts
%
%
%   By: Brian Pugh

%% Check Inputs 
pts = pts(1:2,:);

if ~isscalar(avgDist)
    error('Optional Input avgDist must be a scalar');
end
if nargin < 2
    avgDist = sqrt(2);
end

%% Compute
centroid = mean(pts,2);
ptsCentered = bsxfun(@minus, pts, centroid);
distFromOrigin = sqrt(ptsCentered(1,:).^2 + ptsCentered(2,:).^2);
avgDistFromOrigin = mean(distFromOrigin(:));
scale = avgDist / avgDistFromOrigin;
ptsConditioned = scale * ptsCentered;
transform = [scale*eye(3,2),[-scale*centroid; 1]];

end

