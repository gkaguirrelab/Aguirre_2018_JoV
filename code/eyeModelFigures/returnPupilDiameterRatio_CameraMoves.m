function [diamRatio, C, pupilFitError, theta, horizPixels, vertPixels] = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg,fixationAngles,stopDiam,sceneGeometry)


% Setup the camera position and rotation properties
sceneGeometry.cameraPosition.translation = [0; 0; 100];
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
azimuthDeg = (-viewingAngleDeg)-fixationAngles(1);
elevationDeg = zeros(size(viewingAngleDeg))-fixationAngles(2);


% Assemble the eyePose
eyePose=[azimuthDeg elevationDeg 0 stopDiam/2];

% First, perform the forward projection to determine where the center of
% the entrance pupil is located in the sceneWorld coordinates
% Obtain the center of the entrance pupil for this eye pose.
[~, ~, worldPoints, ~, ~, pointLabels] = pupilProjection_fwd(eyePose, sceneGeometry, 'nStopPerimPoints', 16);
pupilCenter = nanmean(worldPoints(strcmp(pointLabels,'pupilPerimeter'),:));

% Adjust the sceneGeometry to translate the camera to be centered on the
% entrance pupil. This is an attempt to match the arrangement of the Mathur
% study, in which the examiner adjusted the camera to be centered on the
% pupil.
adjustedSceneGeometry = sceneGeometry;
adjustedSceneGeometry.cameraPosition.translation = adjustedSceneGeometry.cameraPosition.translation+pupilCenter';

% Now, measure the pupil diameter ratio
[pupilEllipseOnImagePlane, imagePoints, ~, ~, ~, ~, ~, pupilFitError] = pupilProjection_fwd(eyePose, adjustedSceneGeometry,'nStopPerimPoints',16);
theta = pupilEllipseOnImagePlane(5);

p = ellipse_transparent2ex(pupilEllipseOnImagePlane);

% Account for the possibility of an ellipse that has a horizontal major
% axis
if theta < pi/4
    diamRatio=p(3)./p(4);
else
    diamRatio=p(4)./p(3);
end

k = max(imagePoints) - min(imagePoints);
horizPixels = k(1);
vertPixels = k(2);

% Reverse the theta to match the Mathur convention, in which a theta of
% zero corresponds to a pupil ellipse with the major axis aligned with the
% horizontal meridian, and positive values of theta are in the
% counter-clockwise direction.
theta = pi - theta;

% Calculate the Mathur value C from Equation 6
C = (1-diamRatio).*sin(2.*(theta-pi/2));

end
