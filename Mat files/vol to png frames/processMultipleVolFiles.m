function processMultipleVolFiles(vol_folder, output_base_folder)
    % PROCESSMULTIPLEVOLFILES Process all .vol files in a folder
    %
    % Inputs:
    %   vol_folder: Path to folder containing .vol files
    %   output_base_folder: Base path where output folders will be created
    
    % Create output base folder if it doesn't exist
    if ~exist(output_base_folder, 'dir')
        mkdir(output_base_folder);
    end
    
    % Get all .vol files in the specified folder
    vol_files = dir(fullfile(vol_folder, '*.vol'));
    
    if isempty(vol_files)
        fprintf('No .vol files found in: %s\n', vol_folder);
        return;
    end
    
    fprintf('Found %d .vol files to process\n', length(vol_files));
    
    % Process each .vol file
    for file_idx = 1:length(vol_files)
        vol_file = vol_files(file_idx);
        vol_path = fullfile(vol_file.folder, vol_file.name);
        
        % Create individual output folder for this file
        [~, filename, ~] = fileparts(vol_file.name);
        individual_output_folder = fullfile(output_base_folder, filename);
        
        if ~exist(individual_output_folder, 'dir')
            mkdir(individual_output_folder);
        end
        
        fprintf('Processing file %d/%d: %s\n', file_idx, length(vol_files), vol_file.name);
        fprintf('  Output folder: %s\n', individual_output_folder);
        
        try
            % Process the current .vol file
            saveBScanFrames(vol_path, individual_output_folder);
            fprintf('  ✓ Successfully processed\n\n');
        catch ME
            fprintf('  ✗ Error processing %s: %s\n\n', vol_file.name, ME.message);
        end
    end
    
    fprintf('All files processed!\n');
end