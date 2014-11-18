function median = medianObstacle(rotated)
    imshow(rotated);
    hold on;

    r = find(abs(double(rotated(:,:,1)) - 142) < 35);
    g = find(abs(double(rotated(:,:,2)) - 31) < 35);
    b = find(abs(double(rotated(:,:,3)) - 12) < 35);

    i = intersect(intersect(r,g),b);
    [x y] = ind2sub([size(rotated,1), size(rotated,2)], i);
    plot(y,x, 'bX');
    hold on;

    median = sum([x,y])/size(x,1); 
end

