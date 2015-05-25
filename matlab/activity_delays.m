function [ D, Dcell ] = activity_delays( Input )
% ACTIVITY_DELAYS Computes inter-event times from time-stamps.
%
%    D = ACTIVITY_DELAYS( T ) Returns a column-vector D of size 
%    numel(T) - 1 with the inter-event time between consecutive 
%    time-stamps in the vector T.
% 
%    D = ACTIVITY_DELAYS( Tcell ) Returns a column-vector D with the
%    inter-event times computed from each vector T in the cell-array Tcell.
%    Each entry of Tcell corresponds to the time-stamps of a single user.
%
%    The inter-event times are computed using D(i) = T(i+1) - T(i).

if iscell(Input)
    Tcell = Input;
    % Get the delays from the users' time-stamps. 
    Dcell = cell(size(Tcell));
    for idxUser = 1:numel(Dcell)
        Dcell{idxUser} = activity_delays_vec(Tcell{idxUser});
    end;

    D = cat(1, Dcell{:});
else
    T = Input;
    D = activity_delays_vec(T);
    Dcell = {};
end;
    
    function [ D ] = activity_delays_vec( T )
        D = zeros(numel(T) - 1, 1);
        for idx = 1:(numel(T)-1)
            D(idx) = T(idx+1) - T(idx);
        end;
    end

end