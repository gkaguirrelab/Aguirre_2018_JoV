function [diamRatio, C, pupilFitError, theta, horizPixels, vertPixels] = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg,pupilDiam,sceneGeometry)

azimuthDeg = rotationAngleDeg-sceneGeometry.eye.axes.visual.degField(1);
elevationDeg = zeros(size(rotationAngleDeg))-sceneGeometry.eye.axes.visual.degField(2);

% Assemble the eyePose
eyePose=[azimuthDeg elevationDeg 0 pupilDiam/2];

% Now, measure the pupil diameter ratio
[pupilEllipseOnImagePlane, imagePoints, ~, ~, ~, ~, pupilFitError] = pupilProjection_fwd(eyePose, sceneGeometry,'nPupilPerimPoints',16);

theta = pupilEllipseOnImagePlane(5);
% Reverse the theta to match the Mathur convention, in which a theta of
% zero corresponds to a pupil ellipse with the major axis aligned with the
% horizontal meridian, and positive values of theta are in the
% counter-clockwise direction.
theta = pi - theta;
p = ellipse_transparent2ex(pupilEllipseOnImagePlane);
diamRatio=p(4)./p(3);

k = max(imagePoints) - min(imagePoints);
horizPixels = k(1);
vertPixels = k(2);

% Calculate the Mathur value C from Equation 6
C = (1-diamRatio).*sin(2.*(theta-pi/2));



end
