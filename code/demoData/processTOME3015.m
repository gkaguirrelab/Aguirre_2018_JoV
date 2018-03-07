% processTOME3015
%

%% set paths and make directories
% create test sandbox on desktop
sandboxDir = '~/Desktop/processTOME3015';
if ~exist(sandboxDir,'dir')
    mkdir(sandboxDir)
end

%% hard coded parameters
nFrames = Inf; % number of frames to process (set to Inf to do all)
verbosity = 'full'; % Set to none to make the demo silent
TbTbToolboxName = 'transparentTrack';

% define path parameters
pathParams.dataSourceDirRoot = fullfile(sandboxDir,'TOME_data');
pathParams.dataOutputDirRoot = fullfile(sandboxDir,'TOME_processing');
pathParams.projectSubfolder = 'session2_spatialStimuli';
pathParams.eyeTrackingDir = 'EyeTracking';
pathParams.subjectID = 'TOME_3015';
pathParams.sessionDate = '032417';

runNameList = {'GazeCal04', 'tfMRI_RETINO_AP_run04'};


%% TbTb configuration
% We will suppress the verbose output, but detect if there are deploy
% errors and if so stop execution
% tbConfigResult=tbUse(TbTbToolboxName,'reset','full','verbose',false);
% if sum(cellfun(@sum,extractfield(tbConfigResult, 'isOk')))~=length(tbConfigResult)
%     error('There was a tb deploy error. Check the contents of tbConfigResult');
% end
% tbSnapshot=tbDeploymentSnapshot(tbConfigResult,'verbose',false);
% clear tbConfigResult
tbSnapshot='';

%% Prepare paths and directories

% define full paths for input and output
pathParams.dataSourceDirFull = fullfile(pathParams.dataSourceDirRoot, pathParams.projectSubfolder, ...
    pathParams.subjectID, pathParams.sessionDate, pathParams.eyeTrackingDir);
pathParams.dataOutputDirFull = fullfile(pathParams.dataOutputDirRoot, pathParams.projectSubfolder, ...
    pathParams.subjectID, pathParams.sessionDate, pathParams.eyeTrackingDir);

% Loop through the acquisitions
% for ii=1:length(runNameList)
%     pathParams.runName = runNameList{ii};
%     
%     % Run the analysis pipeline upto stage 6
%     runVideoPipeline( pathParams, ...
%         'nFrames',nFrames,'verbosity', verbosity, 'tbSnapshot',tbSnapshot, 'useParallel',true, ...
%         'pupilRange', [20 200], 'pupilCircleThresh', 0.05, 'pupilGammaCorrection', 1, ...
%         'glintFrameMask',  [130 100 70 100], ...
%         'overwriteControlFile', true, 'catchErrors', false,...
%         'makeFitVideoByNumber',[3 5 6], ...
%         'skipStageByNumber', [], ...
%         'lastStage', 'fitPupilPerimeter' );
% end


% Estimate an initial camera depth value. The observed maximum iris
% diameter in the gazeCal video is 216 pixels.
%{
    sceneGeometry = createSceneGeometry('radialDistortionVector',[-0.3517 3.5353], ...
        'intrinsicCameraMatrix',[2627.0 0 338.1; 0 2628.1 246.2; 0 0 1], ...
        'eyeLaterality','right','axialLength',23.45,'sphericalAmetropia',-0.5);
    cameraTranslationDepth = depthFromIrisDiameter( sceneGeometry, 216 );
%}

ellipseArrayList = [872; 1687; 2115;  929;  823; 1565; 1059; 1935; 1258; 1388;  560;  539; 1711; 1482];
        
% Estimate camera translation for just the gaze cal run
pathParams.runName = runNameList{1};
runVideoPipeline( pathParams, ...
    'nFrames',nFrames,'verbosity', verbosity, 'tbSnapshot',tbSnapshot, 'useParallel',true, ...
    'catchErrors', false,...
    'radialDistortionVector',[-0.3517 3.5353], ...
    'intrinsicCameraMatrix',[2627.0 0 338.1; 0 2628.1 246.2; 0 0 1], ...
    'eyeLaterality','right','axialLength',23.45,'sphericalAmetropia',-0.5,...
    'skipStageByNumber', [1:6], ...
    'translationLB',[-10; -10; 146], ...
    'translationUB',[10; 10; 150], ...
    'translationLBp',[-5; -5; 147], ...
    'translationUBp',[5; 5; 149], ...
    'nBADSsearches',10, ...
    'ellipseArrayList',ellipseArrayList, ...
    'constraintTolerance',0.03,...
    'lastStage', 'estimateCameraTranslation' );

customSceneGeometryFile = fullfile(pathParams.dataOutputDirFull,[runNameList{1} '_sceneGeometry.mat']);

% Loop through the acquisitions
for ii=1:length(runNameList)
    pathParams.runName = runNameList{ii};
    
    % Run the analysis pipeline for stages 8-end
    runVideoPipeline( pathParams, ...
        'nFrames',nFrames,'verbosity', verbosity, 'tbSnapshot',tbSnapshot, 'useParallel',true, ...
        'catchErrors', false,...
        'makeFitVideoByNumber',[8 9], ...
        'skipStageByNumber', [1:7], ...
        'customSceneGeometryFile', customSceneGeometryFile);
end