function [distOut, pathOut, predOut] = graphshortestpath(G, s, t, varargin)
% COMPAT SHIM for legacy `graphshortestpath` using modern graph/digraph.
% Supports weighted, nonnegative, directed/undirected shortest paths.
% Typical legacy usage:
%   [dist, path] = graphshortestpath(A, s, t, 'DIRECTED', true);
%
% Inputs:
%   G  : numeric adjacency (NxN, weights in nonzeros) OR graph/digraph
%   s,t: 1-based node indices
% Optional name/value:
%   'DIRECTED', true/false   (default: true)
%   'WEIGHTS',  W            (NxN matrix or edge-weight vector; optional)

% ---- parse options ----
directed = true;
weights  = [];
i = 1;
while i <= numel(varargin)
    key = upper(string(varargin{i}));
    if i == numel(varargin), break; end
    val = varargin{i+1};
    if key == "DIRECTED"
        directed = logical(val);
    elseif key == "WEIGHTS"
        weights = val;
    end
    i = i + 2;
end

% ---- build graph object with weights ----
if isa(G, 'graph') || isa(G, 'digraph')
    H = G;
    % If a weights matrix/vector was explicitly provided, try to set it
    if ~isempty(weights)
        % Rebuild edges with explicit weights from adjacency-style input
        if ~istable(H.Edges) || ~ismember('EndNodes', H.Edges.Properties.VariableNames)
            error('Provided graph/digraph lacks Edges/EndNodes table compatible with weights.');
        end
        EN = H.Edges.EndNodes;
        if ismatrix(weights) && ~istable(weights)
            % weights is NxN matrix: sample at edge positions
            w = arrayfun(@(k) weights(EN(k,1), EN(k,2)), 1:size(EN,1));
        else
            % assume vector of correct length
            w = weights;
        end
        H.Edges.Weight = w(:);
    end
else
    % Numeric adjacency
    A = double(G);
    n = size(A,1);
    if size(A,2) ~= n
        error('Adjacency matrix must be square.');
    end
    [ii, jj, vv] = find(A);
    if isempty(weights)
        w = vv;                      % use nonzero values as weights
    else
        if ismatrix(weights)
            w = weights(sub2ind(size(weights), ii, jj));
        else
            w = weights(:);
            if numel(w) ~= numel(ii)
                error('Length of WEIGHTS vector does not match number of edges.');
            end
        end
    end
    if directed
        H = digraph(ii, jj, w, n);
    else
        H = graph(ii, jj, w, n);
    end
end

% ---- shortest path (assumes nonnegative weights) ----
[pathOut, distOut] = shortestpath(H, s, t, 'Method', 'positive');

% ---- predecessor vector (legacy third output) ----
if nargout > 2
    predOut = nan(1, numnodes(H));
    if ~isempty(pathOut)
        for k = 2:numel(pathOut)
            predOut(pathOut(k)) = pathOut(k-1);
        end
    end
end
end
