%% projectionValidation

sceneGeometry = createSceneGeometry;
sceneGeometry.cameraIntrinsic.matrix = [1000 0 -50; 0 1000 -50; 0 0 -1];
sceneGeometry.cameraIntrinsic.sensorResolution = [100 100];
sceneGeometry.cameraPosition.translation = [5; 0; 100];
sceneGeometry.cameraPosition.torsion = 0;

sceneGeometry.eye.cornea.front.radii = [10 10 10];
sceneGeometry.eye.cornea.front.center = [0 0 0];
sceneGeometry.eye.cornea.axis = [0 0 0];
sceneGeometry.eye.pupil.center = [0 0 0];
sceneGeometry.eye.pupil.eccenFcnString = '@(x) 0';
sceneGeometry.eye.pupil.thetas = [0 0];
sceneGeometry.eye.rotationCenters.azi = [0 0 0];
sceneGeometry.eye.rotationCenters.ele = [0 0 0];
sceneGeometry.eye.rotationCenters.tor = [0 0 0];
opticalSystem = nan(10,4);
opticalSystem(1,4) = 1.3370;
opticalSystem(2,:) = [0 -10 -10 1.0];

sceneGeometry.refraction.opticalSystem.p1p2 = opticalSystem;
sceneGeometry.refraction.opticalSystem.p1p3 = opticalSystem;

eyePose = [45 0 0 1];

[pupilEllipseOnImagePlane, imagePoints, worldPoints, eyeWorldPoints, pointLabels, nodalPointIntersectError, pupilFitError] = pupilProjection_fwd(eyePose, sceneGeometry);

modelEyeLabelNames = {'pupilPerimeter' 'anteriorChamber' 'cornealApex'};
modelEyePlotColors = {'*g' '.y' '*y'};

renderEyePose(eyePose, sceneGeometry, 'modelEyeLabelNames',modelEyeLabelNames,'modelEyePlotColors',modelEyePlotColors);