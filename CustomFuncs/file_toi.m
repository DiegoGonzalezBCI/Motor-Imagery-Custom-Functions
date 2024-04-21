toc = zeros(60,24,2);
for i = 1:60
    for j = 1:2
        if i <= 30
            [timeOfClassification] = toi(sprintf('%d_jv%d.ebr',i,j));
            toc(i,:,j) = timeOfClassification;
        elseif i > 30
            [timeOfClassification] = toi(sprintf('%d_mv%d.ebr',i,j));
            toc(i,:,j) = timeOfClassification;
        end
    end
end