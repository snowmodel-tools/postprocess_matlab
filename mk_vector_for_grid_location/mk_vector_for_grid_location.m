% This script builds a single vector from the SnowModel timesteps
% and gdat files of interest. 
% INPUTS: parameters, gdat filenames, timesteps of interest
% OUTPUTS: matlab matfile

% To Run in Terminal: 
% Navigate to the correct directory
% The version of Matlab that you use is dependent on the version
% that is installed on the server.
% >> matlab.2017b -nodisplay -nodesktop -nosplash -r mk_vector_for_grid_location

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% USER INPUT SECTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create list of iterations that corresponds with the SnowModel run
timesteps = 1:365;

% Select other parameters
xll=404746; %This is the bottom left corner of the SnowModel domain
yll=1243125; %This is the bottom left corner of the SnowModel domain
nx=2570; %See XDEF in .ctl file 
ny=2480; %See YDEF in .ctl file
cell=30;

% Access the ctl files that you want to build the .mat files.
ctl_files = ["swed.ctl"];
var_names = ["swed"];


% This grid xval and yval comes from the find_sm_grid_cell.m script in this same repository.
% This is the snowmodel grid i,j pair corresponding to the location of the observations or time-series data.
gridi=1388;
gridj=1008;

%NOTE: This script needs the read_grads.m to function correctly.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% END USER INPUT %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(ctl_files)
    ctl_file = char(ctl_files(i));
    var_name = char(var_names(i)); % The variable youre interested in
    [X,Y,Z,xmax,ymax] = readGDAT(timesteps,ctl_file,var_name,xll,yll,nx,ny,cell,gridi,gridj);
    dir = pwd; dir = strsplit(dir, '/');
    dirl = length(dir);
    ref = dir(dirl-8:dirl-2); ref = strjoin(ref,'-');
    savename = strcat(ref,'-',var_name,'.mat');
    cd 
    save(savename,'Z');
end

clear
exit


function [X,Y,Z,xmax,ymax] = readGDAT(timesteps,ctl_file,var_name,xll,yll,nx,ny,cell,gridi,gridj)
    xmin=xll;
    ymin=yll;
    xmax=xmin+nx*cell; % finds the maximum x coord
    ymax=ymin+ny*cell; % finds the maximum y coord
    [X,Y]=meshgrid(xmin:cell:xmax-cell,ymin:cell:ymax-cell); % Create a mesh grid of the model domain space with the right coordinates
    for j=1:length(timesteps) % Loop to create the vector
        nt=timesteps(j); % Starts the loop at the appropriate timestep
        [var,h]=read_grads(ctl_file,var_name,'x',[gridi gridi],'y',[gridj gridj],'z',[1 1],'t',[nt nt]); 
        Z(:,:,j)=(var'); % So now, Z is a vector of values from the grads file.
    end
end
