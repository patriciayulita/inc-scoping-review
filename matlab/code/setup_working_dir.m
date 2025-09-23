% setup_working_dir.m
% Script to set working directory relative to script location

% Get path of current script
scriptPath = fileparts(mfilename('fullpath'));

% Set working directory to script location
cd(scriptPath);

% Confirm
disp(['Working directory set to: ', pwd]);
