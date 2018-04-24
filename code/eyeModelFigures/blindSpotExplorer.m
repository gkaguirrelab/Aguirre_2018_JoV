%% blindSpotExplorer


% Find the azimuthal arc in retina deg that produces a blind spot position
% in the horizontal and vertical directions that is equal to specified
% values from the literature. Values taken from Safren 1993 for their dim
% stimulus, under the assumption that this will be most accurate given the
% minimization of light scatter. We model the fovea as being 3x closer to
% the optical axis than is the optic disc.
targetBlindSpotAngle = [16.02 1.84 0];
blindSpotAngle = @(eye) eye.axes.mu.degField - eye.axes.alpha.degField;
myObj = @(x) sum((blindSpotAngle(modelEyeParameters('opticDiscAngle',[3/4*x(1),x(2)/2,0],'foveaAngle',-[1/4*x(1),x(2)/2,0])) - targetBlindSpotAngle).^2);
options = optimoptions('fmincon','Display','off');
retinalArcDeg = fmincon(myObj,[20 4],[],[],[],[],[],[],[],options);
fprintf('Distance between the fovea and the center of the optic disc in retinal degrees: azimuth = %4.4f; elevation = %4.4f \n\n', retinalArcDeg([1 2]));

% Examine how the position of the blind spot in the visual field changes
% with ametropia.
opticDisc_WRT_opticalAxisDegRetina = opticDisc_WRT_foveaDegRegina+fovea_WRT_opticalAxisDegRetina;
blindSpotAngles = [];
for SR = -2:2
    eye = modelEyeParameters('sphericalAmetropia',SR);
    blindSpotAngles = [blindSpotAngles; eye.axes.alpha.degField - eye.axes.mu.degField];
end
linearCoefficients = polyfit((-2:2)', blindSpotAngles(:,1), 1);
fprintf('The relationship between refractive error and horizontal blind spot position is:\n');
fprintf('\tPosition [deg] = %4.3f + %4.3f * refractiveError(diopters)\n',linearCoefficients([2 1]));
linearCoefficients = polyfit((-2:2)', blindSpotAngles(:,2), 1);
fprintf('The relationship between refractive error and vertical blind spot position is:\n');
fprintf('\tPosition [deg] = %4.3f + %4.3f * refractiveError(diopters)\n\n',linearCoefficients([2 1]));


% Observe that the increase in the size of the posterior chamber with axial
% length, coupled with a constant separation of retinal degrees, produces a
% distance in mm that increases similar to the empirical results of Jonas
% 2015:
distances = [];
lengths = [];
for sr = -2:1:2
    eye = modelEyeParameters('sphericalAmetropia',sr);
    distances = [distances sqrt(sum(eye.axes.alpha.mmRetina - eye.axes.mu.mmRetina)^2)];
    lengths = [lengths eye.axialLength];
end
linearCoefficients = polyfit(lengths', distances', 1);
fprintf('The relationship between axial length and optic disc-fovea distance in our model is:\n');
fprintf('\tDistance [mm] = %4.3f + %4.3f * axialLength\n',linearCoefficients([2 1]));
fprintf('Compare to the Jonas 2015 fit to empirical data:\n');
fprintf('\tDistance [mm] = 0.04 + 0.21 * axialLength \n')

