function [V, E] = createVGraph(polygons)

    cleanPolygons = {};
    cleanPolygons{1} = polygons{1};
    V = [];
    % discard polygons within polygons
    for p =2:length(polygons)
        thisPolygon = polygons{p};
        newPoly = [];
        
        for v = 1:size(thisPolygon,1)
            x = thisPolygon(v, 1);
            y = thisPolygon(v, 2);
            insidePoly = 0;
            for op=2:length(polygons)
                if op == p
                    continue;
                end
                if inpoly(x, y, polygons{op}(:, 1), polygons{op}(:, 2)) == 1 || inpoly(x, y, polygons{1}(:,1), polygons{1}(:,2)) == 0
                    insidePoly = 1;
                    break;
                end
            end
            if insidePoly == 0
                newPoly  = [newPoly; x, y];
            end
        end
        cleanPolygons{p} = newPoly;
        V = [V; newPoly];
    end    
    E = ones(size(V, 1) ,size(V, 1))*inf;
    
end
