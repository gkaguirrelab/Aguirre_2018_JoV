%% mathurMovingEye
%
% We examined how the mathur result changes as a consequence of the camera
% remaining stationary and the eye rotating

% The range for our plots
rotationAngleDeg = -65:1:55;

% The size of the exit pupil
actualPupilDiam = 2.6453*2;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.7;


clear diamRatios
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
nModels = 2;

for modelLevel = 1:nModels
    for vv = 1:length(rotationAngleDeg)
        switch modelLevel
            case 1
                diamRatios(modelLevel,vv) = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg(vv),actualPupilDiam,sg);
            case 2
                diamRatios(modelLevel,vv) = returnPupilDiameterRatio_CameraMoves(rotationAngleDeg(vv),actualPupilDiam,sg);
        end
    end
end

% Plot the results.
figure

titleStrings = {'eye moves','camera moves'};
for modelLevel = 1:nModels
    subplot(3,2,modelLevel);
    hold on
    plot(rotationAngleDeg,diamRatios(modelLevel,:),'-','Color',[1 0 0]);
    
    xlim([-90 90]);
    ylim([-.2 1.1]);
    xlabel('Rotation angle [deg]')
    ylabel('Pupil Diameter Ratio')
    title(titleStrings{modelLevel})
    pbaspect([1 1.5 1])
end


% Obtain the E value for eyes of different refractive errors

% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
mathurEq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

clear diamRatios E
SRvals = -10:3:5;
for sr = 1:length(SRvals)
    sg = createSceneGeometry('sphericalAmetropia',SRvals(sr));
    for vv = 1:length(rotationAngleDeg)
        diamRatios(vv) = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg(vv),actualPupilDiam,sg);
    end
    eq7Fit = fit (rotationAngleDeg',diamRatios',mathurEq7,'StartPoint',[5.3,0.93,1.12]);
    E(sr)=eq7Fit.E;
end

figure
plot(SRvals,E,'ok')
hold on
cs = spline(SRvals,E);
plot(SRvals,ppval(cs,SRvals),'-r')
xlabel('SR [diopters]')
ylabel('E')
xlim([-11 6]);
ylim([0.9 1.2]);

