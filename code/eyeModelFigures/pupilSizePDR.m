% Variation in PDR function width with pupil diameter


% The range for our plots
viewingAngleDeg = -65:1:55;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.7;


clear diamRatios
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'spectralDomain','vis');
sgNoRayTrace = sg;
sgNoRayTrace.refraction = [];

% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
mathurEq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');


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
figure
hold on
for entrancePupilDiameter = 1:2:7
    plot(viewingAngleDeg,diamRatios(entrancePupilDiameter,:),'-','Color',[1./(7/entrancePupilDiameter) 0 0]);
    pbaspect([1 1.5 1])
end
xlim([-90 90]);
ylim([-.2 1.1]);
xlabel('Viewing angle [deg]')
ylabel('Pupil Diameter Ratio')

figure
plot(1:7,E,'ok')
hold on
cs = spline(1:7,E);
plot(0.5:0.1:8,ppval(cs,0.5:0.1:8),'-r')
xlabel('Entrance pupil diameter [mm]')
ylabel('E')
xlim([0 10]);
ylim([0.9 1.2]);
