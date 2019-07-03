function [amp, ang] = SingleFrequencyFT(x, y, frequency)
%SingleFrequencyFT Calculate the discrete Fourier transform at an
%individual wavelength

% sine integral
a = sum(sin(2 * pi * x / frequency) .* y);

%cosine integral
b = sum(cos(2 * pi * x / frequency) .* y);

% FT magnitude
amp = sqrt(a^2 + b^2);

% FT phase
ang = atan2(a, b);

end

