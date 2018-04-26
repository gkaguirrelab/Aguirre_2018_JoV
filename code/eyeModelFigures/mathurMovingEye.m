%% mathurMovingEye
%
% We examined how the mathur result changes as a consequence of the camera
% remaining stationary and the eye rotating

% The range for our plots
rotationAngleDeg = -60:1:60;

% The size of the exit pupil
pupilDiam = 6.19/1.13;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.8308;


clear diamRatios C pupilFitError
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
for vv = 1:length(rotationAngleDeg)
    [diamRatios(vv), C(vv), pupilFitError(vv)] = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg(vv),pupilDiam,sg);
end


% Plot the results.
figure

hold on
plot(rotationAngleDeg,diamRatios,'-','Color',[1 0 0]);

plot(rotationAngleDeg,C,'-','Color',[1 0 0]);

axis square
xlim([-90 90]);
ylim([-.2 1.1]);
xlabel('Rotation angle [deg]')
ylabel('Pupil Diameter Ratio - obliquity')
