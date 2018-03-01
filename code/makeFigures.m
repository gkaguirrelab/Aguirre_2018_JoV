%% Create figures for Aguirre & Frazzetta 2018
%
%

% Define an output path for figures
outDir = '/Users/aguirre/Dropbox (Aguirre-Brainard Lab)/_Papers/Aguirre_2018_transparentTrack/Figures/raw/';


% Figure 1 -- The transparent ellipse params
% DEMO_transparentEllipseParams
% figureName = 'Figure x - ellipse params.pdf';
% saveas(gcf,fullfile(outDir,figureName));
% close gcf

% Figure X -- Ray tracing through the cornea
sceneGeometry = createSceneGeometry();

% Minimize clutter in the figure
clear figureFlag
figureFlag.legend = false;
figureFlag.imageLines = false;
figureFlag.textLabels = false;
outputRay = rayTraceCenteredSphericalSurfaces([sceneGeometry.eye.pupilCenter(1) 2], deg2rad(46), sceneGeometry.opticalSystem, figureFlag);

% Adjust the the figure flag so that we re-plot on the initial figure
figureFlag.surfaces = false;
figureFlag.imageLines = false;
figureFlag.refLine = false;
figureFlag.rayLines = true;
figureFlag.finalUnitRay = true;
figureFlag.textLabels = false;
figureFlag.legend = false;
figureFlag.new = false;
for deg = 31:-15:-44
    outputRay = rayTraceCenteredSphericalSurfaces([sceneGeometry.eye.pupilCenter(1) 2], deg2rad(deg), sceneGeometry.opticalSystem, figureFlag);
    drawnow
end

% save the figure
figureName = 'Figure x - CorneaRayTrace.pdf';
saveas(gcf,fullfile(outDir,figureName));
close gcf
