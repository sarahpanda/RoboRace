function cleanPolygons = createVGraph(polygons)

    cleanPolygons = {};

    % discard polygons within polygons
    for p =1:length(polygons)
        thisPolygon = polygons{p};
        newPoly = [];
        
        for v = 1:size(thisPolygon,1)
            x = thisPolygon(v, 1);
            y = thisPolygon(v, 2);
            insidePoly = 0;
            for op=1:size(polygons, 1)
                if op == p
                    continue;
                end
                if inpoly(x, y, polygons{op}(:, 1), polygons{op}(:, 2)) == 1
                    insidePoly = 1;
                    break;
                end
            end
            if insidePoly == 0
                newPoly  = [newPoly; x, y];
            end
        end
        cleanPolygons{p} = newPoly;
    end
    length(cleanPolygons)
    
end
