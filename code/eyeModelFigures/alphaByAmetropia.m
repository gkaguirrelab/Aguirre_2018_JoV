
% Digitized from Mathur 2013 figure 8 using the web plot digitizer
% -alpha by refraction error
mathurData = [   -4.9433   -4.2966   -1.0632   -1.8460   -2.5721   -3.1280   -4.2399   -2.6856   -1.7893   -1.4716   -0.0648    0.1961    0.0032   -0.2690    0.0032    0.6726    0.5478    0.5932   -0.5413   -0.5413   -0.2010   -0.1783    0.6726    0.8314    0.1507    0.0600   -0.0308    0.1167    0.3436    2.1815
   -0.8299   -2.7801   -1.5353   -3.0705   -3.3402   -3.9004   -6.8672   -6.4938   -3.6722   -3.6515   -4.0664   -4.3361   -4.5436   -4.7303   -5.2075   -5.1660   -5.0622   -5.0207   -6.1203   -6.4730   -5.9959   -6.3071   -6.1826   -6.4730   -7.1369   -7.3237   -7.5519   -7.5934   -8.4855   -7.5726];
% Convert the -alpha to positive alpha
mathurData(2,:) = -mathurData(2,:);

% Hashemi 2010 Table 3
% kapa by refraction error
hashemiData = [-7.5 -4.5 -1.5 0 1 3 5; 2.96 4.66 5.55 5.73 5.53 5.45 5.59];

% Tabernero 2007 alpha by axial length
taberneroData = [    22.4046   22.6534   22.2886   22.2222   23.7313   24.6766   25.2736   24.4444   22.4378   22.2554   23.0680   23.0348   23.7479   24.5937   24.7761   25.4726   25.7877   27.8773
    8.8219    8.4110    7.5342    6.7123    7.1233    6.5205    6.1096    6.0274    5.6438    4.7945    4.1644    4.0274    3.9452    3.7260    4.8219    4.2192    3.7260    2.0274];

% Convert axial length in Tabernero to spherical error using the Atchison
% 2006 Eq19
ametropiaFromLength = @(x) (23.58 - x)./0.299;
taberneroData(1,:) = ametropiaFromLength(taberneroData(1,:));

plot(mathurData(1,:),mathurData(2,:),'ok');
hold on
plot(hashemiData(1,:),hashemiData(2,:),'or');
plot(taberneroData(1,:),taberneroData(2,:),'ob');

% Add our model fit

sphericalAmetropias = -15:1:5;
for aa = 1:length(sphericalAmetropias)
    eye = modelEyeParameters('sphericalAmetropia',sphericalAmetropias(aa));
    alphaAzi(aa)= eye.alpha(1);
    alphaEle(aa)= eye.alpha(2);
end

plot(sphericalAmetropias,alphaAzi,'-r')