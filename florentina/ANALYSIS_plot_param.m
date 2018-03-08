%% Script for plotting Parameter of Cryogrid3, v.2018-01-11
% please execute the run file

%% PLOT
% absolute values according to surface elevation
% Active Layer Depth ALD
% Water Table WT
% Soil Surface Altitude
% Snow Height
%
fig=figure();
ax = gca();

% Water Table in m
plot(ts, WT, 'b', 'DisplayName','Water Table');
hold on
% Active Layer Depth
plot(ts, ALD, 'g', 'DisplayName','Active Layer Depth');
hold on
% Soil Surface Altitude
plot(ts, soil_surface_altitude, 'k', 'DisplayName','Soil Surface Altitude');
hold on
% Snow Height
plot(ts, snow_height, 'm', 'DisplayName','Snow Height');
hold on
% Lakefloor
plot(ts,lakefloor, 'c', 'DisplayName','Lakefloor');
% Lake position

% Legend
legend('Location', 'southeast');
% Add labels and title
grid on
xlabel('Date')
ylabel('Depth [m]')
title('Output Values using Cryogrid3,v.20180111')
datetick('x')



%% PLOTTING
% Soil temperature
% x - Axis: Time
% y - Axis: Depth

fig=figure();
plot(ts, T_depth)
grid on
% Legend, iterates through all available requested depths
Legend=cell(length(depth),1);
 for iter=1:length(depth)
   Legend{iter}=strcat(num2str(depth(iter)), ' m');
 end
 legend(Legend)
% Add labels and title
xlabel('Date')
ylabel('Soil Temperature [°C]')
title('Soil Temperatures at different depths')
datetick('x')

%% Plotting
% Moisture

fig=figure();
ax = gca();
plot(ts, Moist_depth)
grid on
% Legend, iterates through all available requested depths
Legend=cell(length(depth),1);
 for iter=1:length(depth)
   Legend{iter}=strcat(num2str(depth(iter)), ' m');
 end
 legend(Legend)
% Add labels and title
xlabel('Date')
ylabel('Soil Moisture [ratio]')

title('Soil Moisture at different depths')
datetick('x')