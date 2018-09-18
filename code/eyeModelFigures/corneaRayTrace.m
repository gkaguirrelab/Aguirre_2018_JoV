%% corneaRayTrace

% Plot a set of rays of different initial thetas on the default model eye

    sceneGeometry = createSceneGeometry();
    % Define an initial ray
    p = [sceneGeometry.eye.pupil.center(1); 2; 0];
    u = [1;tand(31);0];
    u = u./sqrt(sum(u.^2));
    inputRay = [p, u];
    % Perform the ray trace
    [outputRay, rayPath] = rayTraceQuadrics(inputRay, sceneGeometry.refraction.pupilToCamera.opticalSystem);
    % Plot the optical system
    plotOpticalSystem('surfaceSet',sceneGeometry.refraction.pupilToCamera,...
        'outputRay',outputRay,'rayPath',rayPath, ...
        'addLighting',true);
    
for deg = 31:-15:-44
    u = [1;tand(deg);0];
    u = u./sqrt(sum(u.^2));
    inputRay = [p, u];
    [outputRay, rayPath] = rayTraceQuadrics(inputRay, sceneGeometry.refraction.pupilToCamera.opticalSystem);
    plotOpticalSystem('newFigure',false,...
        'outputRay',outputRay,'rayPath',rayPath,'viewAngle',[0 90]);
    drawnow
end
