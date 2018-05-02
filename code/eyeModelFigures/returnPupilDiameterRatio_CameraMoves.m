function [diamRatio, C, pupilFitError, theta] = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg,pupilDiam,sceneGeometry)

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
azimuthDeg = (-viewingAngleDeg)-sceneGeometry.eye.axes.alpha.degField(1);
elevationDeg = zeros(size(viewingAngleDeg))-sceneGeometry.eye.axes.alpha.degField(2);

% Assemble the eyePose
eyePose=[azimuthDeg elevationDeg 0 pupilDiam/2];

% First, perform the forward projection to determine where the center of
% the pupil is located in the sceneWorld coordinates
[~, ~, worldPoints] = pupilProjection_fwd(eyePose, sceneGeometry);

% Adjust the sceneGeometry to translate the camera to be centered on
% geometric center of the pupil center in the sceneWorld space. This is an
% attempt to match the arrangement of the Mathur study, in which the
% examiner adjusted the camera to be centered on the pupil.
geometricPupilCenter = mean(worldPoints);
adjustedSceneGeometry = sceneGeometry;
adjustedSceneGeometry.cameraPosition.translation(1:2) = adjustedSceneGeometry.cameraPosition.translation(1:2)+geometricPupilCenter(1:2)';

% Now, measure the pupil diameter ratio
[pupilEllipseOnImagePlane, ~, ~, ~, ~, ~, pupilFitError] = pupilProjection_fwd(eyePose, adjustedSceneGeometry,'nPupilPerimPoints',16);

theta = pupilEllipseOnImagePlane(5);
% Reverse the theta to match the Mathur convention, in which a theta of
% zero corresponds to a pupil ellipse with the major axis aligned with the
% horizontal meridian, and positive values of theta are in the
% counter-clockwise direction.
theta = pi - theta;
p = ellipse_transparent2ex(pupilEllipseOnImagePlane);
diamRatio=p(4)./p(3);

% Calculate the Mathur value C from Equation 6
C = (1-diamRatio).*sin(2.*(theta-pi/2));

end
