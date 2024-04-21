% Example data (replace with your own x and y coordinates)
x = data(:,1);
y = data(:,2);

% Number of desired interpolated points
numPoints = 100;

% Remove duplicate points
[uniqueX, idx] = unique(x);
uniqueY = y(idx);

% Generate uniformly spaced points along the x-axis
xi = linspace(min(uniqueX), max(uniqueX), numPoints);

% Interpolate the y-coordinates using the unique x-coordinates and xi
yi = interp1(uniqueX, uniqueY, xi, 'linear');

% Plot the original and interpolated data
plot(x, y, 'o', xi, yi, '-');
legend('Original', 'Interpolated');