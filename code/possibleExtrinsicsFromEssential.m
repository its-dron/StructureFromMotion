function [P1, P2, P3, P4] = possibleExtrinsicsFromEssential(E)
%EXTRINSICSFROMESSENTIAL Get camera extrinsics from the essential matrix
%   Given an essential matrix between cameras 1 and 2, returns the
%   extrinsic parameters for camera 2 with respect to camera 1.
%
%   [R,t] = extrinsicsFromEssential(E) returns rotation and translation
%   matrix calculated from E
%   
%   By: Daniel Ron

[u,~,v] = svd(E);
W = [0 -1 0; 1 0 0; 0 0 1];

% check that determinant isn't negative
if abs(det(u*v') + 1) < 1e-10
    v(:,end) = -v(:,end);
end

t = v(:,end);
R1 = u*W'*v';
R2 = u*W*v';
% R1 = R1'; R2 = R2';

P1 = [R1, t]; P2 = [R1, -t]; P3 = [R2, t]; P4 = [R2, -t];
% P1 = [R1, R1'*t]; P2 = [R1, -R1'*t]; P3 = [R2, R2'*t]; P4 = [R2, -R2'*t];
% P1 = [R1, R1*t]; P2 = [R1, -R1*t]; P3 = [R2, R2'*t]; P4 = [R2, -R2'*t];
% P1 = [R1, R1'*t]; P2 = [R1, -R1'*t]; P3 = [R2, R2*t]; P4 = [R2, -R2*t];
end