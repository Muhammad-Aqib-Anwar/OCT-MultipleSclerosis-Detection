function saveBScanFrames(vol_path, output_folder)
    % SAVEBSCANFRAMES Save all BScan frames from a single .vol file
    %
    % Inputs:
    %   vol_path: Full path to the .vol file
    %   output_folder: Path to folder where images will be saved
    
    % Create output folder if it doesn't exist
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    
    fprintf('Processing file: %s\n', vol_path);
    
    % Read the .vol file
    [header, BScanHeader, slo, BScans] = openVol(vol_path);
    
    % Get file name without extension
    [~, filename, ~] = fileparts(vol_path);
    
    % Get dimensions of BScans
    [height, width, num_frames] = size(BScans);
    
    fprintf('  Saving %d frames...\n', num_frames);
    %BScans = imadjustn(BScans) ;
    % BScans = BScans + 1e-10;
    % Save each BScan frame as an image
    for frame_idx = 1:num_frames
        % Extract the current frame
        current_frame = BScans(:, :, frame_idx);

        current_frame = histeq(current_frame) ;
        image_frame = imadjust(current_frame) ;

        %autotrim
        image_frame_cropped = autotrim(image_frame, 'normalized');

        % Create filename
        frame_filename = sprintf('%s_frame_%03d.png', filename, frame_idx);
        output_path = fullfile(output_folder, frame_filename);
       
        
        % Save as PNG image
        imwrite(image_frame_cropped, output_path);
        %imshow(image_frame); axis off
     
       % set(gca, 'LooseInset', get(gca, 'TightInset'));
        % set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
        %set(gca, 'Color', 'none');
        % ax = gca;
        % exportgraphics(ax, output_path, 'ContentType', 'image','Resolution',300, 'Padding',0)
        
        % Optional: Display progress
        if mod(frame_idx, 10) == 0
            fprintf('    Saved frame %d/%d\n', frame_idx, num_frames);
        end
    end
    
    fprintf('  Finished saving all frames!\n');
end