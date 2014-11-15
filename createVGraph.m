function [V, E] = createVGraph(f, polygons, start, destination)

    currentPolygons ={};
    for p = 2:length(polygons)
        currentPolygons{p-1} = polygons{p};
    end
    newPolygons = {};
    done = 0;
    iter = 1;
    
    while done == 0
        n = 1;
        done = 1;
        included = zeros(length(currentPolygons));
        for p = 1:length(currentPolygons)
            p1 = currentPolygons{p};
            foundInt = 0;
            for op = p+1:length(currentPolygons)
                p2 = currentPolygons{op};
                if checkIntersection(p1, p2) == 1
                    included(p) = 1;
                    included(op) = 1;
                    xx = [p1(:,1);p2(:,1)];
                    yy = [p1(:,2); p2(:,2)];
                    hull = convhull(xx, yy);
                    hull = hull(1:size(hull)-1);
                    convex_hull = [xx(hull), yy(hull)];
                    newPolygons{n} = convex_hull;
                    n = n+ 1;
                    done = 0;                 
                    break;
                end                
            end
            if included(p) == 0
                newPolygons{n} = currentPolygons{p};
                n = n+1;
            end
        end
        
        iter = iter+1;        
        currentPolygons = newPolygons;
        newPolygons = {};
    end
    drawPolygons(f, currentPolygons, [0 1 0], '*', 1);
    
    finalPolygons = {}
    finalPolygons{1} = polygons{1};
    for p = 1:length(currentPolygons)
        finalPolygons{p+1} = currentPolygons{p};
    end
    
    xy2 = [];
    V = [];
    for p = 2:length(finalPolygons)
        polygon = finalPolygons{p};
        for v = 1:size(polygon, 1)
            V = [V; polygon(v,:)];
        end
    end
    
    V=[V;start; destination];
    nodes = size(V, 1);
    
    for p =1:length(finalPolygons)
        polygon = finalPolygons{p};
        for v=1:size(polygon, 1)-1
            x1 = polygon(v, 1);
            y1 = polygon(v, 2);
            x2 = polygon(v+1, 1);
            y2 = polygon(v+1, 2);
            
            xy2 = [xy2;x1 y1 x2 y2];
        end
        x1 = polygon(size(polygon, 1), 1);
        y1 = polygon(size(polygon, 1), 2);
        x2 = polygon(1, 1);
        y2 = polygon(1, 2);
        xy2 = [xy2;x1 y1 x2 y2];       
    end
    E = ones(nodes ,nodes)*inf;
    
    
    
    
end
