%% modelEyeFigure3D

sceneGeometry = createSceneGeometry('sphericalAmetropia',-0.823);

figure;

subplot(2,2,1)
% Plot the optical system
plotOpticalSystem('newFigure',false,'surfaceSet',sceneGeometry.refraction.retinaToCamera,'addLighting',true);
% Define an initial ray arising at the fovea
p = sceneGeometry.eye.axes.visual.coords';
% Assemble the ray
u = [1;tand(sceneGeometry.eye.axes.visual.degField(1));tand(sceneGeometry.eye.axes.visual.degField(2))];
u = u./sqrt(sum(u.^2));
R = [p, u];
% Perform the ray trace
[outputRay, rayPath] = rayTraceQuadrics(R, sceneGeometry.refraction.retinaToCamera.opticalSystem);
% Add this ray to the optical system plot
plotOpticalSystem('newFigure',false,'outputRay',outputRay,'rayPath',rayPath,'viewAngle',[0 90]);
% Add a little space to the axes
zlim manual
xlim manual
ylim manual
ylim([-15 15]);
zlim([-15 15]);
xlim([-27 5]);


subplot(2,2,3)
% Plot the optical system
plotOpticalSystem('newFigure',false,'surfaceSet',sceneGeometry.refraction.retinaToCamera,'addLighting',true);
% Define an initial ray arising at the fovea
p = sceneGeometry.eye.axes.visual.coords';
% Assemble the ray
u = [1;tand(sceneGeometry.eye.axes.visual.degField(1));tand(sceneGeometry.eye.axes.visual.degField(2))];
u = u./sqrt(sum(u.^2));
R = [p, u];
% Perform the ray trace
[outputRay, rayPath] = rayTraceQuadrics(R, sceneGeometry.refraction.retinaToCamera.opticalSystem);
% Add this ray to the optical system plot
plotOpticalSystem('newFigure',false,'outputRay',outputRay,'rayPath',rayPath,'viewAngle',[0 0]);
% Add a little space to the axes
zlim manual
xlim manual
ylim manual
ylim([-15 15]);
zlim([-15 15]);
xlim([-27 5]);

subplot(2,2,[2 4])
% Plot the optical system
plotOpticalSystem('newFigure',false,'surfaceSet',sceneGeometry.refraction.retinaToCamera,'addLighting',true);
% Define an initial ray arising at the fovea
p = sceneGeometry.eye.axes.visual.coords';
% Assemble the ray
u = [1;tand(sceneGeometry.eye.axes.visual.degField(1));tand(sceneGeometry.eye.axes.visual.degField(2))];
u = u./sqrt(sum(u.^2));
R = [p, u];
% Perform the ray trace
[outputRay, rayPath] = rayTraceQuadrics(R, sceneGeometry.refraction.retinaToCamera.opticalSystem);
% Add this ray to the optical system plot
plotOpticalSystem('newFigure',false,'outputRay',outputRay,'rayPath',rayPath,'viewAngle',[40 40]);

set(gcf,'color','white')
