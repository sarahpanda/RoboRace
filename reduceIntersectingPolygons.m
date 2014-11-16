function finalPolygons = reduceIntersectingPolygons(polygons)
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
                    hull = convhull(xx, yy, 'simplify', true);
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
    
    finalPolygons = {};
    finalPolygons{1} = polygons{1};
    for p = 1:length(currentPolygons)
        finalPolygons{p+1} = currentPolygons{p};
    end
end
