function modelInput()
% Read model parameters and stock them in global variable

global  parSPM;

% Time parameters
parSPM.T  = 0.2e5.*365;                                                       % Model duration (day)
parSPM.dt = 1000.*365;                                                      % Time step (day)
parSPM.t  = [0:parSPM.dt:parSPM.T];                                         % Time vector
parSPM.nt = numel(parSPM.t);                                                % Number of time steps

% Space parameters
parSPM.npt= 10000;                                                          % Number of model points
parSPM.L  = 10000;                                                          % Model horizontal length
parSPM.Lc = 1000;                                                           % Minimum discharge for rivers (NOT USED)

% Uplift and precipitation rates
parSPM.U  = 0.1./365;                                                       % Uplift rate (m/day)
parSPM.P  = 5./365;                                                         % Precipitation (m/day)

% Stream Power erosion law
parSPM.K  = 1e-5;                                                           % Stream power efficiency K.A^m.S^n.
parSPM.m  = 0.5;                                                            % Stream power area exponent K.A^m.S^n.
parSPM.n  = 1;                                                              % Stream power slope exponent K.A^m.S^n (THE SOLUTION WORKS ONLY FOR N=1 (could be changed))

% Hillslopes
parSPM.D  = 1e-3;                                                           % Diffusion (NOT USED)

