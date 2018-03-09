%% modelEyeFigure

clear all

figure
subplot(1,2,1)
modelEyeAxialSchematic
title(['axial view; sphere: ' num2str(sphericalAmetropia) '; length: ' num2str(eye.axialLength)]);

subplot(1,2,2)
axialLength = 26;
sphericalAmetropia = -5;
modelEyeAxialSchematic
title(['axial view; sphere: ' num2str(sphericalAmetropia) '; length: ' num2str(eye.axialLength)]);
