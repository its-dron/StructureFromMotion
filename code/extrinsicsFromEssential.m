function [ R, t ] = extrinsicsFromEssential(E, K, pts1, pts2)
%EXTRINSICSFROMESSENTIAL Summary of this function goes here
%   Detailed explanation goes here

% assert(size(pts1) == size(pts2));

[P1, P2, P3, P4] = possibleExtrinsicsFromEssential(E);
R1 = eye(3); T1 = zeros(3,1);
r1 = P1(:,1:3); t1 = P1(:,end);
r2 = P2(:,1:3); t2 = P2(:,end);
r3 = P3(:,1:3); t3 = P3(:,end);
r4 = P4(:,1:3); t4 = P4(:,end);

rots = cell(1,4);
rots{1} = r1; rots{2} = r2; rots{3} = r3; rots{4} = r4;
ts = cell(1,4);
ts{1} = t1; ts{2} = t2; ts{3} = t3; ts{4} = t4;

camPam = cameraParameters('IntrinsicMatrix', K);

camMatOrigin = cameraMatrix(camPam, R1, T1); 
camMat1 = cameraMatrix(camPam, r1, t1);
camMat2 = cameraMatrix(camPam, r2, t2);
camMat3 = cameraMatrix(camPam, r3, t3);
camMat4 = cameraMatrix(camPam, r4, t4);

% Count triangulated points in front of camera
X1t = triangulate(pts1', pts2', camMatOrigin, camMat1)';
count1 = nnz(checkPointsInFrontOfCam(R1,T1,X1t).*checkPointsInFrontOfCam(r1,t1,X1t));

X2t = triangulate(pts1', pts2', camMatOrigin, camMat2)';
count2 = nnz(checkPointsInFrontOfCam(R1,T1,X2t).*checkPointsInFrontOfCam(r2,t2,X2t));

X3t = triangulate(pts1', pts2', camMatOrigin, camMat3)';
count3 = nnz(checkPointsInFrontOfCam(R1,T1,X3t).*checkPointsInFrontOfCam(r3,t3,X3t));

X4t = triangulate(pts1', pts2', camMatOrigin, camMat4)';
count4 = nnz(checkPointsInFrontOfCam(R1,T1,X4t).*checkPointsInFrontOfCam(r4,t4,X4t));

% Find max and return
[~,i] = max([count1, count2, count3, count4]);
R = rots{i};
t = ts{i};
end

