%% 
% addpath('/home/tanvirdell3/Downloads/caserel-master');   % folder that contains getRetinalLayers.m and its helpers
% %img = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Selected Frames All MS-Control/Control/hc01_spectralis_macula_v1_s1_R_frame_019.png';
% img = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Selected Frames Datasest/MS/ms01_spectralis_macula_v1_s1_R/ms01_spectralis_macula_v1_s1_R_frame_024.png';
% output_folder = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Selected Frames Datasest/MS/segmentation/MS';
% I = imread(img);   % or .tif
% if ndims(I) == 3, I = rgb2gray(I); end  % make sure it's 2D
% params = struct();
% params.isResize      = [true 0.5];    % resize to 50% (same default)
% params.filter0Params = [5 5 1];       % first Gaussian (denoise)
% params.filterParams  = [20 20 2];     % second Gaussian (smoothing)
% [retinalLayers, params_out] = getRetinalLayers(I);
% 

%% Batch that passes image path + output folder to the function
addpath('/home/tanvirdell3/Downloads/caserel-master');

input_dir  = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Extracted frames for Segementation/MS';
output_dir = '/home/tanvirdell3/Downloads/caserel-master/Publically available Dataset/Segmentation/MS';
if ~exist(output_dir,'dir'); mkdir(output_dir); end

exts = {'*.png','*.jpg','*.jpeg','*.tif','*.tiff'};
files = []; for e = 1:numel(exts), files = [files; dir(fullfile(input_dir, exts{e}))]; end %#ok<AGROW>

for i = 1:numel(files)
    in_path = fullfile(files(i).folder, files(i).name);
    I = imread(in_path); if ndims(I)==3, I = rgb2gray(I); end; I = im2double(I);

     % resize the image if 1st value set to 'true',
    % with the second value to be the scale.
    params.isResize = [true 0.5];
    
    % parameter for smothing the images.
    params.filter0Params = [5 5 1];
    params.filterParams = [20 20 2];           
        
    % constants used for defining the region for segmentation of individual layer
    params.roughILMandISOS.shrinkScale = 0.2;
    params.roughILMandISOS.offsets = -20:20;    
    params.ilm_0 = 4;
    params.ilm_1 = 4;
    params.isos_0 = 4;
    params.isos_1 = 4;
    params.rpe_0 = 0.05;
    params.rpe_1 = 0.05;
    params.inlopl_0 = 0.1; %   0.4;%
    params.inlopl_1 = 0.3; %   0.5;%  
    params.nflgcl_0 = 0.05;%  0.01;
    params.nflgcl_1 = 0.3; %   0.1;
    params.iplinl_0 = 0.6;
    params.iplinl_1 = 0.2;
    params.oplonl_0 = 0.05;%4;
    params.oplonl_1 = 0.5;%4;    
        
    % parameters for ploting
    params.txtOffset = -7;
    %colorarr=colormap('jet'); 
    colorarr = jet(64);
    params.colorarr=colorarr(64:-8:1,:);
    
    % a constant (not used in this function, used in 'octSegmentationGUI.m'.)
    params.smallIncre = 2;    

    % NEW: pass paths so the function can save
    params.imagePath   = in_path;
    params.outputFolder = output_dir;

    [~, ~] = getRetinalLayers(I, params);   % function will save the overlay
    fprintf('[%3d/%3d] processed %s\n', i, numel(files), in_path);
end

