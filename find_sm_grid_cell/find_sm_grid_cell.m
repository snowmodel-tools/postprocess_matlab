% Find the ij pair in the snowmodel grid for a given projected coordinate.

clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% USER INPUT SECTION %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make meshgrid for domain
xll=444962; %This is the bottom left corner of the SnowModel domain
yll=1272411; %This is the bottom left corner of the SnowModel domain
nx=24; 
ny=24;
cell=100; 

xmin=xll;
ymin=yll;
xmax=xmin+nx*cell;
ymax=ymin+ny*cell; 
[X,Y]=meshgrid(xmin:cell:xmax-cell,ymin:cell:ymax-cell)

x_row = X(1,:); 
y_col = Y(:,1);    
y_row = y_col';

%This is half a grid cell length 
half_grid = 50; 

% Load the SNOTEL observations into the workspace.
obs = csvread('snotel_data_albers.csv');
% This is the albers x value, converted from the Longitude of the station
x_albers = obs(:,3);
% This is the albers y value, converted from the Latitude of the station
y_albers = obs(:,4);
% This relates the dates of SNOTEL to the iterations in the modeled variable
iteration = obs(:,1);
% This is the SNOTEL SWE record in meters
swe = obs(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% END USER INPUT %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Gets the x locations in the grid for each observation
grid_x = x_row; %This is the row of x coordinates associated with the lower left corner of each cell

% Note that x_albers comes in a column and I turn it into a row. 
obs_x = x_albers';

%An empty vector to keep the corresponding x_grid coordinate of each observation from the for loop below
obs_grid_x = zeros(1,length(obs_x)); 

for i = 1:length(obs_x) %iterate over the length of the observation vector
    x = obs_x(i); %get the value of x from the obs vector by position(i)
    if x > xmax || x < xmin 
        obs_position_in_grid_lat = nan
    else
        [m,obs_position_in_grid_lat] = min(abs(grid_x-x)); %find the nearest grid_x coordinate, return the position of the coordinate in the grid_x vector and m, the difference between the grid_x and obs_x coordinates
    end
    
    if ~isnan(obs_position_in_grid_lat) && grid_x(obs_position_in_grid_lat) > x %if the grid_x coordinate is greater than the obs_x the observation is being put in the wrong cell, subtract half a cell length so that it
        [m,obs_position_in_grid_lat] = min(abs(grid_x-(x-half_grid))); %subtract half a cell length so that it goes in the right cell
    end
    
    if ~isnan(obs_position_in_grid_lat) 
        obs_grid_x(i) = grid_x(obs_position_in_grid_lat); %put the value of grid_x into the empty vector
    else
        obs_grid_x(i) = nan
    end
    obs_grid_i(i) = obs_position_in_grid_lat; %put the value of grid_x into the empty vector
end
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gets the y locations in the grid for each observation
%This is the row of x coordinates associated with the lower left corner of each cell
grid_y = y_row; 

%This is the x coordinate of every observation in the domain
obs_y = y_albers';

%An empty vector to keep the corresponding x_grid coordinate of each observation from the for loop below
obs_grid_y = zeros(1,length(obs_y)); 

for i = 1:length(obs_y) %iterate over the length of the observation vector
    y = obs_y(i); %get the value of x from the obs vector by position(i)
    if y > ymax || y < ymin 
        obs_position_in_grid_lat = nan
    else
    [m,obs_position_in_grid_lat] = min(abs(grid_y-y)); %find the nearest grid_x coordinate, return the position of the coordinate in the grid_x vector and m, the difference between the grid_x and obs_x coordinates
    end
    
    if ~isnan(obs_position_in_grid_lat) && grid_y(obs_position_in_grid_lat) > y %if the grid_x coordinate is greater than the obs_x the observation is being put in the wrong cell, subtract half a cell length so that it 
        [m,obs_position_in_grid_lat] = min(abs(grid_y-(y-half_grid))); %subtract half a cell length so that it goes in the right cell
    end
    if ~isnan(obs_position_in_grid_lat) 
        obs_grid_y(i) = grid_y(obs_position_in_grid_lat); %put the value of grid_x into the empty vector
    else
        obs_grid_y(i) = nan
    end
    obs_grid_j(i) = obs_position_in_grid_lat; %put the value of grid_x into the empty vector
end

%%

% Save results to a matrix.
ij_pairs = [obs_grid_i(:),obs_grid_j(:),iteration,swe];
xy_pairs = [obs_grid_x(:),obs_grid_y(:),iteration,swe];

% Write the matrix to csv.
dlmwrite('snotel_data_ijpairs.csv', ij_pairs,',');