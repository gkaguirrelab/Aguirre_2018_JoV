
% The size of the exit pupil
pupilDiam = 6.19/1.13;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.8308;

sensorResolution=[960 720];
intrinsicCameraMatrix = [2600 0 480; 0 2600 360; 0 0 1];

sceneGeometry = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'intrinsicCameraMatrix',intrinsicCameraMatrix,'sensorResolution',sensorResolution);

% Setup the camera position and rotation properties
sceneGeometry.cameraPosition.translation = [0; 0; 100];
sceneGeometry.eye.rotationCenters.azi = [0 0 0];
sceneGeometry.eye.rotationCenters.ele = [0 0 0];

viewingAngleDeg = -50:25:50;

modelEyeLabelNames = {'posteriorChamber' 'irisPerimeter' 'pupilPerimeter' 'anteriorChamber'};
modelEyePlotColors = {'.w' '.b' '*g' '.y'};


for vv = 1:length(viewingAngleDeg)
        
    % Our model rotates the eye. For the right eye, a positive azimuth rotates
    % the eye such that the center of the pupil moves to the right of the
    % image. This means that a positive azimuth corresponds to the camera being
    % positioned in the temporal portion of the visual field. So, we must sign
    % reverse the interpretation of our azimuthal values for measurements made
    % in the right eye to correspond to the Mathur results. Additionally, we
    % need to adjust for alpha: the angle between the pupil and visual axes of
    % the eye. The coordinates of our model eye are based around the pupil
    % axis. Therfore, we need to calculate a rotation that accounts for the
    % Mathur viewing angle and alpha.
    azimuthDeg = (-viewingAngleDeg(vv))-sceneGeometry.eye.axes.alpha.degField(1);
    elevationDeg = -sceneGeometry.eye.axes.alpha.degField(2);
    
    % Assemble the eyePose
    eyePose=[azimuthDeg elevationDeg 0 pupilDiam/2];

    % First, perform the forward projection to determine where the center of
    % the pupil is located in the sceneWorld coordinates
    [~, ~, sceneWorldPoints] = pupilProjection_fwd(eyePose, sceneGeometry, 'nPupilPerimPoints',50);
    
    % Adjust the sceneGeometry to translate the camera to be centered on
    % geometric center of the pupil center in the sceneWorld space. This is an
    % attempt to match the arrangement of the Mathur study, in which the
    % examiner adjusted the camera to be centered on the pupil.
    geometricPupilCenter = mean(sceneWorldPoints);
    adjustedSceneGeometry = sceneGeometry;
    adjustedSceneGeometry.cameraPosition.translation(1:2) = adjustedSceneGeometry.cameraPosition.translation(1:2)+geometricPupilCenter(1:2)';
    
    renderEyePose(eyePose, adjustedSceneGeometry,'modelEyeLabelNames',modelEyeLabelNames,'modelEyePlotColors',modelEyePlotColors);

end