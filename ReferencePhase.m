function [theta] = ReferencePhase(Phase,w,lambda_max,lambda_max_max)
%ReferencePhase Calculates a reference phase by finding the mean phase in
%that spectral range

% initializing reference phase
theta = zeros(1, size(Phase, 2));

% determine the indices of the reference spectral region (lambda >
% lambdamax)
lambda_indices = sort(DetermineIndices(w, lambda_max,...
    lambda_max_max));
first_lambda_index = lambda_indices(1); 
last_lambda_index = lambda_indices(2);

% calculate the mean phase in that region
for period = 1 : size(Phase, 2)
    theta(period) = PhaseMean(Phase(first_lambda_index : last_lambda_index...
        , period));
end

end
