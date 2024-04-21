function findIndexes(targetIndices)
% Define the dimensions of the original 3D matrix
%rows = 8;
%cols = 256;
depth = 24;
hyper1 = 2;
hyper2 = 2;
hyper3 = 30;

% Create a sample 3D matrix
%originalMatrix = randi(100, depth, hyper1, hyper2, hyper3);

% Reshape the matrix into a 3D vector
%reshapedVector = reshape(originalMatrix, [depth*hyper1*hyper2*hyper3]);

% Define the indices in the reshaped vector that you want to find in the original matrix
% targetIndices = [7, 10, 18]; % Replace with the indices you're interested in

% targetIndices = 1413; SEI VORSICHTIG

% Find the corresponding indices in the original 3D matrix
[depthIndices, hyper1Indices, hyper2Indices, hyper3Indices] = ind2sub([depth, hyper1, hyper2, hyper3], targetIndices);

% Display the results
disp('Indices in the original 3D matrix:');
disp([depthIndices', hyper1Indices', hyper2Indices', hyper3Indices']);
end
