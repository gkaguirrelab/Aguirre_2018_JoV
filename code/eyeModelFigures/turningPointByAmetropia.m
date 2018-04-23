%% turningPointByAmetropia
%
% Mathur 2013 Figure 8 reports the peak angle (beta) as a function of
% spherical ametropia of the studied subject. They found an inverse
% relationship, with a negative spherical error of -5 diopters associated
% with a -3 degree peak angle, and a positive sperical error of 2 diopters
% associated with a peak angle of 7 degrees, and therefore a slope of -0.61
% degrees per diopter.
%
% We simulated eyes with spherical ametropia ranging from -5 to 2 diopeters
% and measured the peak angle.

figure

% Digitized from figure 8 using the web plot digitizer
mathurData = [-4.943273905996759, -0.8298755186722002
-4.296596434359806, -2.780082987551868
-1.0632090761750401, -1.5352697095435692
-1.8460291734197734, -3.0705394190871376
-2.5721231766612647, -3.3402489626556022
-3.128038897893031, -3.9004149377593365
-4.239870340356564, -6.867219917012449
-2.6855753646677476, -6.493775933609959
-1.7893030794165314, -3.6721991701244816
-1.47163695299838, -3.6514522821576776
-0.06482982171799012, -4.066390041493777
0.19611021069692036, -4.336099585062242
0.0032414910858999946, -4.543568464730291
-0.2690437601296596, -4.730290456431535
0.0032414910858999946, -5.207468879668051
0.6726094003241494, -5.165975103734441
0.5478119935170183, -5.062240663900416
0.5931928687196111, -5.020746887966806
-0.5413290113452192, -6.120331950207469
-0.5413290113452192, -6.473029045643154
-0.20097244732577035, -5.99585062240664
-0.17828200972447306, -6.307053941908714
0.6726094003241494, -6.182572614107884
0.831442463533226, -6.473029045643154
0.15072933549432666, -7.136929460580913
0.05996758508914102, -7.323651452282158
-0.030794165316045508, -7.551867219917012
0.11669367909238293, -7.593360995850624
0.3435980551053488, -8.485477178423237
2.181523500810374, -7.572614107883817]';


viewingAngleDeg = -60:10:60;
pupilDiam = 6.19/1.13;

% Derive the axial length of the eye for each of several ametropia values
ametropiaValues = -7:1:7;

axialLengths = [];
for aa = 1:length(ametropiaValues)
    eye = modelEyeParameters('sphericalAmetropia',ametropiaValues(aa));
    axialLengths = [axialLengths eye.axialLength];
end


% Mathur 2013 Equation 7. Used to fit the pupil diameter values and extract
% the turning point (beta).
eq7 = fittype( @(beta,D,E,x) D.*cosd((x-beta)./E), 'independent','x','dependent','y');

betas = [];
for aa = 1:length(ametropiaValues)
        % Obtain the turning point for the correct axial length
        sceneGeometry = createSceneGeometry('axialLength',axialLengths(aa));
        for vv = 1:length(viewingAngleDeg)
            [diamRatio(vv), C(vv), pupilFitError(vv)] = returnPupilDiameterRatio(viewingAngleDeg(vv),pupilDiam,sceneGeometry);
        end
        f = fit (viewingAngleDeg',diamRatio',eq7,'StartPoint',[5.3,0.93,1.12]);
        betas(aa) = f.beta;
        alphas(aa) = sceneGeometry.eye.alpha(1);
end

% Plot the mathur data
plot(mathurData(1,:),mathurData(2,:),'ok','MarkerSize',10);
hold on
xlim([-5 2.5]);
ylim([-10 0]);
xlabel('Refraction [D]');
ylabel('Turning point beta [deg]');

% Plot our model
plot(ametropiaValues,betas,'-r')

% Plot their fit to the data
mathurFit = @(x) -5.8 - 0.61*x;
plot(ametropiaValues,mathurFit(ametropiaValues),'-k')