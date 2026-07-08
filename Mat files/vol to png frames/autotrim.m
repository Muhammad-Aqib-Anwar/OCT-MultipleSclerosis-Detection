function J = autotrim(I, mode)
% CROP_ONCE_APPLY  Pick crop once, then reuse it.
% J = crop_once_apply(I,'pixel')       % fixed pixel rect for all images
% J = crop_once_apply(I,'normalized')  % rect scales with each image size
% crop_once_apply([], 'reset')         % clear stored rect
%
% I: image (HxW or HxWxC), any numeric class.

  persistent rectPix rectNorm rectSet

  if nargin < 2 || isempty(mode), mode = 'pixel'; end

  % Reset path
  if strcmpi(mode,'reset')
      rectPix = []; rectNorm = []; rectSet = false; J = [];
      return
  end

  assert(~isempty(I), 'Provide image I unless using mode==''reset''.');

  [H,W,~] = size(I);

  % Ask user once if not set
  if ~rectSet
      f = figure('Name','Draw crop once, then press Enter / close');
      imshow(I, []); title(sprintf('Draw crop (%s), then press Enter', mode));
      rect = [];
      try
          h = drawrectangle('Color','r');
          pause;                      % wait for user to finish
          rect = round(h.Position);   % [x y w h]
      catch
          h = imrect;
          rect = round(wait(h));
      end
      if ishghandle(f), close(f); end

      % Validate
      if isempty(rect) || numel(rect)~=4 || any(rect(3:4) <= 0)
          error('Crop was cancelled or invalid. Try again.');
      end

      % Clamp to image
      rect(1) = max(1, min(rect(1), W));
      rect(2) = max(1, min(rect(2), H));
      rect(3) = max(1, min(rect(3), W - rect(1) + 1));
      rect(4) = max(1, min(rect(4), H - rect(2) + 1));

      % Store both pixel and normalized versions
      rectPix  = rect;
      rectNorm = [rect(1)/W, rect(2)/H, rect(3)/W, rect(4)/H];
      rectSet  = true;
  end

  % Build rect for this image
  switch lower(mode)
    case 'pixel'
      rp = rectPix;
    case 'normalized'
      if isempty(rectNorm) || numel(rectNorm)~=4
          error('No normalized rectangle stored. Call with an image first or use ''reset''.');
      end
      rp = round([rectNorm(1)*W, rectNorm(2)*H, rectNorm(3)*W, rectNorm(4)*H]);
    otherwise
      error('mode must be ''pixel'', ''normalized'', or ''reset''.');
  end

  % Ensure positive size and clamp to bounds
  rp(3) = max(1, rp(3));  rp(4) = max(1, rp(4));
  rp(1) = max(1, min(rp(1), W));
  rp(2) = max(1, min(rp(2), H));
  rp(3) = min(rp(3), W - rp(1) + 1);
  rp(4) = min(rp(4), H - rp(2) + 1);

  % Crop
  x1 = rp(1); y1 = rp(2); x2 = x1 + rp(3) - 1; y2 = y1 + rp(4) - 1;
  J  = I(y1:y2, x1:x2, :);
end