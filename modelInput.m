function modelInput()
% Read model parameters and stock them in global variable

global  parSPM;

% Time parameters
parSPM.T  = 0.5e6.*365;                                                     % Model duration (day)
parSPM.dt = 10000.*365;                                                       % Time step (day)
parSPM.t  = [parSPM.dt:parSPM.dt:parSPM.T];                                         % Time vector
parSPM.nt = numel(parSPM.t);                                                % Number of time steps

% Space parameters
parSPM.npt= 50000;                                                          % Number of model points
parSPM.L  = 25000;                                                          % Model horizontal length
parSPM.Qc = 1.*1000^2;                                                      % Minimum discharge for rivers

% Uplift and precipitation rates
parSPM.U  = 0.01./365;                                                      % Uplift rate (m/day)
parSPM.P  = 5./365;                                                         % Precipitation (m/day)


parSPM.Qc=parSPM.Qc.*parSPM.P;

% Stream Power erosion law
parSPM.K  = 1e-6;                                                           % Stream power efficiency K.A^m.S^n.
parSPM.m  = 0.5;                                                            % Stream power area exponent K.A^m.S^n.
parSPM.n  = 1;                                                              % Stream power slope exponent K.A^m.S^n (THE SOLUTION WORKS ONLY FOR N=1 (could be changed))
parSPM.Niter=100;                                                           % Iteration number for steady-state

% Landslide model
parSPM.phi = 35;                                                            % Hillslope friction angle (degrees)
parSPM.c  = 10e3;                                                           % Hillslope cohesion (Pa)  
parSPM.rho= 2600;                                                           % Hillslope density (kg/m3)
parSPM.g  =9.81;                                                            % Standard gravity (m/s2)
parSPM.nl =1000;                                                            % Landslide number (per time step)
