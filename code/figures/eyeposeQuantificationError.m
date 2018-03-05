%% eyeposeQuantificationError

clearvars

%% Obtain a sceneGeometry structure
% createSceneGeometry returns a default sceneGeometry structure
sceneGeometry = createSceneGeometry();

%% Obtain the ray tracing functions
rayTraceFuncs = assembleRayTraceFuncs( sceneGeometry );

%% Define some variables
pupilRadiusMM = 2;
thisTorsion = 0;
nAzi = 6;
nEle = 6;
translationError1SD = 7.0850;
translationError2SD = 12.5934;
conditionalSigmaLength = 0.9384;


%% Create the veridical ellipses
% The veridical eye has an axial length 1 SD longer than default.
sceneGeometryVeridical_1SDcase = createSceneGeometry('axialLength',23.5924+conditionalSigmaLength);
rayTraceFuncsVeridical_1SDcase = assembleRayTraceFuncs( sceneGeometryVeridical_1SDcase );

sceneGeometryVeridical_2SDcase = createSceneGeometry('axialLength',23.5924+conditionalSigmaLength*2);
rayTraceFuncsVeridical_2SDcase = assembleRayTraceFuncs( sceneGeometryVeridical_2SDcase );

%% Loop over aimuths and elevations to create pupil border points
% The range of values used here corresponds to the biological limits of the
% rotation of the eye horizontally and vertically.
for aziIdx = 1:nAzi
    for eleIdx = 1:nEle
        
        thisAzimuth = (aziIdx-1)*5;
        thisElevation = (eleIdx-1)*5;
        thisTorsion = 0;
        
        %% Assemble the eyePoses variable
        eyePoses(aziIdx, eleIdx, :)=[thisAzimuth,thisElevation,thisTorsion,pupilRadiusMM];
        
        %% Obtain boundary points for the 1 SD case
        % Forward projection from eyePoses to image ellipse
        pupilEllipseOnImagePlane = pupilProjection_fwd(eyePoses(aziIdx, eleIdx, :), sceneGeometryVeridical_1SDcase, rayTraceFuncsVeridical_1SDcase);
        % Obtain boundary points for this ellipse
        [ Xp_1SDcase(aziIdx, eleIdx, :), Yp_1SDcase(aziIdx, eleIdx, :) ] = ellipsePerimeterPoints( pupilEllipseOnImagePlane );

        %% Obtain boundary points for the 2 SD case
        % Forward projection from eyePoses to image ellipse
        pupilEllipseOnImagePlane = pupilProjection_fwd(eyePoses(aziIdx, eleIdx, :), sceneGeometryVeridical_2SDcase, rayTraceFuncsVeridical_2SDcase);
        % Obtain boundary points for this ellipse
        [ Xp_2SDcase(aziIdx, eleIdx, :), Yp_2SDcase(aziIdx, eleIdx, :) ] = ellipsePerimeterPoints( pupilEllipseOnImagePlane );

    end
end


%% Create the 1SD and 2SD error scenarios
sceneGeometryModeled_1Scase = createSceneGeometry();
sceneGeometryModeled_1Scase.extrinsicTranslationVector(3) = 120 + translationError1SD;
rayTraceFuncsModeled_1SDcase = assembleRayTraceFuncs( sceneGeometryModeled_1Scase );

sceneGeometryModeled_2Scase = createSceneGeometry();
sceneGeometryModeled_2Scase.extrinsicTranslationVector(3) = 120 + translationError2SD;
rayTraceFuncsModeled_2SDcase = assembleRayTraceFuncs( sceneGeometryModeled_2Scase );

% Loop through the eye poses and obtain the inverse solutions
for aziIdx = 1:nAzi
    for eleIdx = 1:nEle
        inverseEyePose_1SDcase(aziIdx,eleIdx,:) = eyePoseEllipseFit(squeeze(Xp_1SDcase(aziIdx,eleIdx,:)), squeeze(Yp_1SDcase(aziIdx,eleIdx,:)), sceneGeometryModeled_1Scase, rayTraceFuncsModeled_1SDcase,'eyePoseLB',[-50,-45,0,0.5],'eyePoseUB',[50,45,0,4]);
        inverseEyePose_2SDcase(aziIdx,eleIdx,:) = eyePoseEllipseFit(squeeze(Xp_2SDcase(aziIdx,eleIdx,:)), squeeze(Yp_2SDcase(aziIdx,eleIdx,:)), sceneGeometryModeled_2Scase, rayTraceFuncsModeled_1SDcase,'eyePoseLB',[-50,-45,0,0.5],'eyePoseUB',[50,45,0,4]);
    end
end

%% Reshape the eye poses into lists suitable for quivering
veridicalAziList = reshape(eyePoses(:,:,1),nAzi*nEle,1);
veridicalEleList = reshape(eyePoses(:,:,2),nAzi*nEle,1);
inverseAziList_1SDcase = reshape(inverseEyePose_1SDcase(:,:,1),nAzi*nEle,1)-veridicalAziList;
inverseEleList_1SDcase = reshape(inverseEyePose_1SDcase(:,:,2),nAzi*nEle,1)-veridicalEleList;
inverseAziList_2SDcase = reshape(inverseEyePose_2SDcase(:,:,1),nAzi*nEle,1)-veridicalAziList;
inverseEleList_2SDcase = reshape(inverseEyePose_2SDcase(:,:,2),nAzi*nEle,1)-veridicalEleList;

figure

%% Quiver
subplot(1,2,1)
h1=quiver(veridicalAziList,veridicalEleList,inverseAziList_2SDcase,inverseEleList_2SDcase,0,'LineWidth',2,'ShowArrowHead','off');
h1.Color=[1 0.5 0.5];
hold on
h2=quiver(veridicalAziList,veridicalEleList,inverseAziList_1SDcase,inverseEleList_1SDcase,0,'LineWidth',2,'ShowArrowHead','off');
h2.Color=[.75 0.75 0.75];
hold off
scale=.9;
hU1 = get(h1,'UData');
hV1 = get(h1,'VData');
set(h1,'UData',scale*hU1,'VData',scale*hV1)
hU2 = get(h2,'UData');
hV2 = get(h2,'VData');
set(h2,'UData',scale*hU2,'VData',scale*hV2)
hold on
plot(veridicalAziList,veridicalEleList,'.k');
xlim([-5 35]);
ylim([-5 35]);
axis square
titleString=sprintf('Max error 1D, 2D Azi = %4.2f, %4.2f; Ele = %4.2f, %4.2f',max(inverseAziList_1SDcase),max(inverseAziList_2SDcase),max(inverseEleList_1SDcase),max(inverseEleList_2SDcase));
title(titleString);

%% Circle
veridicalRadii = ones(nAzi*nEle,1)*pupilRadiusMM;
inverseRadii_1SDcase = reshape(inverseEyePose_1SDcase(:,:,4),nAzi*nEle,1)-veridicalRadii;
inverseRadii_2SDcase = reshape(inverseEyePose_2SDcase(:,:,4),nAzi*nEle,1)-veridicalRadii;
subplot(1,2,2)
viscircles([veridicalAziList veridicalEleList],inverseRadii_2SDcase*10,'Color',[1 0.5 0.5],'LineWidth',0.5);
hold on
viscircles([veridicalAziList veridicalEleList],inverseRadii_1SDcase*10,'Color',[.75 0.75 0.75],'LineWidth',0.5);
plot(veridicalAziList,veridicalEleList,'.k');
xlim([-5 35]);
ylim([-5 35]);
axis square;
titleString=sprintf('Error 1D, 2D Min = %4.2f, %4.2f; Max = %4.2f, %4.2f',min(inverseRadii_1SDcase),min(inverseRadii_2SDcase),max(inverseRadii_1SDcase),max(inverseRadii_2SDcase));
title(titleString);

%% Dump some numbers
fprintf('1SD case, median proportion error in [Azi, Ele, radius]: %4.2f, %4.2f, %4.2f \n',median(inverseAziList_1SDcase./veridicalAziList),median(inverseEleList_1SDcase./veridicalEleList),median(inverseRadii_1SDcase./veridicalRadii));
fprintf('2SD case, median proportion error in [Azi, Ele, radius]: %4.2f, %4.2f, %4.2f \n',median(inverseAziList_2SDcase./veridicalAziList),median(inverseEleList_2SDcase./veridicalEleList),median(inverseRadii_2SDcase./veridicalRadii));
