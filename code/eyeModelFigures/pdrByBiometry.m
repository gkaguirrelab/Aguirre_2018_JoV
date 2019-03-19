% Variation in PDR function width with biometric variation


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


sg = createSceneGeometry(...
    'sphericalAmetropia',sphericalAmetropia,...
    'accommodationDiopeters',accomodationDiopters,...
    'spectralDomain','vis',...
    'calcLandmarkFovea',true);
[~,~,fixationEyePose]=calcLineOfSightRay(sg,stopDiam/2,fixationTargetDistance);

fa = fixationEyePose(1:2);

sgNoRayTrace = sg;
sgNoRayTrace.refraction = [];

% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
mathurEq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

figHandle1 = figure();

clear diamRatios E
for ii = 1:7
    pupilRadius = ii/2;
    % Obtain the pupil area in the image for this radius assuming no
    % refraction
    pupilImage = pupilProjection_fwd([0, 0, 0, pupilRadius],sgNoRayTrace);
    pupilArea = pupilImage(3);
    % Search across stop radii to find the value that matches
    % the observed entrance area.
    myPupilEllipse = @(radius) pupilProjection_fwd([0, 0, 0, radius],sg);
    myArea = @(ellipseParams) ellipseParams(3);
    myObj = @(radius) (myArea(myPupilEllipse(radius))-pupilArea(1)).^2;
    stopRadius(ii) = fminunc(myObj, pupilRadius);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(ii,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),fa,stopRadius(ii)*2,sg);
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(ii,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(ii)=eq7Fit.E;
end

% Plot the results.
subplot(3,1,1)
plot(1:7,E,'ok')
hold on
cs = spline(1:7,E);
plot(1:0.1:7,ppval(cs,1:0.1:7),'-r')
xlabel('Entrance pupil diameter [mm]')
ylabel('E')
xlim([0 8]);
ylim([1.1 1.2]);


%% Vary pupil depth
clear diamRatios E
pupilDepths = -4:0.2:-2.8;
sgAdj = sg;
for ii = 1:length(pupilDepths)
    sgAdj.eye.pupil.center(1)=pupilDepths(ii);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(ii,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),fa,stopDiam,sgAdj);
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(ii,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(ii)=eq7Fit.E;
end
subplot(3,1,2)
plot(pupilDepths,E,'ok')
hold on
cs = spline(pupilDepths,E);
plot(pupilDepths,ppval(cs,pupilDepths),'-r')
xlabel('Pupil depth [mm]')
ylabel('E')
xlim([-4.2 -2.6]);
ylim([1.1 1.2]);


%% Vary corneal curvature

RoC = @(D) 1000.*(1.3375-1)./D;
radius = @(cc) sqrt(14.26.*RoC(cc));

clear diamRatios E
cornealRadius = 9:0.5:12;
for ii = 1:length(cornealRadius)
    myObj = @(x) (cornealRadius(ii) - radius(x)).^2;
    corneaDiopters(ii) = fminsearch(myObj,40);
    
    sgTemp = createSceneGeometry(...
        'sphericalAmetropia',sphericalAmetropia,...
        'accommodationDiopeters',accomodationDiopters,...
        'spectralDomain','vis',...
        'measuredCornealCurvature',[corneaDiopters(ii),corneaDiopters(ii)]);
    sgTemp.eye.landmarks = sg.eye.landmarks;
    for vv = 1:length(viewingAngleDeg)
        diamRatios(ii,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),fa,stopDiam,sgTemp);
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(ii,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(ii)=eq7Fit.E;
end
subplot(3,1,3)
plot(cornealRadius,E,'ok')
hold on
cs = spline(cornealRadius,E);
plot(cornealRadius,ppval(cs,cornealRadius),'-r')
xlabel('Corneal radius [deg]')
ylabel('E')
xlim([8.5 12.5]);
ylim([1.1 1.2]);





% Plot a few PDRs with different E values
figHandle2 = figure();
mathurEq7Plot = @(beta,D,E,x) D.*cosd((x-beta)./E);

clear E
for E = 0.9:.1:1.2
    plot(viewingAngleDeg,mathurEq7Plot(-5.293, 0.9842, E, viewingAngleDeg));
    hold on
end
pbaspect([1 1.5 1])
xlim([-90 90]);
ylim([-.2 1.1]);
xlabel('Viewing angle [deg]')
ylabel('Pupil Diameter Ratio / obliquity')

