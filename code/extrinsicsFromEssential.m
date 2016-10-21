function [R, t] = extrinsicsFromEssential(E)
%EXTRINSICSFROMESSENTIAL Get camera extrinsics from the essential matrix
%   Given an essential matrix between cameras 1 and 2, returns the
%   extrinsic parameters for camera 2 with respect to camera 1.
%
%   [R,t] = extrinsicsFromEssential(E) returns rotation and translation
%   matrix calculated from E
%   
%   By: Daniel Ron

[u,~,v] = svd(E);

Z = [1 0 0; 0 1 0; 0 0 0];
R90 = [0 1 0; -1 0 0; 0 0 1];

% get skew symmetric transpose matrix
tx = u*Z*R90*u';
t = [tx(3,2); tx(1,3); tx(2,1)];

R = v'*u*R90';
end