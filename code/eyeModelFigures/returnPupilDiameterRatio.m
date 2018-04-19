function [diamRatio, theta, pupilFitError] = returnPupilDiameterRatio(viewingAngleDeg,pupilDiam,sceneGeometry)

% Setup the camera position and rotation properties
sceneGeometry.cameraExtrinsic.translation = [0; 0; 100];
sceneGeometry.eye.rotationCenters.azi = [0 0 0];
sceneGeometry.eye.rotationCenters.ele = [0 0 0];

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
azimuthDeg = (-viewingAngleDeg)-sceneGeometry.eye.alpha(1);
elevationDeg = zeros(size(viewingAngleDeg))-sceneGeometry.eye.alpha(2);

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
adjustedSceneGeometry.cameraExtrinsic.translation(1) = adjustedSceneGeometry.cameraExtrinsic.translation(1)+geometricPupilCenter(1);
adjustedSceneGeometry.cameraExtrinsic.translation(2) = adjustedSceneGeometry.cameraExtrinsic.translation(2)+geometricPupilCenter(2);

% Now, measure the horizontal and vertical width of the image of the pupil
[pupilEllipseOnImagePlane, imagePoints, ~, ~, ~, ~, pupilFitError] = pupilProjection_fwd(eyePose, adjustedSceneGeometry, 'nPupilPerimPoints',50);
horizDiam =max(imagePoints(:,1)')-min(imagePoints(:,1)');
vertDiam  =max(imagePoints(:,2)')-min(imagePoints(:,2)');
theta = pupilEllipseOnImagePlane(5);
diamRatio=horizDiam./vertDiam;

end
