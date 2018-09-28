function saveThatSucker(thisFig,figureName)
%% Define an output path for figures
outDir = '/Users/aguirre/Dropbox (Aguirre-Brainard Lab)/_Papers/Aguirre_2018_entrancePupil/Figures/raw/';
export_fig(thisFig,fullfile(outDir,figureName));
close(thisFig)
end