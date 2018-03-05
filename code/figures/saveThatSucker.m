function saveThatSucker(figureName)
%% Define an output path for figures
outDir = '/Users/aguirre/Dropbox (Aguirre-Brainard Lab)/_Papers/Aguirre_2018_transparentTrack/Figures/raw/';
saveas(gcf,fullfile(outDir,figureName));
close gcf
end