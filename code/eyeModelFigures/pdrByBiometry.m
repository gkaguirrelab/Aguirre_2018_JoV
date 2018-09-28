% Variation in PDR function width with biometric variation


% The range for our plots
viewingAngleDeg = -70:1:65;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = (6*1.2-11*2.9)/30;

sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
sgNoRayTrace = sg;
sgNoRayTrace.refraction = [];

% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
mathurEq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

figHandle1 = figure();

clear diamRatios E
for ii = 1:7
    entranceRadius = ii/2;
    % Obtain the pupil area in the image for the entrance radius
    % assuming no ray tracing
    pupilImage = pupilProjection_fwd([0, 0, 0, entranceRadius],sgNoRayTrace);
    actualArea = pupilImage(3);
    % Search across actual pupil radii to find the value that matches
    % the observed entrance area.
    myPupilEllipse = @(radius) pupilProjection_fwd([0, 0, 0, radius],sg);
    myArea = @(ellipseParams) ellipseParams(3);
    myObj = @(radius) (myArea(myPupilEllipse(radius))-actualArea(1)).^2;
    actualRadius(ii) = fminunc(myObj, entranceRadius);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(ii,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),actualRadius(ii)*2,sg);
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
ylim([0.9 1.2]);


%% Vary pupil depth
clear diamRatios E
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
pupilDepths = -4:0.2:-2.8;
for ii = 1:length(pupilDepths)
    sg.eye.pupil.center(1)=pupilDepths(ii);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(ii,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),2.6453*2,sg);
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
ylim([0.9 1.2]);


%% Vary eye Torsion
clear diamRatios E
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
eyeTorsion = 0:15:90;
for ii = 1:length(eyeTorsion)
    for vv = 1:length(viewingAngleDeg)
        diamRatios(ii,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),2.6453*2,sg,eyeTorsion(ii));
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(ii,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(ii)=eq7Fit.E;
end
subplot(3,1,3)
plot(eyeTorsion,E,'ok')
hold on
cs = spline(eyeTorsion,E);
plot(eyeTorsion,ppval(cs,eyeTorsion),'-r')
xlabel('Eye torsion [deg]')
ylabel('E')
xlim([-5 95]);
ylim([0.9 1.2]);


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

