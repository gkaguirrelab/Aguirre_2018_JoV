%% modelEyeFigure



figure
subplot(2,1,1)
eye = modelEyeParameters('sphericalAmetropia',-0.823);
plotModelEyeSchematic(eye,'view','axial','newFigure',false,'plotColor','k')
subplot(2,1,2)
eye = modelEyeParameters('sphericalAmetropia',-0.823);
plotModelEyeSchematic(eye,'view','sagittal','newFigure',false,'plotColor','k')
