%% Create figures for Aguirre & Frazzetta 2018
%
%


if false
    
    %% Ray tracing through the cornea
    corneaRayTrace
    saveThatSucker('corneaRayTrace.pdf');
    
    %% Ellipse sets for different scene geometries
    sceneGeomErrorInEllipseFitting
    saveThatSucker('sceneGeomErrorInEllipseFitting.pdf');
    
    %% Errors in estimation of verdical camera translation
    estimateSceneGeomVeridicalSim
    saveThatSucker('estimateSceneGeomVeridicalSim.pdf');
    
    %% Simulate Mathur 2013 results
    TEST_entrancePupilShape
    saveThatSucker('mathur2013simulation.pdf');
    
end

%% Replot Helsinki study data (Olsen 2007)
% see TEST_estimateCameraTranslation for details
olsen2007histogram
saveThatSucker('olsen2007histogram.pdf');

%% Estimate camera translation with axial length errors
translationVsAxialLength
saveThatSucker('translationVsAxialLength.pdf');

%% Eye pose quantification error
eyeposeQuantificationError
saveThatSucker('eyeposeQuantificationError.pdf');



%% Local function for saving figures
function saveThatSucker(figureName)
%% Define an output path for figures
outDir = '/Users/aguirre/Dropbox (Aguirre-Brainard Lab)/_Papers/Aguirre_2018_transparentTrack/Figures/raw/';
saveas(gcf,fullfile(outDir,figureName));
close gcf
end

