%% turningPointByAmetropia
%
% Mathur 2013 Figure 8 reports the peak angle (beta) as a function of
% spherical ametropia of the studied subject. They found an inverse
% relationship, with a negative spherical error of -5 diopters associated
% with a -3 degree peak angle, and a positive sperical error of 2 diopters
% associated with a peak angle of 7 degrees, and therefore a slope of -0.61
% degrees per diopter.
%
% We simulated eyes with spherical ametropia ranging from -5 to 2 diopeters
% and measured the peak angle.


viewingAngleDeg = -60:10:60;
pupilDiam = 6;

eq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

betas = [];

for ametropia = -5:1:2
    
    sceneGeometry = createSceneGeometry('sphericalAmetropia',ametropia);
    
    for vv = 1:length(viewingAngleDeg)
        [diamRatio(vv), theta(vv), pupilFitError(vv)] = returnPupilDiameterRatio(viewingAngleDeg(vv),pupilDiam,sceneGeometry);
    end
    
    f = fit (viewingAngleDeg',diamRatio',eq7,'StartPoint',[5.3,0.93,1.12]);
    betas = [betas f.beta];
    
end

plot(-5:1:2,betas,'xk')
