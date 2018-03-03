%% eyeposeQuantificationError

clearvars

%% Obtain a sceneGeometry structure
% createSceneGeometry returns a default sceneGeometry structure
sceneGeometry = createSceneGeometry();

%% Obtain the ray tracing functions
rayTraceFuncs = assembleRayTraceFuncs( sceneGeometry );

%% Define some variables
pupilRadiusMM = 2;
nAzi = 6;
nEle = 6;
translationError1SD = 6.1866;
translationError2SD = 10.7749;

%% Loop over aimuths and elevations to create pupil border points
% The range of values used here corresponds to the biological limits of the
% rotation of the eye horizontally and vertically.
thisTorsion = 0;
for aziIdx = 1:nAzi
    for eleIdx = 1:nEle
        
        thisAzimuth = (aziIdx-1)*5;
        thisElevation = (eleIdx-1)*5;
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


%% Create scene geometries with +1 and +2SD of camera depth error
sceneGeometry1SDerror = sceneGeometry;
sceneGeometry1SDerror.extrinsicTranslationVector(3) = 120 + translationError1SD;
rayTraceFuncs1SDerror = assembleRayTraceFuncs( sceneGeometry1SDerror );
sceneGeometry2SDerror = sceneGeometry;
sceneGeometry2SDerror.extrinsicTranslationVector(3) = 120 + translationError2SD;
rayTraceFuncs2SDerror = assembleRayTraceFuncs( sceneGeometry2SDerror );

%% Find the inverse eye pose solutions
for aziIdx = 1:nAzi
    for eleIdx = 1:nEle
        inverseEyePose1SDerror(aziIdx,eleIdx,:) = eyePoseEllipseFit(squeeze(Xp(aziIdx,eleIdx,:)), squeeze(Yp(aziIdx,eleIdx,:)), sceneGeometry1SDerror, rayTraceFuncs1SDerror,'eyePoseLB',[-50,-45,0,0.5],'eyePoseUB',[50,45,0,4]);
        inverseEyePose2SDerror(aziIdx,eleIdx,:) = eyePoseEllipseFit(squeeze(Xp(aziIdx,eleIdx,:)), squeeze(Yp(aziIdx,eleIdx,:)), sceneGeometry2SDerror, rayTraceFuncs2SDerror,'eyePoseLB',[-50,-45,0,0.5],'eyePoseUB',[50,45,0,4]);
    end
end

%% Reshape the eye poses into lists suitable for quivering
veridicalAziList = reshape(eyePoses(:,:,1),nAzi*nEle,1);
veridicalEleList = reshape(eyePoses(:,:,2),nAzi*nEle,1);
inverseAziList1SDerror = reshape(inverseEyePose1SDerror(:,:,1),nAzi*nEle,1);
inverseEleList1SDerror = reshape(inverseEyePose1SDerror(:,:,2),nAzi*nEle,1);
inverseAziList2SDerror = reshape(inverseEyePose2SDerror(:,:,1),nAzi*nEle,1);
inverseEleList2SDerror = reshape(inverseEyePose2SDerror(:,:,2),nAzi*nEle,1);

figure

%% Quiver
subplot(2,1,1)
quiver(veridicalAziList,veridicalEleList,inverseAziList2SDerror,inverseEleList2SDerror,'-r');
hold on
q=quiver(veridicalAziList,veridicalEleList,inverseAziList1SDerror,inverseEleList1SDerror);
q.Color = [1 0.4 0.6];
plot(veridicalAziList,veridicalEleList,'.k');
axis equal

%% Circle
veridicalRadii = ones(nAzi*nEle,1)*pupilRadiusMM;
inverseRadii1SDerror = reshape(inverseEyePose1SDerror(:,:,4),nAzi*nEle,1);
inverseRadii2SDerror = reshape(inverseEyePose2SDerror(:,:,4),nAzi*nEle,1);
subplot(2,1,2)
viscircles([veridicalAziList veridicalEleList],inverseRadii2SDerror,'Color',[1 0 0],'LineWidth',0.5);
hold on
viscircles([veridicalAziList veridicalEleList],inverseRadii1SDerror,'Color',[1 0.5 0.5],'LineWidth',0.5);
viscircles([veridicalAziList veridicalEleList],veridicalRadii,'Color',[.5 .5 .5],'LineWidth',0.5);
axis equal;
