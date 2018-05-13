%% mathurMovingEye
%
% We examined how the mathur result changes as a consequence of the camera
% remaining stationary and the eye rotating

% The range for our plots
rotationAngleDeg = -65:1:55;

% The size of the exit pupil
actualPupilDiam = 2.6453*2;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.7;


clear diamRatios
sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
nModels = 2;

for modelLevel = 1:nModels
    for vv = 1:length(rotationAngleDeg)
        switch modelLevel
            case 1
                diamRatios(modelLevel,vv) = returnPupilDiameterRatio_EyeMoves(rotationAngleDeg(vv),actualPupilDiam,sg);
            case 2
                diamRatios(modelLevel,vv) = returnPupilDiameterRatio_CameraMoves(rotationAngleDeg(vv),actualPupilDiam,sg);
        end
    end
end

% Plot the results.
figure

titleStrings = {'eye moves','camera moves'};
for modelLevel = 1:nModels
    subplot(3,2,modelLevel);
    hold on
    plot(rotationAngleDeg,diamRatios(modelLevel,:),'-','Color',[1 0 0]);
    
    xlim([-90 90]);
    ylim([-.2 1.1]);
    xlabel('Rotation angle [deg]')
    ylabel('Pupil Diameter Ratio')
    title(titleStrings{modelLevel})
    pbaspect([1 1.5 1])
end
