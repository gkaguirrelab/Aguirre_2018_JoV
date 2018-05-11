
% The size of the exit pupil
actualPupilDiam = 2.6451*2;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.7;

sensorResolution=[960 720];
intrinsicCameraMatrix = [2600 0 480; 0 2600 360; 0 0 1];

sceneGeometry = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'intrinsicCameraMatrix',intrinsicCameraMatrix,'sensorResolution',sensorResolution,'spectralDomain','vis');

% Setup the camera position and rotation properties
sceneGeometry.cameraPosition.translation = [0; 0; 100];
sceneGeometry.eye.rotationCenters.azi = [0 0 0];
sceneGeometry.eye.rotationCenters.ele = [0 0 0];

viewingAngleDeg = -65:30:55;

modelEyeLabelNames = {'posteriorChamber' 'posteriorChamber_hidden' 'irisPerimeter' 'pupilPerimeterFront' 'pupilPerimeterBack' 'pupilEllipse' 'pupilCenter' 'anteriorChamber'};
modelEyePlotColors = {'.w' '.w' '.b' '*g' '*g' '-g' '+r' '.y'};


for vv = 1:length(viewingAngleDeg)
    
    % Our model rotates the eye. For the right eye, a positive azimuth rotates
    % the eye such that the center of the pupil moves to the right of the
    % image. This means that a positive azimuth corresponds to the camera being
    % positioned in the temporal portion of the visual field. So, we must sign
    % reverse the interpretation of our azimuthal values for measurements made
    % in the right eye to correspond to the Mathur results. Additionally, we
    % need to adjust for visual: the angle between the pupil and visual axes of
    % the eye. The coordinates of our model eye are based around the pupil
    % axis. Therfore, we need to calculate a rotation that accounts for the
    % Mathur viewing angle and visual.
    azimuthDeg = (-viewingAngleDeg(vv))-sceneGeometry.eye.axes.visual.degField(1);
    elevationDeg = -sceneGeometry.eye.axes.visual.degField(2);
    
    % Assemble the eyePose
    eyePose=[azimuthDeg elevationDeg 0 actualPupilDiam/2];
    
    % First, perform the forward projection to determine where the center of
    % the pupil is located in the sceneWorld coordinates
    sceneGeometryNoRefract = sceneGeometry;
    sceneGeometryNoRefract.refraction = [];
    [~, ~, worldPoints, ~, pointLabels] = pupilProjection_fwd(eyePose, sceneGeometryNoRefract,'fullEyeModelFlag',true);
    idx = strcmp(pointLabels,'pupilCenter');
    pupilCenter = worldPoints(idx,:);
    
    % Adjust the sceneGeometry to translate the camera to be centered on
    % geometric center of the pupil center in the sceneWorld space. This is an
    % attempt to match the arrangement of the Mathur study, in which the
    % examiner adjusted the camera to be centered on the pupil.
    adjustedSceneGeometry = sceneGeometry;
    adjustedSceneGeometry.cameraPosition.translation = adjustedSceneGeometry.cameraPosition.translation+pupilCenter';
    
    renderEyePose(eyePose, adjustedSceneGeometry,'modelEyeLabelNames',modelEyeLabelNames,'modelEyePlotColors',modelEyePlotColors);
    
    figureName=['cameraMoves_' num2str(viewingAngleDeg(vv)) '.pdf'];
    
    saveThatSucker(figureName)
    
end