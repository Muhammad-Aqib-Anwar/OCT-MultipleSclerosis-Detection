function pp = csaps_shim(x,y,p)
% Approximate cubic smoothing spline (no toolboxes).
% x,y: vectors, p in [0,1] (higher p => less smoothing, like csaps).

x = x(:); y = y(:);
n = numel(x);
if n < 3
    pp = spline(x,y); return;
end

% sort by x and collapse duplicates by averaging
[x,ord] = sort(x); y = y(ord);
[ux,~,ic] = unique(x,'stable');
if numel(ux) < numel(x)
    y = accumarray(ic, y, [], @mean);
    x = ux;
    n = numel(x);
end

% second-difference regularizer
e = ones(n,1);
D = spdiags([e -2*e e], 0:2, n-2, n);
h = median(diff(x));
lambda = max(1e-12, (1-p)/max(p,1e-6)) * (h^2);

A = speye(n) + lambda*(D.'*D);
f = A \ y;

pp = spline(x, f);   % cubic pp you can evaluate with ppval
end
