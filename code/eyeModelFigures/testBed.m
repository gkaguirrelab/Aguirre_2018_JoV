sphericalAmetropia = -0.72;
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis','forceMATLABVirtualImageFunc',true);
sg.eye.pupil.eccenFcnString = '@(x) 0';
sg.eye.axes.alpha.degField = [0 0 0];
sg.cameraPosition.translation = [0; 0; 100];
sg.eye.rotationCenters.azi = [-3.7 0 0];
sg.eye.rotationCenters.ele = [-3.7 0 0];

azimuthDeg = 60;
elevationDeg = 0;
exitPupilRadius = 2.7933;

eyePose=[azimuthDeg elevationDeg 0 exitPupilRadius];

% First, perform the forward projection to determine where the center of
% the pupil is located in the sceneWorld coordinates
% noRefractSG = sg;
% noRefractSG.refraction = [];
% [~, imagePoints, worldPoints, eyePoints, pointLabels] = pupilProjection_fwd(eyePose, noRefractSG,'fullEyeModelFlag',true);
% idx = strcmp(pointLabels,'pupilCenter');
% pupilCenter = worldPoints(idx,:);

% Adjust the sceneGeometry to translate the camera to be centered on
% geometric center of the pupil center in the sceneWorld space. This is an
% attempt to match the arrangement of the Mathur study, in which the
% examiner adjusted the camera to be centered on the pupil.
asg = sg;
%asg.cameraPosition.translation = asg.cameraPosition.translation+pupilCenter';


args = {asg.cameraPosition.translation, ...
    asg.eye.rotationCenters, ...
    asg.refraction.opticalSystem};
[virtualEyePoint, nodalPointIntersectError] = asg.refraction.handle( [asg.eye.pupil.center(1) 0 exitPupilRadius], eyePose, args{:} )

% Thetas for 0 eye rotation =  1.4908e-19, 0.0789
% Thetas for 60 eye rotation = -0.8748, 0.0628