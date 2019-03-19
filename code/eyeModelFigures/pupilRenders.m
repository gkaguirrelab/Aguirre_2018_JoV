
% The size of the exit pupil
stopDiam = 2.6484*2;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = (6*1.2-11*2.9)/30;

% Subjects in the Mathur study fixated a point 3 meters away
fixationTargetDistance = 3000;
accomodationDiopters = 1000/3000;

% Define how we'd like the images to look
sensorResolution=[960 720];
intrinsicCameraMatrix = [2600 0 480; 0 2600 360; 0 0 1];
%    'intrinsicCameraMatrix',intrinsicCameraMatrix,'sensorResolution',sensorResolution, ...

sceneGeometry = createSceneGeometry(...
    'sphericalAmetropia',sphericalAmetropia,...
    'accommodationDiopeters',accomodationDiopters,...
    'spectralDomain','vis',...
    'calcLandmarkFovea',true);

% Setup the camera position and rotation properties. We position the camera
% farther away than was used for the measurements to allow the entire model
% eye to appear within the sensor display.
sceneGeometry.cameraPosition.translation = [0; 0; 150];
sceneGeometry.eye.rotationCenters.azi = [0 0 0];
sceneGeometry.eye.rotationCenters.ele = [0 0 0];

viewingAngleDeg = -65:30:55;

modelEyeLabelNames = {'retina' 'retina_hidden' 'irisPerimeter' 'pupilPerimeter' 'pupilEllipse' 'stopCenter' 'cornea'};
modelEyePlotColors = {'.w' '.w' 'ob' '*g' '-g' '+r' '.y'};


for vv = 1:length(viewingAngleDeg)
    
    % Our model rotates the eye. For the right eye, a positive azimuth
    % rotates the eye such that the center of the pupil moves to the right
    % of the image. This means that a positive azimuth corresponds to the
    % camera being positioned in the temporal portion of the visual field.
    % So, we must sign reverse the interpretation of our azimuthal values
    % for measurements made in the right eye to correspond to the Mathur
    % results. Additionally, we need to adjust for visual: the angle
    % between the pupil and visual axes of the eye. The coordinates of our
    % model eye are based around the pupil axis. Therfore, we need to
    % calculate a rotation that accounts for the Mathur viewing angle and
    % visual.
    azimuthDeg = (-viewingAngleDeg(vv))-sceneGeometry.eye.landmarks.fovea.degField(1);
    elevationDeg = -sceneGeometry.eye.landmarks.fovea.degField(2);
    
    % Assemble the eyePose
    eyePose=[azimuthDeg elevationDeg 0 stopDiam/2];
    
    % First, perform the forward projection to determine where the center of
    % the pupil is located in world coordinates
    sceneGeometryNoRefract = sceneGeometry;
    sceneGeometryNoRefract.refraction = [];
    [~, ~, worldPoints, ~, ~, pointLabels] = pupilProjection_fwd(eyePose, sceneGeometryNoRefract,'fullEyeModelFlag',true);
    pupilCenter = nanmean(worldPoints(strcmp(pointLabels,'pupilPerimeter'),:));
    
    % Adjust the sceneGeometry to translate the camera to be centered on
    % the pupil center. This is an attempt to match the arrangement of the
    % Mathur study, in which the examiner adjusted the camera to be
    % centered on the pupil.
    adjustedSceneGeometry = sceneGeometry;
    adjustedSceneGeometry.cameraPosition.translation = adjustedSceneGeometry.cameraPosition.translation+pupilCenter';
    
    figHandle=renderEyePose(eyePose, adjustedSceneGeometry,'modelEyeLabelNames',modelEyeLabelNames,'modelEyePlotColors',modelEyePlotColors,'nStopPerimPoints',16);
    
    figureName=['cameraMoves_' num2str(viewingAngleDeg(vv)) '.pdf'];
    
    saveThatSucker(figHandle,figureName)
    
end