function SFM( imPaths, Ks )
%SFM Generates 3D model given a folder of images of the model.
%   Extreme WIP, just something to help us get started.
%   Probably also take in Camera Parameters
%   imagesPaths - cell array of image paths (nx1)
%   Ks - cell array of camera intrinsic matrices (each 3x3) (nx1)

%% User Parameters
% Used
matchThresh = 1.5; %default value 1.5

%% Setup the VLFeat Toolbox
VLFEATROOT = fullfile('..', 'vlfeat-0.9.20');
run(fullfile(VLFEATROOT, 'toolbox', 'vl_setup'));
fprintf('VLFeat Version: %s.\n', vl_version);

%% Get image file names and declare variables
nImages = length(imPaths);

%% SIFT
SIFTFilename = fullfile(folderPath, 'SIFT.mat');

%load precomputed SIFT data exists
if exist(SIFTFilename, 'file')==2
    load(SIFTFilename, 'features', 'descriptors', 'matches', 'scores');
else %Compute SIFT data
    [features, descriptors, matches, scores] = SIFT(imPaths, matchThresh);
    %Save Results
    save(SIFTFilename, ...
        'features', 'descriptors', 'matches', 'scores');
end

%% Data Integrity Check

%% Camera Pose Estimation

%% Triangulation

%% Bundle Adjustment

%% Final Reconstruction.
end

