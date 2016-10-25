function [ in_front_of_cam ] = checkPointsInFrontOfCam( R, t, X )
%CHECKPOINTSINFRONTOFCAM Finds which points are in front of the camera.
%Used for testing possible decompositions of the Essential Matrix.
%   R - 3x3 Extrinsic rotation matrix
%   t - 3x1 Extrinsic translation vector
%   X - 3xN or homogenous 4xN matrix of world points
%
%   in_front_of_cam - 1xN boolean mask representing which points are in
%   front of the camera
    
% Convert to homogenous coordinates
N = size(X,2);
if size(X,1) ~= 4
    X = [X; ones(1, N)];
end

% Get equation for dividing plane defined by camera location and direciton.
cameraVec = R\[0;0;1];
w = [cameraVec; -t'*cameraVec];

% Find points on correct side of plane
in_front_of_cam = w'*X > 0;

end

