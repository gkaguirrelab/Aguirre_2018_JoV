%% mathurMovingEye
%
% We examined how the mathur result changes as a consequence of the camera
% remaining stationary and the eye rotating

% The range for our plots
rotationAngleDeg = -55:1:65;

% The size of the exit pupil
actualPupilDiam = 2.6453*2;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.7;


clear diamRatios C pupilFitError
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
for vv = 1:length(rotationAngleDeg)
    [diamRatios(vv), C(vv), pupilFitError(vv)] = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg(vv),actualPupilDiam,sg);
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
