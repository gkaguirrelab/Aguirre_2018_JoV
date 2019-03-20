%% modelEyeFigure



figure
subplot(2,1,1)
accomodationDiopters = 1000/3000;

sceneGeometryEmm = createSceneGeometry(...
    'sphericalAmetropia',0,...
    'accommodationDiopeters',accomodationDiopters,...
    'spectralDomain','vis',...
    'calcLandmarkFovea',true);
[outputRayLoSEmm,rayPathLoSEmm] = calcLineOfSightRay(sceneGeometryEmm);

% sceneGeometryMyope = createSceneGeometry(...
%     'sphericalAmetropia',-10,...
%     'accommodationDiopeters',accomodationDiopters,...
%     'spectralDomain','vis',...
%     'calcLandmarkFovea',true);
% [outputRayLoSMyope,rayPathLoSMyope] = calcLineOfSightRay(sceneGeometryMyope);


plotModelEyeSchematic(sceneGeometryEmm.eye,'rayPath',rayPathLoSEmm,'outputRay',outputRayLoSEmm,'view','axial','newFigure',false,'plotColor','k')
% plotModelEyeSchematic(sceneGeometryMyope.eye,'rayPath',rayPathLoSMyope,'outputRay',outputRayLoSMyope,'view','axial','newFigure',false,'plotColor','r')

subplot(2,1,2)

plotModelEyeSchematic(sceneGeometryEmm.eye,'rayPath',rayPathLoSEmm,'outputRay',outputRayLoSEmm,'view','sagittal','newFigure',false,'plotColor','k')
% plotModelEyeSchematic(sceneGeometryMyope.eye,'rayPath',rayPathLoSMyope,'outputRay',outputRayLoSMyope,'view','sagittal','newFigure',false,'plotColor','r')
