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
plot(axialLengths, pLBs);
plot(axialLengths, pUBs);
xlim([20 27]);
ylim([80 180]);
xlabel('Veridical eye axial length [mm]');
ylabel('Estimated camera depth [mm]');

subplot(2,1,2);
semilogy(axialLengths,medianFvals,'.-')
xlim([20 27]);
ylim([8e-5 9e-5]);
xlabel('Veridical eye axial length [mm]');
ylabel('median fVal [RMSE]');
