% Variation in PDR function width with pupil diameter


% The range for our plots
viewingAngleDeg = -65:1:55;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.7;

sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
sgNoRayTrace = sg;
sgNoRayTrace.refraction = [];

% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
mathurEq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

figure

clear diamRatios E
for entrancePupilDiameter = 1:7
    entranceRadius = entrancePupilDiameter/2;
    % Obtain the pupil area in the image for the entrance radius
    % assuming no ray tracing
    pupilImage = pupilProjection_fwd([0, 0, 0, entranceRadius],sgNoRayTrace);
    actualArea = pupilImage(3);
    % Search across actual pupil radii to find the value that matches
    % the observed entrance area.
    myPupilEllipse = @(radius) pupilProjection_fwd([0, 0, 0, radius],sg);
    myArea = @(ellipseParams) ellipseParams(3);
    myObj = @(radius) (myArea(myPupilEllipse(radius))-actualArea(1)).^2;
    actualRadius(entrancePupilDiameter) = fminunc(myObj, entranceRadius);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(entrancePupilDiameter,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),actualRadius(entrancePupilDiameter)*2,sg);
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(entrancePupilDiameter,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(entrancePupilDiameter)=eq7Fit.E;
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
for pd = 1:length(pupilDepths)
    sg.eye.pupil.center(1)=pupilDepths(pd);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(entrancePupilDiameter,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),2.6453*2,sg);
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(entrancePupilDiameter,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(pd)=eq7Fit.E;
end
subplot(3,1,2)
plot(pupilDepths,E,'ok')
hold on
cs = spline(pupilDepths,E);
plot(pupilDepths,ppval(cs,pupilDepths),'-r')
xlabel('Pupil depths [mm]')
ylabel('E')
xlim([-4.2 -2.6]);
ylim([0.9 1.2]);


%% Vary iris thickness depth
clear diamRatios E
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
irisThickness = 0:0.05:.3;
for it = 1:length(irisThickness)
    sg.eye.iris.thickness=irisThickness(it);
    for vv = 1:length(viewingAngleDeg)
        diamRatios(entrancePupilDiameter,vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),2.6453*2,sg);
    end
    eq7Fit = fit (viewingAngleDeg',diamRatios(entrancePupilDiameter,:)',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(it)=eq7Fit.E;
end
subplot(3,1,3)
plot(irisThickness,E,'ok')
hold on
cs = spline(irisThickness,E);
plot(irisThickness,ppval(cs,irisThickness),'-r')
xlabel('Iris thickness [mm]')
ylabel('E')
xlim([-0.05 0.35]);
ylim([0.9 1.2]);




%% Compare the PDR fits for vertical and horizontal eye rotation, and with turning off the corneal rotation
% sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
% clear diamRatios E
% for vv = 1:length(viewingAngleDeg)
%     diamRatios(vv) = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),2.6453*2,sg);
% end
% eq7Fit = fit (viewingAngleDeg',diamRatios',mathurEq7,'StartPoint',[5.3,0.93,1.12])

%% I manually hacked the code to examine the following values:
% Horizontal viewing angle: [beta, D, E] = -5.293, 0.9842, 1.137
% Vertical viewing angle: [beta, D, E] = -2.172, 0.9938. 1.185
% Horizontal viewing angle, no corneal rotation = -5.292, 0.9842, 1.137
