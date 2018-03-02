%% translationVsAxialLength

axialLengths = [21.72, 22.65, 23.59, 24.53 25.47];
resultFileStem = '~/Dropbox (Aguirre-Brainard Lab)/Apps/CfNUploader/TEST_estimateCameraTranslation/TEST_estimateCameraTranslation/sceneGeometry_axialLength=';

figure
subplot(2,1,1);

for ii = 1:length(axialLengths)
    resultFile = [resultFileStem,num2str(axialLengths(ii)),'.mat'];
    load(resultFile)
    x(ii) = result.eye.axialLength;
    y(ii) = result.extrinsicTranslationVector(3);
    err(ii) = result.meta.estimateCameraTranslation.search.transVecSDNoRayTrace(3);
    medianFvals(ii) = median(result.meta.estimateCameraTranslation.search.allFvalsNoRayTrace);
    minFvals(ii) = min(result.meta.estimateCameraTranslation.search.allFvalsNoRayTrace);
    pLBs(ii) = result.meta.estimateCameraTranslation.parameters.translationLBp(3);
    pUBs(ii) = result.meta.estimateCameraTranslation.parameters.translationUBp(3);
end
errorbar(x,y,err,'.')
hold on
plot(x, pLBs);
plot(x, pUBs);
xlim([20 27]);
ylim([min(pLBs) max(pUBs)]);
xlabel('Modeled eye axial length [mm]');
ylabel('Estimated camera depth [mm]');

subplot(2,1,2);
plot(x,minFvals,'.-')
xlim([20 27]);
ylim([0 7e-5]);
xlabel('Modeled eye axial length [mm]');
ylabel('minimum fVal [RMSE]');
