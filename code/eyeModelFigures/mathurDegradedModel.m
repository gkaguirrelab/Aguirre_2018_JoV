%% mathurDegradedModel
%
% We examined how the mathur measures change as a function of removing
% components of the model.

% The range for our plots
viewingAngleDeg = -70:1:70;

% The size of the exit pupil
pupilDiam = 6.19/1.13;

% The refractive error of the subject for the average Mathur data.
sphericalAmetropia = -0.8308;

nModels = 4;

clear diamRatios C
for modelLevel = 1:nModels
    switch modelLevel
        case 1
            sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
            sg.refraction = [];
            sg.eye.axes.alpha.degField = [0 0 0];
            sg.eye.pupil.eccenFcnString = '@(x) 0';
            sg.eye.pupil.thetas = [0 pi/2];
        case 2
            sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
            sg.eye.axes.alpha.degField = [0 0 0];
            sg.eye.pupil.eccenFcnString = '@(x) 0';
            sg.eye.pupil.thetas = [0 pi/2];
        case 3
            sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
            sg.eye.pupil.eccenFcnString = '@(x) 0';
            sg.eye.pupil.thetas = [0 pi/2];
        case 4
            sg = createSceneGeometry('sphericalAmetropia',sphericalAmetropia);
    end
    for vv = 1:length(viewingAngleDeg)        
        [diamRatios(modelLevel,vv), C(modelLevel,vv), pupilFitError(modelLevel,vv)] = returnPupilDiameterRatio_CameraMoves(viewingAngleDeg(vv),pupilDiam,sg);
    end
end

% This is Eq 9 from Mathur 2013, which specifies the horizontal to vertical
% ratio of the entrance pupil from different viewing angles relative to
% fixation
mathurEq9 = @(viewingAngleDeg) 0.99.*cosd((viewingAngleDeg+5.3)/1.121);

% This is Eq 11, which specifies the oblique component of pupil ellipticity
mathurEq11 = @(viewingAngleDeg) 0.00072.*viewingAngleDeg-0.0008;

% Plot the results.
figure

titleStrings = {'no model','add ray trace','add alpha','add non-circular exit pupil'};
for modelLevel = 1:nModels
    subplot(2,2,modelLevel);
    hold on
    plot(viewingAngleDeg,mathurEq9(viewingAngleDeg) ,'-','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,cosd(viewingAngleDeg),':','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,diamRatios(modelLevel,:),'-','Color',[1 0 0]);
    RMSE = sqrt(mean((diamRatios(modelLevel,:)-mathurEq9(viewingAngleDeg)).^2));
    text(0,0.6,sprintf('RMSE = %1.0e',RMSE),'HorizontalAlignment','Center');

    plot(viewingAngleDeg,mathurEq11(viewingAngleDeg),'-','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,viewingAngleDeg.*0,':','Color',[.5 .5 .5]);
    plot(viewingAngleDeg,C(modelLevel,:),'-','Color',[1 0 0]);
    RMSE = sqrt(mean((C(modelLevel,:)-mathurEq11(viewingAngleDeg)).^2));
    text(0,-0.1,sprintf('RMSE = %1.0e',RMSE),'HorizontalAlignment','Center');

    axis square
    xlim([-90 90]);
    ylim([-.2 1.1]);
    xlabel('Viewing angle [deg]')
    ylabel('Pupil Diameter Ratio - obliquity')
    title(titleStrings{modelLevel})
end


% Plot some images of the pupil at various extremes
    figure
    for azi = -60:30:60
            eyePose = [azi 0 0 1];
            renderEyePose(eyePose,sceneGeometry,'newFigure',false,'modelEyeLabelNames',{'pupilPerimeter'},'modelEyePlotColors',{'.g'});
    end
    