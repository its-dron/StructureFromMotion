function [ E ] = computeE( pts1, pts2 )
%computeE computes the essential matrix and handles preconditioning and
%postconditioning

%% Check Inputs
nPoints = size(pts1,2);

% Check for same dimensions between point sets
assert(isequal(size(pts1), size(pts2)), 'Matrix dimensions must agree.');

% Enforce Homogenous Coordinate Style
if size(pts1,1) ~= 3
    pts1 = [pts1(1:2,:); ones(1,nPoints)];
    pts2 = [pts2(1:2,:); ones(1,nPoints)];
end

%% Precondition
% Center points around origin and standardize distances.
[ pts1Conditioned, T1 ] = preconditionPts( pts1 );
[ pts2Conditioned, T2 ] = preconditionPts( pts2 );

%% Comptue
naiveE = eightPtAlgo( pts1Conditioned, pts2Conditioned );

%% Postcondition
% Rescale back to original coordinate system.
naiveE = T1' * naiveE * T2;
% naiveE = T1 * naiveE * T2';

[U, ~, V] = svd(naiveE, 'econ');

% Enforce only 5 independent parameters
E = U * diag([1 1 0]) * V';


end

