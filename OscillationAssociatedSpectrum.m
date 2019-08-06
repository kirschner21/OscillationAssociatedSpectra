function [Amplitude, Phase, w] = OscillationAssociatedSpectrum(data, ...
    wavelength, time, first_wavelength, last_wavelength, first_time,...
    last_time, time_resolution, periods, criterion, oscillation_ratio)
%OscillationAssociatedSpectrum Calculates OAS of data
% 
% [Amplitude, Phase, w] = OscillationAssociatedSpectrum(data, ...
%    wavelength, time, first_wavelength, last_wavelength, first_time,...
%    last_time, time_resolution, periods, criterion, oscillation_ratio)
%
% INPUT
%   data                2D-array (wavelength x time) of transient 
%                       absorption (TA) data
%   wavelength          1D-array corresponding to the wavelengths in 
%                       the TA data
%   time                1D-array corresponding to the times in the TA data 
%   first_wavelength    First wavelength in the OAS
%   last_wavelength     Final wavelength in the OAS
%   first_time          First time to be used in the Fourier transform
%   last_time           Final time to be used in the Fourier transform
%   time_resolution     Time dependent data will be resampled/interpolated
%                       at this rate
%   periods             Oscillation periods to be considered
%   crieterion          Information criterion for itcmp, -1 uses AIC, 
%                       -2 MDL see itcmp for more info
%   oscillation_ratio   Threshold for defining which components are 
%                       oscillatory.  If the exponential damping rate is
%                       less than oscThresh times the frequency, it is 
%                       considered an oscillation. See 
%                       itcmpFilterOscillations for more details
%
% OUTPUT
%   Amplitude           2D-amplitude map of the OAS at every
%                       wavelength/period
%   Phase               2D-phase map of the OAS at every period
%   w                   1D-array of wavelengths used in the OAS


%   Author: Matthew S. Kirschner
%   Email: kirschner.21 (at) gmail.com
%   Last revision date: August 6, 2019
%
%   Copyright: Matthew S. Kirschner, 2019


% find the wavelength/time range of interest
wavelength_indices = sort(DetermineIndices(wavelength, first_wavelength,...
    last_wavelength));
first_wavelength_index = wavelength_indices(1); 
last_wavelength_index= wavelength_indices(2);

time_indices = sort(DetermineIndices(time, first_time, last_time));
first_time_index = time_indices(1);
last_time_index = time_indices(2);


% initialize amplitude and phase matrices
Amplitude = zeros(last_wavelength_index - first_wavelength_index + 1,...
    length(periods));

Phase = zeros(last_wavelength_index - first_wavelength_index + 1,...
    length(periods));

% the old time values
old_time = time(first_time_index : last_time_index);

% the new time values that the data will be interpolated to
new_time = old_time(1) : time_resolution : old_time(end);

% the actual fit, performed at every wavelength independently
for current_wavelength = first_wavelength_index : last_wavelength_index
    
    % resample the data
    resampled_data = interp1(old_time, data(current_wavelength, ...
        first_time_index : last_time_index), new_time);
    
    % set NaN values to 0
    resampled_data(~isfinite(resampled_data)) = 0;
    
    % matrix pencil method
    temppara = itcmp(resampled_data, criterion);
    
    % figure out which decays are complex
    signalFitExp = itcmpEval(temppara, length(new_time), 'components',...
        'nonOsc','OscThresh',oscillation_ratio); 
    
    % perform the Fourier transformations
    for period = 1 : length(periods)
        [Amplitude(current_wavelength + 1 - first_wavelength_index, period),...
            Phase(current_wavelength + 1 - first_wavelength_index, period)]...
            = SingleFrequencyFT(new_time, resampled_data - real(signalFitExp),...
            periods(period));
    end
    
end

% extract the wavelengths used
w = wavelength(first_wavelength_index : last_wavelength_index);

end