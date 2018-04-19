%% translationVsAxialLength

axialLengths = [21.72, 22.65, 23.59, 24.53, 25.47];
resultFileStem = '~/Dropbox (Aguirre-Brainard Lab)/Apps/CfNUploader/TEST_estimateCameraTranslation/TEST_estimateCameraTranslation/sceneGeometry_result_axialLength=';

figure
subplot(2,1,1);

for ii = 1:length(axialLengths)
    resultFile = [resultFileStem,num2str(axialLengths(ii)),'.mat'];
    load(resultFile)
    y(ii) = result.extrinsicTranslationVector(3);
    err(ii) = result.meta.estimateCameraTranslation.search.transVecSDNoRayTrace(3);
    medianFvals(ii) = median(result.meta.estimateCameraTranslation.search.allFvalsNoRayTrace);
    minFvals(ii) = min(result.meta.estimateCameraTranslation.search.allFvalsNoRayTrace);
    pLBs(ii) = result.meta.estimateCameraTranslation.translationLBp(3);
    pUBs(ii) = result.meta.estimateCameraTranslation.translationUBp(3);
end
errorbar(axialLengths,y,err,'.')
hold on
% Add a linear fit and R2
[f, gof] = fit(axialLengths',y','poly1');
plot(axialLengths,f(axialLengths),'-r')

xlim([20 27]);
ylim([pLBs(1) pUBs(1)]);
xlabel('Veridical eye axial length [mm]');
ylabel('Estimated camera depth [mm]');
title(['Axial eye length error vs. camera depth. R2 = '  num2str(gof.rsquare)]);

subplot(2,1,2);
plot(axialLengths,minFvals,'.-');
xlim([20 27]);
ylim([1e-5 1e-4]);
xlabel('Veridical eye axial length [mm]');
ylabel('min fVal [RMSE]');
