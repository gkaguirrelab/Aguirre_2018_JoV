%% modelEyeAxialSchematic

if ~exist('sphericalAmetropia','var')
    sphericalAmetropia = 0;
end

if ~exist('axialLength','var')
    axialLength = [];
end

sceneGeometry = createSceneGeometry('sphericalAmetropia',sphericalAmetropia,'axialLength',axialLength);
eye = modelEyeParameters('sphericalAmetropia',sphericalAmetropia,'axialLength',axialLength );

%% Plot the anterior and posterior chambers
ep = ellipse_ex2im([eye.posteriorChamberCenter(1:2) eye.posteriorChamberRadii(1:2) 0]);
plotEllipse(ep)
hold on
ep = ellipse_ex2im([eye.corneaBackSurfaceCenter(1:2) eye.corneaBackSurfaceRadii(1:2) 0]);
plotEllipse(ep)
ep = ellipse_ex2im([eye.corneaFrontSurfaceCenter(1:2) eye.corneaFrontSurfaceRadii(1:2) 0]);
plotEllipse(ep)

%% Add the pupil center, 2mm radius pupil, center of rotation, iris boundary
plot([eye.pupilCenter(1) eye.pupilCenter(1)],[-2 2],'-k');
plot(eye.pupilCenter(1),eye.pupilCenter(2),'*r')
plot(eye.rotationCenter(1),eye.rotationCenter(2),'xg')
plot(eye.irisCenter(1),eye.irisCenter(2)+eye.irisRadius,'xb')
plot(eye.irisCenter(1),eye.irisCenter(2)-eye.irisRadius,'xb')

%% Find the coordinates of the corneal apex after rotating the eye by kappa(1)
[~, ~, sceneWorldPoints, ~, pointLabels] = pupilProjection_fwd([eye.kappaAngle(1) 0 0 1], sceneGeometry, [], 'fullEyeModelFlag',true);
idx = find(strcmp(pointLabels,'cornealApex'));
plot(sceneWorldPoints(idx,3),sceneWorldPoints(idx,1),'xy');

axis equal
title('axial view');
ylabel('temporal <----> nasal')

function plotEllipse(ep)
fh=@(x,y) ep(1).*x.^2 +ep(2).*x.*y +ep(3).*y.^2 +ep(4).*x +ep(5).*y +ep(6);
fimplicit(fh,[-30, 5, -15, 15],'Color', 'k','LineWidth',1);
end
