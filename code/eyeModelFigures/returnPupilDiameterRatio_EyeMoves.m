function [diamRatio, C, pupilFitError] = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg,pupilDiam,sceneGeometry)

azimuthDeg = (-rotationAngleDeg)-sceneGeometry.eye.axes.alpha.degField(1);
elevationDeg = zeros(size(rotationAngleDeg))-sceneGeometry.eye.axes.alpha.degField(2);

% Assemble the eyePose
eyePose=[azimuthDeg elevationDeg 0 pupilDiam/2];

% Measure the horizontal and vertical width of the image of the pupil
[pupilEllipseOnImagePlane, imagePoints, ~, ~, ~, ~, pupilFitError] = pupilProjection_fwd(eyePose, sceneGeometry, 'nPupilPerimPoints',50);
horizDiam =max(imagePoints(:,1)')-min(imagePoints(:,1)');
vertDiam  =max(imagePoints(:,2)')-min(imagePoints(:,2)');
theta = pupilEllipseOnImagePlane(5);
diamRatio=horizDiam./vertDiam;

% Scale pupil fit error by the radius of the pupil
pupilFitError = pupilFitError / sqrt(pupilEllipseOnImagePlane(3)/pi);

% Reverse the theta to match the Mathur convention, in which a theta of
% zero corresponds to a pupil ellipse with the major axis aligned with the
% horizontal meridian, and positive values of theta are in the
% counter-clockwise direction.
theta = pi - theta;

% Calculate the Mathur value C from Equation 6
C = (1-diamRatio).*sin(2.*(theta-pi/2));


end
