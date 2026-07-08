% Folder containing PNG images
%imageFolder = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Segmentation Conv/Control'; % change this path

% ============================================================
% Convert all PNG images in a folder to a .mat file
% ============================================================

% 📁 Define your input folder (where PNG images are located)
inputFolder = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Segmentation Conv/Control';   % <-- change this

% 📂 Define your output folder (where .mat file will be saved)
outputFolder = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Segmentation Conv/controlmat';  % <-- change this

% Create the output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 🔍 Get list of all PNG files in the input folder
imageFiles = dir(fullfile(inputFolder, '*.png'));

% 🧠 Initialize the structure array
imageLayer = struct([]);

% 🔁 Loop through each PNG image
for i = 1:length(imageFiles)
    % Read image
    imgPath = fullfile(inputFolder, imageFiles(i).name);
    imgData = imread(imgPath);
    
    % Store data in a structured format
    imageLayer(i).filename = imageFiles(i).name;
    imageLayer(i).imageData = imgData;
    
    % Optional: predefine retinalLayers field (if needed later)
    % imageLayer(i).retinalLayers = struct('name', {}, 'pathXAnalysis', {});
end

% 🏷️ Define the imagePath for naming the MAT file
imagePath = {'yourImageName'};  % You can change this name freely

% 🧾 Define full save path
savePath = fullfile(outputFolder, [imagePath{1} '_octSegmentation.mat']);

% 💾 Save the MAT file
save(savePath, 'imageLayer');

disp(['✅ PNG images converted and saved to: ' savePath]);
