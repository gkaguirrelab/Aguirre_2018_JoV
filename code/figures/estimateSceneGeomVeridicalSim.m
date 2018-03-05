%% estimateSceneGeomVeridicalSim

load('~/Dropbox (Aguirre-Brainard Lab)/Apps/CfNUploader/TEST_estimateCameraTranslation/TEST_estimateCameraTranslation/sceneGeometry_axialLength=23.59.mat')
figure
plot3(0,0,120,'+r');
axis equal
xlim([-2 2]);
ylim([-2 2]);
zlim([116 124]);
grid on
hold on
for ii = 1:100
    pp = result.meta.estimateCameraTranslation.search.allTranslationVecsNoRayTrace{ii};
    plot3(pp(1),pp(2),pp(3),'.k')
end
