function [z,e]=expliciterosionEulerian(z,discharge,slope)

global parSPM

% Compute migration rate
e=-parSPM.K.*discharge.^parSPM.m.*slope.^parSPM.n.*parSPM.dt;
z=z+e;