function [lessThanOrEqual, greaterThan] = divideVectorByThreshold(vector, threshold)
    % Initialize empty vectors
    lessThanOrEqual = [];
    greaterThan = [];
    
    % Loop through each element of the vector
    for i = 1:length(vector)
        % Check if the element is less than or equal to the threshold
        if vector(i) <= threshold
            % Add the element to the 'lessThanOrEqual' vector
            lessThanOrEqual = [lessThanOrEqual, vector(i)];
        else
            % Add the element to the 'greaterThan' vector
            greaterThan = [greaterThan, vector(i)];
        end
    end
end
