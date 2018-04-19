%% mathurDegradedModel
%
% We examined how the mathur measures change as a function of removing
% components of the model.


viewingAngleDeg = -60:1:60;
pupilDiam = 6.19/1.13;

sceneGeometry = createSceneGeometry('axialLength',25.1340);
for vv = 1:length(viewingAngleDeg)

    % Full model
    [diamRatios(vv), thetas(vv)] = returnPupilDiameterRatio(viewingAngleDeg(vv),pupilDiam,sceneGeometry);

    % No ray tracing
    sg = sceneGeometry;
    sg.refraction = [];
    [diamRatios_noRayTrace(vv), thetas_noRayTrace(vv)] = returnPupilDiameterRatio(viewingAngleDeg(vv),pupilDiam,sg);
end
 
% Reverse the thetas to match the Mathur convention, in which a theta of
% zero corresponds to a pupil ellipse with the major axis aligned with the
% horizontal meridian, and positive values of theta are in the
% counter-clockwise direction.
thetas = pi - thetas;

% Calculate the Mathur value C from Equation 6
C = (1-diamRatios).*sin(2.*(thetas-pi/2));

% Plot Figure 10 of Mathur 2013 with our model output.
figure
subplot(1,2,1);
plot(viewingAngleDeg,diamRatios ,'-k');
xlim([-90 90]);
ylim([0 1.1]);
xlabel('Viewing angle [deg]')
ylabel('Pupil Diameter Ratio')
title('Mathur 2013 Figure 6, component A')

subplot(1,2,2)
plot(viewingAngleDeg,C ,'-k');
hold on
xlim([-90 90]);
ylim([-.2 .2]);
xlabel('Viewing angle [deg]')
ylabel('Oblique component of the pupil ellipticity')
title('Mathur 2013 Figure 6, component C')