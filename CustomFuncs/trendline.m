function coefficients=trendline(x,y,color)
% coefficients=TRENDLINE(x,y,color)
% Plots trendline for x, y data points in color
% Color is a string such as 'r' for red, 'k' for black, 'b' for blue ('k'
% default)
% Alex Backer May 2020

if nargin<3,
    color='k';
end

coefficients = polyfit(x, y, 1);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
hold on;
plot(xFit, yFit, color, 'LineWidth', 2);
grid on;
end

