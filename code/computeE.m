function [ E ] = computeE( pts1, pts2 )
%computeE computes the essential matrix and handles preconditioning and
%postconditioning

%% Check Inputs
nPoints = size(pts1,2);

% Check for same dimensions between point sets
isequal(size(pts1), size(pts2));

% Enforce Homogenous Coordinate Style
if size(pts1,2) ~= 3
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
% Enforce only 5 independent parameters
[U, S, V] = svd(naiveE, 'econ');
robustE = U * diag([1 1 0]) * V';

% Rescale back to original coordinate system.
E = T1' * robustE * T2;

end

