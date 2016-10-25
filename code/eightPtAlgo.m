function [ E ] = eightPtAlgo( pts1, pts2 )
%eightPtAlgo computes the Essential matrix given two sets of corresponding
%points.
%   Computes the 3x3 essential matrix E such that: [pts1]' * E * [pts2] = 0
%   Expects inputs to be a nxm vector where the first row corresponds to x
%   values and the second row corresponds to y values.  These coordinates
%   represent m points.
%
%   Uses the 8-point Algorithm
%
%   By: Brian Pugh

%% Check Inputs
nPoints = size(pts1,2);

% Check for same dimensions between point sets
assert(isequal(size(pts1), size(pts2)), 'Matrix dimensions must agree.');

% Enforce Homogenous Coordinate Style
if size(pts1,1) ~= 3
    pts1 = [pts1(1:2,:); ones(1,nPoints)];
    pts2 = [pts2(1:2,:); ones(1,nPoints)];
end

%% Form A Matrix of Ax=0
A = [pts1(1,:)' .* pts2(1,:)', ...
     pts1(1,:)' .* pts2(2,:)', ...
     pts1(1,:)',               ...
     pts1(2,:)' .* pts2(1,:)', ...
     pts1(2,:)' .* pts2(2,:)', ...
     pts1(2,:)',               ...
     pts2(1,:)',                ...
     pts2(2,:)',                ...
     ones(nPoints,1)];

%% Solve for the flatten E matrix using SVD
[uA, sA, vA] = svd(A, 'econ');
E = reshape(vA(:,end),3,3);

end
% Pre conditioning: translate and scale data points to be centered at
% origin and avg dist = sqrt(2)

% Post conditioning: E must have rank=2, there aree only five independent
% parameters