% This script builds a single vector from the SnowModel timesteps
% and gdat files of interest. 
% INPUTS: parameters, gdat filenames, timesteps of interest
% OUTPUTS: matlab matfile

% To Run in Terminal on a remote server: 
% Navigate to the correct directory
% The version of Matlab that you use is dependent on the version
% that is installed on the server.
% >> matlab.2017b -nodisplay -nodesktop -nosplash -r mk_matrix_for_date

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% USER INPUT SECTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Snowmodel grid information
nx=2570;
ny=2480;
cell=30;

% Use the nt variable below to chose the model iteration of interest.
% For example, model iteration 239 is 2017-04-29, the day of the 2017 LiDAR survey.
nt=239;
 
% These are the snowmodel output files that need to be in the current directory
% The read_grads.m file also needs to be in the current directory for this script to function
fname1='snod.ctl';
vname1='snowd';
[snowd,h]=read_grads(fname1,vname1,'x',[1 nx],'y',[1 ny],'z',[1 1],'t',[nt nt]);

% Renaming the variable and flipping orientation
snow_depth = snowd';

% This bit uses the directory system to build the file name, which is useful in some situations.
dir = pwd; dir = strsplit(dir, '/');
dirl = length(dir);
ref = dir(dirl-8:dirl-2); ref = strjoin(ref,'-');
%folder = pwd;
%ftype = '.mat';
%dash = '_';
slice = 'slice';
filename = strcat(ref,'-',vname1,'-',slice,'.mat');

% Save the single variable of interest to a mat file
save(filename,'snow_depth');

exit;