%% Create figures for Aguirre 2018 - model of the entrance pupil


%% modelEyeFigure
modelEyeFigure
saveThatSucker('modelEyeFigure.pdf');

%% Ray tracing through the cornea
corneaRayTrace
saveThatSucker('corneaRayTrace.pdf');

%% mathurDegradedModel
plotEllipseFitError=false;
mathurDegradedModel
saveThatSucker('mathurDegradedModel.pdf');

%% mathurDegradedModel ellipse fit error
plotEllipseFitError=true;
mathurDegradedModel
saveThatSucker('ellipseFitError.pdf');

%% turningPointByAmetropia
turningPointByAmetropia
saveThatSucker('turningPointByAmetropia.pdf');

%% alphaByAmetropia
alphaByAmetropia
saveThatSucker('alphaByAmetropia.pdf');

%% mathurMovingEye
mathurMovingEye
saveThatSucker('mathurMovingEye.pdf');
