% Plotting Script for T-D (t) diagrams
% Temperature in dependency of depth, monthly, seasonal, annual means
% Author: Florentina Münzner (FM)
% Begin: 05.02.2018
%% run this script
clear all
close all
%define your directories
setdir = "N:/geo4/HGF_Boike/Personal_Accounts/Florentina/Project_Jan/MATLAB/CryoGrid3/CryoGrid3_infiltration_xice_20180111/";
folder = '2018-01-24_15-22'

%% LOAD DATA
% load data: OUTPUT and SETTINGS file
filepath_out = [setdir + '/' + folder + '/' + folder + '_output.mat'];
filepath_set = [setdir + '/' + folder + '/' + folder + '_settings.mat'];
output = load(filepath_out) ;
settings = load(filepath_set) ;

OUTPUT = output.OUT;
PARAMS = settings.PARA;
GRID = settings.GRID;
FORCING = settings.FORCING;

% relevant parameter:
Ts = OUTPUT.cryoGrid3();
zs = GRID.general.cT_grid();

%% Ask for time
t_start = datestr(PARAMS.technical.starttime);
t_end = datestr(PARAMS.technical.endtime);
t_savetimestep = OUTPUT.timestamp;
current_time = datetime(datestr(t_savetimestep));
Month = month(current_time);
Year = year(current_time);

%% Ask for indices
uni_year = unique(Year);
uni_month = unique(Month);
index_year = nan( 12, length(uni_year)); 
index_month = nan( length(uni_month), 2, length(uni_year));

%year
for j=1
    for i=1:length(uni_year)
        index_year(i,j) = find(Year == uni_year(i), 1, 'first');
    end
end
for j=2
    for i=1:length(uni_year)
        index_year(i,j) = find(Year == uni_year(i), 1, 'last');
    end
end

%month
for k = 1:length(uni_year)
    for j=1
        for i=1:length(uni_month)
            if isempty(find(Month(index_year(k,1):index_year(k,2)) == uni_month(i) , 1, 'first'));
                index_month(i, j, k) = nan;
            else
                index_month(i, j, k) = find(Month(index_year(k,1):index_year(k,2)) == uni_month(i) , 1, 'first');
            end
            
        end
    end
    for j=2
        for i=1:length(uni_month)
            if isempty(find(Month(index_year(k,1):index_year(k,2)) == uni_month(i) , 1, 'last'));
                index_month(i, j, k) = nan;
            else
                index_month(i, j, k) = find(Month(index_year(k,1):index_year(k,2)) == uni_month(i) , 1, 'last');
            end
            
        end
    end
end

%% mean values
% calculation

% annual
mean_year = nan(length(zs), length(uni_year));
for y=1:length(uni_year)
    mean_year(:,y) = mean(Ts(:, index_year(y,1):index_year(y,2)),2);
end

% monthly
mean_month = nan(length(zs), length(uni_month), length(uni_year));
for k=1:length(uni_year)
    for m=1:length(uni_month)
        if isnan(index_month(m,1,k));
            mean_month(:,m,k) = nan;
        else
            mean_month(:,m,k) = mean(Ts(:, index_month(m,1,k):index_month(m,2,k)),2);
        end
    end
end

%% PLOTS

% Depth vs Temperature
% annual

fig=figure();
ax = gca();
plot(mean_year, - zs)
grid on
% Legend
Legend=cell(length(uni_year),1);
 for iter=1:length(uni_year)
   Legend{iter}=strcat('year ', num2str(uni_year(iter)));
 end
 legend(Legend)
% axis
ylim([-50 5])
% Add labels and title
xlabel('temperature')
ylabel('depth')
title('T-D-Diagram')

% monthly
% plots each year
for plot_year=1:length(uni_year)
    fig=figure();
    ax = gca();
    plot(mean_month(:,:,plot_year), - zs)
    grid on
    % Legend
    Legend=cell(length(uni_month),1);
    for iter=1:length(uni_month)
        Legend{iter}=strcat('Month ', num2str(uni_month(iter)));
    end
    legend(Legend)
    % axis
    ylim([-35 5])
    % Add labels and title
    xlabel('temperature [°C]')
    ylabel('depth [m]')
    title(['T-D-Diagram of Year ' num2str(uni_year(plot_year))]);
end