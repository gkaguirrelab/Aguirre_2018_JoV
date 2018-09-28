%% modelEyeFigure



figure
subplot(2,1,1)
eye = modelEyeParameters('sphericalAmetropia',0);
plotModelEyeSchematic(eye,'view','axial','newFigure',false,'plotColor','k')
eye = modelEyeParameters('sphericalAmetropia',-10);
plotModelEyeSchematic(eye,'view','axial','newFigure',false,'plotColor','r')
subplot(2,1,2)
eye = modelEyeParameters('sphericalAmetropia',0);
plotModelEyeSchematic(eye,'view','sagittal','newFigure',false,'plotColor','k')
eye = modelEyeParameters('sphericalAmetropia',-10);
plotModelEyeSchematic(eye,'view','sagittal','newFigure',false,'plotColor','r')
