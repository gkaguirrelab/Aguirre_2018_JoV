%% alphaByAxialLength
%
% Tabernero 2007 observed that the angle kappa (pupil axis to visual axis)
% changes systematically with axial length. Their Figure 14 shows data from
% 18 subjects. They fit their data with a model in which the visual angle
% of the eye changes with axial length as a consequence of the fovea
% keeping a fixed distance from the intersection point of the optical axis
% despite the lengthening of the eye. I digitized their data from Figure
% 13b, and plot in cyan the fit of their model.
%
% In black is the fit of our model, which adopts similar underlying
% assumptions, but measures the degree to which the eye would need to
% rotate to bring the visual axis parallel to the original optical axis of
% the eye. The current model provides a better fit to the data.
figure

taberneroData = [   22.4046    8.8219
   22.6534    8.4110
   22.2886    7.5342
   22.2222    6.7123
   23.7313    7.1233
   24.6766    6.5205
   25.2736    6.1096
   24.4444    6.0274
   22.4378    5.6438
   22.2554    4.7945
   23.0680    4.1644
   23.0348    4.0274
   23.7479    3.9452
   24.5937    3.7260
   24.7761    4.8219
   25.4726    4.2192
   25.7877    3.7260
   27.8773    2.0274]';

alphaAzi=[];
alphaEle=[];
axialLengths = 20:1:30;

for aa = 1:length(axialLengths)
    eye = modelEyeParameters('axialLength',axialLengths(aa));
    alphaAzi=[alphaAzi eye.alpha(1)];
    alphaEle=[alphaEle eye.alpha(2)];
end

plot(taberneroData(1,:),taberneroData(2,:),'ob','MarkerSize', 14);
hold on
% Plot our model fit
plot(axialLengths,alphaAzi,'-k');

% Plot tabernero model fit
taberneroEq6 = @(x) atand( (16.5./(16.5+x-24)).*tand(5));
plot(axialLengths,taberneroEq6(axialLengths),'-.b')

% Add a marker to indicate the axial length of our emmetropic eye
eye = modelEyeParameters();
plot(eye.axialLength,0,'^r');
xlabel('axial length [mm]')
ylabel('azimuthal alpha [deg]')
title('azimuthal alpha as a function of axial length');

ylim([0 10]);
xlim([21 29]);
