%% Create figures for Aguirre 2018 - model of the entrance pupil


%% modelEyeFigure
modelEyeFigure
saveThatSucker(get(groot,'CurrentFigure'),'modelEyeFigure.pdf');

%% modelEyeFigure3D
modelEyeFigure3D
saveThatSucker(get(groot,'CurrentFigure'),'modelEyeFigure3D.png');

%% Ray tracing through the cornea
corneaRayTrace
saveThatSucker(get(groot,'CurrentFigure'),'corneaRayTrace.pdf');

%% mathurDegradedModel
mathurDegradedModel
saveThatSucker(figHandle1,'mathurDegradedModel.pdf');
saveThatSucker(figHandle2,'ellipseFitError.pdf');

%% turningPointByAmetropia
turningPointByAmetropia
saveThatSucker(figHandle1,'turningPointByAmetropia_A.pdf');
saveThatSucker(figHandle2,'turningPointByAmetropia_B.pdf');

%% pupilSizePDR






