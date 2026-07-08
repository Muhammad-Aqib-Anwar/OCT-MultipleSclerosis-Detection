pathXmeanData = [];
for i = 1:length(imageLayer)
    pathXmeanData = [pathXmeanData; imageLayer(i).retinalLayers.pathXmean];
end

% Write to Excel
writematrix(pathXmeanData, 'pathXmean_data.xlsx');
% Get column names from the first image's retinalLayers
columnNames = {imageLayer(1).retinalLayers.name};

% Extract pathXmean data for all images
pathXmeanData = [];
for i = 1:length(imageLayer)
    currentData = [imageLayer(i).retinalLayers.pathXmean];
    pathXmeanData = [pathXmeanData; currentData];
end

% Create table and write to Excel
dataTable = array2table(pathXmeanData, 'VariableNames', columnNames);
writetable(dataTable, 'pathXmean_data.xlsx');