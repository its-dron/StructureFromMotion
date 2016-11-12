function [ F, bestInlierIdx ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorith, how you determined which
%     points are inliers, and any other optimizations you made

%% Tunable Parameters
inlierRadius = 1; %pixel radius for inlier classification
squaredRadius = inlierRadius^2;
nItr = 1000; %Number of RANSAC to perform

%% Paramter Calculation
nPoints = length(pts1);
pts1H = [pts1'; ones(1, nPoints)];
pts2H = [pts2'; ones(1, nPoints)];

%% RANSAC ITERATION using 7pt algo
bestInlierIdx = [];
nBestInliers = 0;
for i = 1:nItr
    ptsIdx = randperm(nPoints,7);
    pts17 = pts1(ptsIdx,:);
    pts27 = pts2(ptsIdx,:);
    [ Fs ] = sevenpoint( pts17, pts27, M );
    for j = 1: length(Fs)
        F = Fs{j};
        inlierIdx = findInliers(pts1H, pts2H, F, squaredRadius);
        nInlier = nnz(inlierIdx);
        if nInlier > nBestInliers
            bestInlierIdx = inlierIdx;
            nBestInliers = nInlier;
        end
    end
end

%% Recalculate F with all inliers using the 8pt algo
[ F ] = eightpoint( pts1(bestInlierIdx, :), pts2(bestInlierIdx, :), M );
end

% Return a boolean array representing which points are inliers
function [inlierIdxs] = findInliers(pts1, pts2, F, tol)
    w1 = F*pts1; % w1 - epipolar lines
    n1 = sqrt(sum(w1(1:2,:).^2, 1)); % sqrt(a^2 + b^2)
    w1 = bsxfun(@rdivide, w1, n1); % normalize
    d1 = abs(sum(pts2 .* w1, 1));  % distance to line

    w2 = F*pts2; % w2 - epipolar lines
    n2 = sqrt(sum(w2(1:2,:).^2, 1)); % sqrt(a^2 + b^2)
    w2 = bsxfun(@rdivide, w2, n2); % normalize
    d2 = abs(sum(pts2 .* w2, 1));  % distance to line

    inlierIdxs = max(d1, d2) < tol;
end



