%% mathurDegradedModel
%
% We examined how the mathur measures change as a function of removing
% components of the model.

% The range for our plots
viewingAngleDeg = -70:1:65;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = (6*1.2-11*2.9)/30;

% The size of the entrance pupil The eye was dilated with 1% Cyclopentolate
% which in adults produces an entrance pupil of ~6 mm:
%
%   Kyei, Samuel, et al. "Onset and duration of cycloplegic action of 1%
%   Cyclopentolate-1% Tropicamide combination." African health sciences
%   17.3 (2017): 923-932.
%
%
entrancePupilDiam = 6;
%{
    entranceRadius = 6/2;
    % Prepare scene geometry and eye pose aligned with visual axis
    sceneGeometry = createSceneGeometry();
    % Obtain the pupil area in the image for the entrance radius
    % assuming no ray tracing
    sceneGeometry.refraction = [];
    pupilImage = pupilProjection_fwd([0, 0, 0, entranceRadius],sceneGeometry);
    stopArea = pupilImage(3);
    % Add the ray tracing function to the sceneGeometry
    sceneGeometry = createSceneGeometry();
    % Search across stop radii to find the value that matches the observed
    % entrance area.
    myPupilEllipse = @(radius) pupilProjection_fwd([0, 0, 0, radius],sceneGeometry);
    myArea = @(ellipseParams) ellipseParams(3);
    myObj = @(radius) (myArea(myPupilEllipse(radius))-stopArea(1)).^2;
    stopRadius = fminunc(myObj, entranceRadius)
%}
stopDiam = 2.6484*2;


% Subjects in the Mathur study fixated a point 3 meters away
fixationTargetDistance = 3000;
accomodationDiopters = 1000/3000;

%{
    % Probe the forward model at the estimated pose angles to
    % estimate the pupil radius.
    sceneGeometry = createSceneGeometry();
    sceneGeometry.cameraPosition.translation = [0; 0; 100];
    eyePose = [-sceneGeometry.eye.landmarks.fovea.degField 2];
    probeEllipse=pupilProjection_fwd(eyePose, sceneGeometry);
    pixelsPerMM = sqrt(probeEllipse(3)/pi)/2;
%}
pixelsPerMM = 28.5769;



nModels = 5;

sceneGeometry = createSceneGeometry(...
    'sphericalAmetropia',sphericalAmetropia,...
    'accommodationDiopeters',accomodationDiopters,...
    'spectralDomain','vis',...
    'calcLandmarkFovea',true);

[~,~,fixationEyePose]=calcLineOfSightRay(sceneGeometry,stopDiam/2,fixationTargetDistance);

clear diamRatios C
for modelLevel = 5:nModels
    sg = sceneGeometry;
    fa = fixationEyePose(1:2);
    switch modelLevel
        case 1
            sg.refraction = [];
            fa = [0 0];
            sg.eye.stop.eccenFcnString = '@(x) 0';
        case 2
            % Remove the refractive effects of the anterior segment by
            % setting all refractive indicies (including the camera medium)
            % to the aqueous
            sg.refraction = [];
            sg.eye.stop.eccenFcnString = '@(x) 0';
        case 3
            % Cornea only. This is Fedtke with our cornea model.
            fa = [0 0];
            sg.eye.stop.eccenFcnString = '@(x) 0';
        case 4
            sg.eye.stop.eccenFcnString = '@(x) 0';
        case 5
            % No changes. Full model.
    end
    for vv = 1:length(viewingAngleDeg)
        [diamRatios(modelLevel,vv), C(modelLevel,vv), pupilFitError(modelLevel,vv), thetas(modelLevel,vv), horizPixels(modelLevel,vv), vertPixels(modelLevel,vv) ] = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),fa,stopDiam,sg);
    end
end


% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
mathurEq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

% This is Eq 9 from Mathur 2013, which specifies the horizontal to vertical
% ratio of the entrance pupil from different viewing angles relative to
% fixation
mathurEq9 = @(viewingAngleDeg) 0.99.*cosd((viewingAngleDeg+5.3)/1.121);

% This is Eq 11, which specifies the oblique component of pupil ellipticity
mathurEq11 = @(viewingAngleDeg) 0.00072.*viewingAngleDeg-0.0008;

% Fedtke 2013 model Figure 9, 6mm pupil, viewing angle x pupil diam ratio
fedtkeFig9Data = [   78.0328   70.3279   57.7049   51.6393   44.4262   35.2459   28.0328   11.9672    1.8033; ...
    0.4057    0.5009    0.6447    0.7082    0.7779    0.8541    0.9048    0.9789    0.9979];

% Mathur 2013 Equation 7, Fedtke restricted.
mathurEq7Fedtke = fittype( @(E,x) 1.0.*cosd((x-0)./E), 'independent','x','dependent','y');

fedtkeFit = fit (fedtkeFig9Data(1,:)',fedtkeFig9Data(2,:)',mathurEq7Fedtke,'StartPoint',[1.12]);

% Confirm here that the fedtkeFit reproduces the Fedtke model from figure 9
% of Fedtke 2013.
%{
    figure
    plot(fedtkeFig9Data(1,:),fedtkeFig9Data(2,:),'*k');
    hold on
    plot(fedtkeFig9Data(1,:),fedtkeFit(fedtkeFig9Data(1,:)),'-r');
%}

% Plot the results.
figHandle1 = figure();

titleStrings = {'no model','add alpha','cornea only','add ray trace','add non-circular pupil aperture'};
for modelLevel = 1:nModels
    subplot(3,2,modelLevel);
    hold on
    plot(viewingAngleDeg,mathurEq9(viewingAngleDeg) ,'-','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,cosd(viewingAngleDeg),':','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,diamRatios(modelLevel,:),'-','Color',[1 0 0]);
    plot(viewingAngleDeg,fedtkeFit(viewingAngleDeg),'-g');
    RMSE = sqrt(mean((diamRatios(modelLevel,:)-mathurEq9(viewingAngleDeg)).^2));
    text(0,0.6,sprintf('RMSE = %1.0e',RMSE),'HorizontalAlignment','Center');
    
    plot(viewingAngleDeg,mathurEq11(viewingAngleDeg),'-','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,viewingAngleDeg.*0,':','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,C(modelLevel,:),'-','Color',[1 0 0]);
    RMSE = sqrt(mean((C(modelLevel,:)-mathurEq11(viewingAngleDeg)).^2));
    text(0,-0.1,sprintf('RMSE = %1.0e',RMSE),'HorizontalAlignment','Center');
    
    pbaspect([1 1.5 1])
    xlim([-90 90]);
    ylim([-.2 1.1]);
    xlabel('Viewing angle [deg]')
    ylabel('Pupil Diameter Ratio / obliquity')
    title(titleStrings{modelLevel})
end

figHandle2 = figure();
plot(viewingAngleDeg,pupilFitError(nModels,:)./pixelsPerMM,'-','Color',[1 0 0]);
axis square
xlim([-90 90]);
ylim([0 0.05]);
xlabel('Viewing angle [deg]')
ylabel('Elliptical fit error')
title(titleStrings{modelLevel})

%% Report the parameters of Mathur Eq 7 fit to the model diam ratios
for modelLevel = 1:nModels
    f = fit (viewingAngleDeg',diamRatios(modelLevel,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
end
