%% Create figures for Aguirre & Frazzetta 2018
%
%

%% Define an output path for figures
outDir = '/Users/aguirre/Dropbox (Aguirre-Brainard Lab)/_Papers/Aguirre_2018_transparentTrack/Figures/raw/';


% %% The transparent ellipse params
% DEMO_transparentEllipseParams
% figureName = 'demoEllipseParams.pdf';
% saveas(gcf,fullfile(outDir,figureName));
% close gcf


% %% Ray tracing through the cornea
% % Plot a set of rays of different initial thetas on the default model eye
% sceneGeometry = createSceneGeometry();
%
% % Minimize clutter in the figure
% clear figureFlag
% figureFlag.legend = false;
% figureFlag.imageLines = false;
% figureFlag.textLabels = false;
% outputRay = rayTraceCenteredSphericalSurfaces([sceneGeometry.eye.pupilCenter(1) 2], deg2rad(46), sceneGeometry.opticalSystem, figureFlag);
%
% % Adjust the the figure flag so that we re-plot on the initial figure
% figureFlag.surfaces = false;
% figureFlag.imageLines = false;
% figureFlag.refLine = false;
% figureFlag.rayLines = true;
% figureFlag.finalUnitRay = true;
% figureFlag.textLabels = false;
% figureFlag.legend = false;
% figureFlag.new = false;
% for deg = 31:-15:-44
%     outputRay = rayTraceCenteredSphericalSurfaces([sceneGeometry.eye.pupilCenter(1) 2], deg2rad(deg), sceneGeometry.opticalSystem, figureFlag);
%     drawnow
% end
%
% % save the figure
% figureName = 'Figure x - CorneaRayTrace.pdf';
% saveas(gcf,fullfile(outDir,figureName));
% close gcf


% %% Ellipse sets for different scene geometries
% 
% blankFrame = ones(480,640);
% eyePoses=[-25 -25 0 1.5; 0 -25 0 1.5; 25 -25 0 1.5; -25 0 0 1.5; 0 0 0 1.5; 25 0 0 1.5; -25 25 0 1.5; 0 25 0 1.5; 25 25 0 1.5];
% sceneGeometryA = createSceneGeometry();
% rayTraceFuncsA = assembleRayTraceFuncs( sceneGeometryA );
% sceneGeometryB = createSceneGeometry();
% sceneGeometryB.extrinsicTranslationVector(3)=90;
% rayTraceFuncsB = assembleRayTraceFuncs( sceneGeometryA );
% 
% 
% figure
% subplot(2,2,1)
% 
% imshow(blankFrame, 'Border', 'tight');
% hold on
% axis off
% axis equal
% xlim([0 640]);
% ylim([0 480]);
% 
% % Obtain the pupil ellipse parameters in transparent format
% for ii=1:size(eyePoses,1)
%     pupilEllipseOnImagePlaneA(ii,:) = pupilProjection_fwd(eyePoses(ii,:),sceneGeometryA,rayTraceFuncsA);
%     pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneA(ii,:)));
%     fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
%     fimplicit(fh,[1, 640, 1, 480],'Color', 'r','LineWidth',1);
%     axis off;
% end
% 
% 
% subplot(2,2,2)
% 
% imshow(blankFrame, 'Border', 'tight');
% hold on
% axis off
% axis equal
% xlim([0 640]);
% ylim([0 480]);
% 
% % Obtain the pupil ellipse parameters in transparent format
% for ii=1:size(eyePoses,1)
%     pupilEllipseOnImagePlaneB(ii,:) = pupilProjection_fwd(eyePoses(ii,:),sceneGeometryB,rayTraceFuncsB);
%     pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneB(ii,:)));
%     fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
%     fimplicit(fh,[1, 640, 1, 480],'Color', 'k','LineWidth',1);
%     axis off;
% end
% 
% 
% subplot(2,2,3)
% 
% imshow(blankFrame, 'Border', 'tight');
% hold on
% axis off
% axis equal
% xlim([0 640]);
% ylim([0 480]);
% 
% % Obtain the pupil ellipse parameters in transparent format
% for ii=1:size(eyePoses,1)
%     bestFitEyePosesC(ii,:) = pupilProjection_inv(pupilEllipseOnImagePlaneB(ii,:),sceneGeometryA,rayTraceFuncsA,'constraintTolerance',0.8);
%     pupilEllipseOnImagePlaneC(ii,:) = pupilProjection_fwd(bestFitEyePosesC(ii,:),sceneGeometryA,rayTraceFuncsA);
%     pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneC(ii,:)));
%     fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
%     fimplicit(fh,[1, 640, 1, 480],'Color', 'r','LineWidth',1);
%     axis off;
%     pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneB(ii,:)));
%     fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
%     fimplicit(fh,[1, 640, 1, 480],'Color', 'k','LineWidth',1);
%     axis off;
% end
% 
% 
% 
% subplot(2,2,4)
% 
% imshow(blankFrame, 'Border', 'tight');
% hold on
% axis off
% axis equal
% xlim([0 640]);
% ylim([0 480]);
% 
% % Obtain the pupil ellipse parameters in transparent format
% for ii=1:size(eyePoses,1)
%     bestFitEyePosesD(ii,:) = pupilProjection_inv(pupilEllipseOnImagePlaneB(ii,:),sceneGeometryA,rayTraceFuncsA);
%     pupilEllipseOnImagePlaneD(ii,:) = pupilProjection_fwd(bestFitEyePosesD(ii,:),sceneGeometryA,rayTraceFuncsA);
%     pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneD(ii,:)));
%     fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
%     fimplicit(fh,[1, 640, 1, 480],'Color', 'r','LineWidth',1);
%     axis off;
%     pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneB(ii,:)));
%     fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
%     fimplicit(fh,[1, 640, 1, 480],'Color', 'k','LineWidth',1);
%     axis off;
% end
% 
% % save the figure
% figureName = 'sceneGeomErrorInEllipseFitting.pdf';
% saveas(gcf,fullfile(outDir,figureName));
% close gcf

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

figureName = 'estimateSceneGeomVeridicalSim.pdf';
saveas(gcf,fullfile(outDir,figureName));
close gcf