%% eyeposeQuantificationError

clearvars

%% Obtain a sceneGeometry structure
% createSceneGeometry returns a default sceneGeometry structure
sceneGeometry = createSceneGeometry();

%% Obtain the ray tracing functions
rayTraceFuncs = assembleRayTraceFuncs( sceneGeometry );

%% Define some variables
pupilRadiusMM = 2;

figure

%% Loop over aimuths and elevations to create pupil border points
% The range of values used here corresponds to the biological limits of the
% rotation of the eye horizontally and vertically.
thisTorsion = 0;
for aziIdx = 1:15
    for eleIdx = 1:11
        
        thisAzimuth = (aziIdx-8)*5;
        thisElevation = (eleIdx-6)*5;
        thisTorsion = 0;
        
        % Assemble the eyePoses variable
        eyePoses(aziIdx, eleIdx, :)=[thisAzimuth,thisElevation,thisTorsion,pupilRadiusMM];
        
        % Forward projection from eyePoses to image ellipse
        pupilEllipseOnImagePlane = pupilProjection_fwd(eyePoses(aziIdx, eleIdx, :), sceneGeometry, rayTraceFuncs);
        pupilEllipseAreas(aziIdx,eleIdx) = pupilEllipseOnImagePlane(3);
        
        % Obtain boundary points for this ellipse
        [ Xp(aziIdx, eleIdx, :), Yp(aziIdx, eleIdx, :) ] = ellipsePerimeterPoints( pupilEllipseOnImagePlane );
    end
end

%% Plot the variation in ellipse area on the image plane
subplot(4,3,3)
image = (pupilEllipseAreas./pupilEllipseAreas(8,6))';
plotMatrix(image, [0.8 1],'proportion max area');


%% Calculate the error without ray tracing
for aziIdx = 1:15
    for eleIdx = 1:11
        
        inverseEyePose = eyePoseEllipseFit(squeeze(Xp(aziIdx,eleIdx,:)), squeeze(Yp(aziIdx,eleIdx,:)), sceneGeometry, [],'eyePoseLB',[-40,-35,0,0.5],'eyePoseUB',[40,35,0,4]);
        
        eyePoseErrors(aziIdx,eleIdx,:) = inverseEyePose-squeeze(eyePoses(aziIdx, eleIdx, :))';
    end
end

idxToPlot = [1,2,4];
cBarRange = [-5 5; -5 5; 0 0.5];
titleStrings = {'azi','ele (no ray trace)','radius'};
for pp = 1:3
    subplot(4,3,pp+3)
    image = eyePoseErrors(:,:,idxToPlot(pp))';
    plotMatrix(image, cBarRange(pp,:), titleStrings{pp});
end


%% Calculate the error with 1SD worth of camera depth error



%% Local plot function
function plotMatrix(image, cBarRange, titleString)
[nr,nc] = size(image);
pcolor([image nan(nr,1); nan(1,nc+1)]);
shading flat;
axis equal
% Set the axis backgroud to dark gray
set(gcf,'Color',[1 1 1]); set(gca,'Color',[.75 .75 .75]); set(gcf,'InvertHardCopy','off');
colorbar;
xticks((1:1:size(image,2))+.5);
xticklabels(-35:5:35);
xtickangle(90);
yticks((1:1:size(image,1))+.5);
yticklabels(-25:5:25);
xlim([1 size(image,2)+1]);
ylim([1 size(image,1)+1]);
xlabel('veridical azimuth [deg]')
ylabel('veridical elevation [deg]')
caxis(cBarRange);
title(titleString);

end