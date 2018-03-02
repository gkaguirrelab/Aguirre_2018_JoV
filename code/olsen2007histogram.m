%% olsen2007histogram
%% Analyze data extracted from Olsen 2007
% Histogram data from Figure 1 of Olsen 2007
res_refractionVals = [-12	-7	-6	-5	-4	-3	-2	-1	0	1	2	3	4	5	6	7	8];
res_refractionCounts = [1	1	4	5	25	19	28	79	149	189	114	60	23	6	7	5	1];
refractionHistFit = fit(res_refractionVals',res_refractionCounts','gauss1');
sigmaRefractionDiopters  = refractionHistFit.c1;

% Histogram data from Figure 4 of Olsen 2007
res_axialLengthVals = [21 22 23 24 25 26 27 28];
res_axialLengthCounts = [7	40	199	291	126	51	5	2];
axialLengthHistFit = fit(res_axialLengthVals',res_axialLengthCounts','gauss1');
sigmaLengthMm = axialLengthHistFit.c1;

% Reported correlation between axial length and diopters of refractive
% error in Olsen 2007
p = -0.59;

% Calculate the width of the distribution of axial lengths given the
% spherical refraction. This draws upon the conditional expectation of a
% X given Y in a bivariate normal distribution
conditionalSigmaLength = sqrt((1-p^2)*sigmaLengthMm);

%% Make a figure
h=figure;
set(h, 'Position', [100, 100, 500, 500]);  

sh=subplot(2,2,1);
ph=plot(-15:0.01:15,refractionHistFit(-15:0.01:15),'-r');
hold on
plot(res_refractionVals,res_refractionCounts,'ok');
xlim([-15 15]);
ylim([0 300]);
ylabel('counts')
xlabel('spherical refractive error [diopters]')
pbaspect([1 .25 1])

subplot(2,2,4)
plot(axialLengthHistFit(18:0.01:30),18:0.01:30,'-r');
hold on
plot(res_axialLengthCounts,res_axialLengthVals,'ok');
ylim([18 30]);
xlim([0 300]);
xlabel('counts')
ylabel('axial length [mm]')
pbaspect([.25 1 1])

% Plot the bivariate normal distribution
D = diag([refractionHistFit.c1 axialLengthHistFit.c1]);
covMatrix = D*[1.0 p; p 1.0]*D;
S = D*corrMatrix*D;
c = [refractionHistFit.c1 axialLengthHistFit.c1];

subplot(2,2,3)
plot_gaussian_ellipsoid([refractionHistFit.b1 axialLengthHistFit.b1], S, diag(c))
hold on
plot_gaussian_ellipsoid([refractionHistFit.b1 axialLengthHistFit.b1], S, diag(c)*2)
xlim([-15 15]);
ylim([18 30]);
axis square
