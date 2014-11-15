function []=  drawPolygons(f, polygons, colour, marker, start)
    figure(f);
    for p = start:length(polygons)
        polygon = polygons{p};
        
        for k = 1:size(polygon,1)-1
            p1 = polygon(k,:);
            p2 = polygon(k+1,:);

            line([p1(1) p2(1)],[p1(2) p2(2)], 'Color', colour);%, 'Marker', marker);
            hold on;
        end
        if size(polygon,1) > 0
            p1 = polygon(size(polygon,1),:);
            p2 = polygon(1,:);
            line([p1(1) p2(1)],[p1(2) p2(2)], 'Color', colour);%, 'Marker', marker);
            hold on;
        end
    end
end
