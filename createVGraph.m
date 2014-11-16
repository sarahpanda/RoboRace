function [finalPolygons V, E] = createVGraph(f, polygons, start, destination)
    
    finalPolygons = reduceIntersectingPolygons(polygons);
    %drawPolygons(f, finalPolygons, [0 1 0], '*' , 2);
    V = [];
    E = [];
    
    polyStart = zeros(length(finalPolygons) + 2, 1);
    polyStart(1) = 1;
    for p = 1:length(finalPolygons)
        polyStart(p+1) = polyStart(p) + size(finalPolygons{p}, 1) ;
        V = [V; finalPolygons{p}(:, 1), finalPolygons{p}(:, 2), ones(size(finalPolygons{p},1),1)*p];
    end
    polyStart(length(finalPolygons) + 2) = polyStart(length(finalPolygons) +1) + 1;
    V = [V; start(1) start(2) -1; destination(1) destination(2) -2];
    E = ones(size(V, 1), size(V, 1))*inf;
    
    %plot(V(:,1), V(:,2), 'o');

    l2 = [];
    l2i = [];
  
    for p = 2:length(finalPolygons)
        for v = polyStart(p):polyStart(p+1)-2
            x1 = V(v, 1);
            y1 = V(v, 2);
            x2 = V(v+1, 1);
            y2 = V(v+1, 2);
            l2 = [l2;x1 y1 x2 y2];%
            l2i = [l2i; v v+1];%
            distance = norm([x1-x2, y1-y2], 2);
            E(v, v+1) = distance;
            E(v+1, v) = distance; 
        end
        v = polyStart(p+1) - 1;
        x1 = V(v, 1);
        y1 = V(v, 2);
        x2 = V(polyStart(p), 1);
        y2 = V(polyStart(p), 2);
        l2 = [l2;x1 y1 x2 y2];%
        l2i = [l2i;v polyStart(p)];%
        distance = norm([x1-x2, y1-y2], 2);
        E(v, polyStart(p)) = distance;
        E(polyStart(p), v) = distance;        
    end
    
        
    for v = polyStart(1):polyStart(2)-2
        x1 = V(v, 1);
        y1 = V(v, 2);
        x2 = V(v+1, 1);
        y2 = V(v+1, 2);
        l2 = [l2;x1,y1, x2, y2];
        l2i = [l2i; v, v+1];
    end
    v = polyStart(2) - 1;
    x1 = V(v, 1);
    y1 = V(v, 2);
    x2 = V(polyStart(1), 1);
    y2 = V(polyStart(1), 2);
    l2 = [l2; x1, y1, x2, y2];
    l2i = [l2i; v, polyStart(1)];
    
    l1 = [];   
    l1i = [];

    
    for p = 2:length(finalPolygons)
        for v1 = polyStart(p):polyStart(p+1)-1
            x1 = V(v1, 1);
            y1 = V(v1, 2);
            for op=p+1:length(finalPolygons)
                for v2 = polyStart(op):polyStart(op+1)-1
                    x2 = V(v2, 1);
                    y2 = V(v2, 2);
                    l1 = [l1;x1 y1 x2 y2];
                    l1i = [l1i;v1 v2];
                end
            end
        end
    end
    
    
        
    for sd = size(V,1)-1:size(V,1)
        x1 = V(sd,1);
        y1 = V(sd,2);
    
        for p = 2:length(finalPolygons)
            for v1 = polyStart(p):polyStart(p+1)-1
                x2 = V(v1, 1);
                y2 = V(v1, 2);
                l1 = [l1; x1 y1 x2 y2];
                l1i = [l1i; sd, v1];
            end
        end
    end

    
    
    out = lineSegmentIntersect(l1, l2);
    intM = out.intAdjacencyMatrix;
    validLines = [];
    for i1 = 1:size(intM, 1)
        v11 = l1i(i1, 1);
        v12 = l1i(i1, 2);
        valid = 1;
        for i2 =1:size(intM, 2)
            v21 = l2i(i2, 1);
            v22 = l2i(i2, 2);
            if(intM(i1, i2) == 1)
                if(v11 == v21 || v11 == v22 || v12 == v21 || v12 == v22)
                else
                    valid = 0;
                    break;
                end
            end
        end
        if valid == 1
            p = l1(i1, :);
            distance = norm([p(1) - p(3), p(2) - p(4)], 2);
            E(v11, v12) = distance;
            E(v12, v11) = distance;
            validLines = [validLines; i1];
        end
    end
    
    drawLines(f, l1(validLines, :), [0 0 0], 1);
    

end
