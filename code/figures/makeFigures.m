%% Create figures for Aguirre & Frazzetta 2018


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

%% modelEyeFigure
modelEyeFigure
saveThatSucker('modelEyeFigure.pdf');




