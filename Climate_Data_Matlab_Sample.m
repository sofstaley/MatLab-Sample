root    = '/Users/sof/Documents/Esys 300/Lab 3/';

MatfilePath = [root 'Matfiles'] ; 
DataPath    = [root 'Data'] ;
PlotPath    = [root 'Plot'] ;

addpath(MatfilePath,DataPath, PlotPath)

% Load GISS-Temperature data: 1880 to today

filename = 'Land_Ocean_Temperature_Index.nc';
ncdisp(filename)

% Calculate the Yearly and JFM means (do not show your answer)

temp_anomaly = ncread(filename, 'tempanomaly');
global_temp_anomaly = squeeze(mean(temp_anomaly, 'omitnan'));
global_temp_anomaly = mean(global_temp_anomaly, 'omitnan');
global_temp_anomaly(:, [1724,1728]) = nan;
global_temp_anomaly = reshape(global_temp_anomaly, [12, 144]);

yearly_temp = squeeze(mean(global_temp_anomaly, 'omitnan'));
JFM_means = mean(global_temp_anomaly(1:3,:), 'omitnan');


% Plot the yearly mean temperature time series just to be safe (figure(1))

time = 1880:2023;
figure(1), clf, plot(time, yearly_temp, 'blue-*'), gcf, hold on
title('Global Average Yearly Temperatures 1880-2023')
xlabel('Time [years]')
ylabel('Global Yearly Mean Temperature Anomaly [Celcius]')

% Do the scatter plot

pause

figure(2), clf, scatter(JFM_means, yearly_temp, 'b', 'filled'), gcf
title('JFM Mean Temperature Anomaly vs Average Yearly Temperature Anomaly 1880-2023')
xlabel('JFM Mean Temperature Anomaly')
ylabel('Global Yearly Mean Temperature Anomaly')
hold on

pause
%%

JFM_2015 = JFM_means(1:136);
means_2015 = yearly_temp(1:136);

m_2015 = (137*sum(means_2015.*JFM_2015) - sum(JFM_2015)*sum(means_2015))/(137*sum(JFM_2015.^2)-(sum(JFM_2015))^2);
b_2015 = (sum(means_2015) - m_2015 * sum(JFM_2015))/137;
best_fit = m_2015 * JFM_2015 + b_2015;

figure(2), clf, scatter(JFM_2015, means_2015, 'b', 'filled')
hold on
plot(JFM_2015, best_fit, 'k-', 'LineWidth', 1.5)
title('Global Mean JFM Temperatures vs Mean Yearly Temperatures 1880-2015')
xlabel('JFM Mean Temperature Anomaly')
ylabel('Global Yearly Mean Temperature Anomaly')
hold on 

detrended = means_2015 - (m_2015*JFM_2015 + b_2015);
sixteen_error = std(detrended);

top_error_95 = best_fit + 2.*sixteen_error;
bottom_error_95 = best_fit - 2.*sixteen_error;

figure(2), plot(JFM_2015, top_error_95, 'm-', 'LineWidth', 1.15)
plot(JFM_2015, bottom_error_95, 'm-', 'LineWidth', 1.15, 'HandleVisibility','off')
legend('', 'Trendline', 'Location', 'eastoutside')
hold on
 
pause
%%

means_2015(137) = yearly_temp(137);
JFM_2015(137) = JFM_means(137);

proj = m_2015*JFM_means(137) + b_2015;

figure(2), plot(JFM_means(137), proj,'r+', 'LineWidth', 2), hold on
legend  ('',  'Trendline', '95% Confidence Interval', 'Projected 2016 Average')

pause
%%

top_error_90 = best_fit + sixteen_error;
bottom_error_90 = best_fit - sixteen_error;
top_error_99 = best_fit + 3.*sixteen_error;
bottom_error_99 = best_fit - 3.*sixteen_error;

error_90 = sixteen_error;
error_95 = sixteen_error * 2;
error_99 = sixteen_error * 3;

 
figure(2), plot(JFM_2015(1:136), top_error_90, 'r-', 'LineWidth', 1.25, 'HandleVisibility','on')
figure(2), plot(JFM_2015(1:136), bottom_error_90, 'r-', 'LineWidth', 1.25, 'HandleVisibility','off')
figure(2), plot(JFM_2015(1:136), top_error_99, 'g-', 'LineWidth', 1.05, 'HandleVisibility','on')
figure(2), plot(JFM_2015(1:136), bottom_error_99, 'g-', 'LineWidth', 1.05, 'HandleVisibility','off')
legend('', 'Trendline', '95% Confidence Interval', 'Projected 2016 Average','90% Confidence Interval', '99% Confidence Interval')
hold on

figure(2)
errorbar(JFM_2015(137), proj, error_90, 'HandleVisibility','off'), hold on
errorbar(JFM_2015(137), proj, error_95, 'HandleVisibility','off'), hold on
errorbar(JFM_2015(137), proj, error_99, 'HandleVisibility','off'), hold on

disp('I am 95% certain that the 2016 global mean temperature is going to')
disp('the warmest year on record because all points within my 95% confidence')
disp('interval lie above the previously recorded global mean temperature points.')

pause
%%

figure(1)
errorbar(2016, proj, error_90), hold on
errorbar(2016, proj, error_95), hold on
errorbar(2016, proj, error_99), hold on
gcf

figure(1), plot(2016, yearly_temp(137), 'g*')








