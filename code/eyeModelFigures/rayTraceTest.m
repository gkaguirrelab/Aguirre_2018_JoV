%% TEST_virtualImageFunc

sceneGeometry = createSceneGeometry();
sceneGeometry.eye.pupil.eccenFcnString = '@(x) 0';
sceneGeometry.eye.pupil.thetas = [0 0];
sceneGeometry.refraction.handle = @virtualImageFunc;
sceneGeometry.refraction.path = which('virtualImageFunc');

[outputRay, thetas, imageCoords, intersectionCoords] = rayTraceCenteredSurfaces([-3.7 2], deg2rad(3), sceneGeometry.refraction.opticalSystem.p1p3, true);

% Move the camera to intersect the output ray. The eyeWorld virtual image
% coord should be unchanged
sceneGeometry.cameraPosition.translation(3) = 50;
sceneGeometry.cameraPosition.translation(2) = (50-outputRay(1,1))*tan(thetas(3)+pi)+outputRay(1,2);

%
%sceneGeometry.cameraPosition.translation(1) = 0;
%sceneGeometry.cameraPosition.translation(3) = imageCoords(3,1);

expectedEyeWorldVirtualImageCoord = [-3.7, -(imageCoords(3,1)--3.7)*thetas(3), 0];

eyePose = [0 0 0 2];
[pupilEllipseOnImagePlane, imagePoints, worldPoints, eyeWorldPoints, pointLabels, nodalPointIntersectError, pupilFitError] = pupilProjection_fwd(eyePose, sceneGeometry);

% 
% [outputRay, thetas, imageCoords, intersectionCoords] = rayTraceCenteredSurfaces([-3.7 1e-6], deg2rad(15), sceneGeometry.refraction.opticalSystem.p1p3, true);
% sceneGeometry.eye.rotationCenters.azi = [imageCoords(3) 0 0];
% sceneGeometry.eye.rotationCenters.ele = [imageCoords(3) 0 0];
% eyePose = [0 -rad2deg(thetas(3)) 0 1e-6];
% 
% [pupilEllipseOnImagePlane, imagePoints, worldPoints, eyeWorldPoints, pointLabels, nodalPointIntersectError, pupilFitError] = pupilProjection_fwd(eyePose, sceneGeometry,'nPupilPerimPoints',8);
