%% sceneGeomErrorInEllipseFitting


blankFrame = ones(480,640);
eyePoses=[-25 -25 0 1.5; 0 -25 0 1.5; 25 -25 0 1.5; -25 0 0 1.5; 0 0 0 1.5; 25 0 0 1.5; -25 25 0 1.5; 0 25 0 1.5; 25 25 0 1.5];
sceneGeometryA = createSceneGeometry();
rayTraceFuncsA = assembleRayTraceFuncs( sceneGeometryA );
sceneGeometryB = createSceneGeometry();
sceneGeometryB.extrinsicTranslationVector(3)=90;
rayTraceFuncsB = assembleRayTraceFuncs( sceneGeometryA );


figure
subplot(2,2,1)

imshow(blankFrame, 'Border', 'tight');
hold on
axis off
axis equal
xlim([0 640]);
ylim([0 480]);

% Obtain the pupil ellipse parameters in transparent format
for ii=1:size(eyePoses,1)
    pupilEllipseOnImagePlaneA(ii,:) = pupilProjection_fwd(eyePoses(ii,:),sceneGeometryA,rayTraceFuncsA);
    pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneA(ii,:)));
    fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
    fimplicit(fh,[1, 640, 1, 480],'Color', 'r','LineWidth',1);
    axis off;
end


subplot(2,2,2)

imshow(blankFrame, 'Border', 'tight');
hold on
axis off
axis equal
xlim([0 640]);
ylim([0 480]);

% Obtain the pupil ellipse parameters in transparent format
for ii=1:size(eyePoses,1)
    pupilEllipseOnImagePlaneB(ii,:) = pupilProjection_fwd(eyePoses(ii,:),sceneGeometryB,rayTraceFuncsB);
    pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneB(ii,:)));
    fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
    fimplicit(fh,[1, 640, 1, 480],'Color', 'k','LineWidth',1);
    axis off;
end


subplot(2,2,3)

imshow(blankFrame, 'Border', 'tight');
hold on
axis off
axis equal
xlim([0 640]);
ylim([0 480]);

% Obtain the pupil ellipse parameters in transparent format
for ii=1:size(eyePoses,1)
    bestFitEyePosesC(ii,:) = pupilProjection_inv(pupilEllipseOnImagePlaneB(ii,:),sceneGeometryA,rayTraceFuncsA,'constraintTolerance',0.8);
    pupilEllipseOnImagePlaneC(ii,:) = pupilProjection_fwd(bestFitEyePosesC(ii,:),sceneGeometryA,rayTraceFuncsA);
    pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneC(ii,:)));
    fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
    fimplicit(fh,[1, 640, 1, 480],'Color', 'r','LineWidth',1);
    axis off;
    pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneB(ii,:)));
    fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
    fimplicit(fh,[1, 640, 1, 480],'Color', 'k','LineWidth',1);
    axis off;
end



subplot(2,2,4)

imshow(blankFrame, 'Border', 'tight');
hold on
axis off
axis equal
xlim([0 640]);
ylim([0 480]);

% Obtain the pupil ellipse parameters in transparent format
for ii=1:size(eyePoses,1)
    bestFitEyePosesD(ii,:) = pupilProjection_inv(pupilEllipseOnImagePlaneB(ii,:),sceneGeometryA,rayTraceFuncsA);
    pupilEllipseOnImagePlaneD(ii,:) = pupilProjection_fwd(bestFitEyePosesD(ii,:),sceneGeometryA,rayTraceFuncsA);
    pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneD(ii,:)));
    fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
    fimplicit(fh,[1, 640, 1, 480],'Color', 'r','LineWidth',1);
    axis off;
    pFitImplicit = ellipse_ex2im(ellipse_transparent2ex(pupilEllipseOnImagePlaneB(ii,:)));
    fh=@(x,y) pFitImplicit(1).*x.^2 +pFitImplicit(2).*x.*y +pFitImplicit(3).*y.^2 +pFitImplicit(4).*x +pFitImplicit(5).*y +pFitImplicit(6);
    fimplicit(fh,[1, 640, 1, 480],'Color', 'k','LineWidth',1);
    axis off;
end