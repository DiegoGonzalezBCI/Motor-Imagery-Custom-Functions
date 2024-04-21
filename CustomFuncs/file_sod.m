csod = cell(60,4,2);
for i = 1:60
    for j = 1:2
        if i <= 30
            [segmentatedData] = sod(sprintf('%d_je%d.ebr',i,j));
            csod(i,:,j) = segmentatedData;
        elseif i > 30
            [segmentatedData] = sod(sprintf('%d_me%d.ebr',i,j));
            csod(i,:,j) = segmentatedData;
        end
    end
end