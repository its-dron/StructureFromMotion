generateData;

%% Correct Essential Matrices
E12 = computeE(x1, x2);
% E12 = R2*makeSkewSymmetric(T2);
E13 = R3*makeSkewSymmetric(T3);

%% Calculate and triangulate
[p1, p2, p3, p4] = possibleExtrinsicsFromEssential(E12);
r1 = p1(:,1:3); t1 = p1(:,end)*10;
r2 = p2(:,1:3); t2 = p2(:,end)*10;
r3 = p3(:,1:3); t3 = p3(:,end)*10;
r4 = p4(:,1:3); t4 = p4(:,end)*10;

% Matlab is stupid (suck it Brian) and requires stupid data formats to
% triangulate correctly. In the end you basically get camMat = [R;t']*K for
% some stupid reason.
camPam = cameraParameters('IntrinsicMatrix', K);

exactCamMat1  = cameraMatrix(camPam, R1, T1);
exactCamMat2  = cameraMatrix(camPam, R2, T2);
camMat1 = cameraMatrix(camPam, r1, t1);
camMat2 = cameraMatrix(camPam, r2, t2);
camMat3 = cameraMatrix(camPam, r3, t3);
camMat4 = cameraMatrix(camPam, r4, t4);

% 'ground truth' triangulation. I don't use the original data so we can
% compare against what triangulation results with perfect data are.
X = triangulate(X1', X2', exactCamMat1, exactCamMat2)';

X1t = triangulate(X1', X2', exactCamMat1, camMat1)';
X2t = triangulate(X1', X2', exactCamMat1, camMat2)';
X3t = triangulate(X1', X2', exactCamMat1, camMat3)';
X4t = triangulate(X1', X2', exactCamMat1, camMat4)';

%% Plot Cameras
% cla
plotCamera('Location', T1, 'Orientation', R1, 'Size', .2, 'Color', 'k')
hold on
plotCamera('Location', T2, 'Orientation', R2, 'Size', .2, 'Color', 'g')
plotCamera('Location', t1, 'Orientation', r1, 'Size', .2, 'Color', 'c')
plotCamera('Location', t2, 'Orientation', r2, 'Size', .2, 'Color', 'b')
plotCamera('Location', t3, 'Orientation', r3, 'Size', .2, 'Color', 'r')
plotCamera('Location', t4, 'Orientation', r4, 'Size', .2, 'Color', 'm')

% scatter3(X(1,:), X(2,:), X(3,:), 'g');
% scatter3(X1t(1,:), X1t(2,:), X1t(3,:), 'c');
% scatter3(X2t(1,:), X2t(2,:), X2t(3,:), 'b');
% scatter3(X3t(1,:), X3t(2,:), X3t(3,:), 'r');
% scatter3(X4t(1,:), X4t(2,:), X4t(3,:), 'm');
grid on
axis equal
hold off

[R, t] = extrinsicsFromEssential(E12, K, X1, X2)