function [finalPolygons V, E] = roboRace()
    clear all, close all, clc;
    radius = 0.2;
    mapFile = 'map.txt';
    
    f = figure();
    
    startPt = [0.58 -3.107];
    endPt = [-0.03 10.657];

    plot(startPt(1), startPt(2),'gx');
    hold on;
    plot(endPt(1), endPt(2), 'rx');
    hold on;

    % read coordinates
    [x,y,zero] = textread(mapFile);

    totalObs= x(1);
    curr_obs = 1;
    pointer = 1;
    obstacles = {};

    for i = 1:totalObs
        vertex_beg = pointer+1;
        vertices_cnt = x(vertex_beg);

        this_obstacle = [x(vertex_beg+1:vertex_beg+vertices_cnt) y(vertex_beg+1:vertex_beg+vertices_cnt)];

        obstacles{i} = this_obstacle;

        % update counters 
        curr_obs  = curr_obs + 1;
        pointer = pointer + vertices_cnt+1;
    end
    drawPolygons(f, obstacles, [0 0 1], 'x', 1);
    r = radius;

    % Grow the obstacle
    grown_obstacles = {};
    grown_obstacles{1} = obstacles{1};
    
    for i = 2:length(obstacles)
        points = [];
        for k = 1:size(obstacles{i},1)
            vx = obstacles{i}(k,1);
            vy = obstacles{i}(k,2);
            points = [points; [vx+r, vy+r]; [vx-r, vy+r]; [vx-r,vy-r]; [vx+r,vy-r]];
        end
        hull = convhull(points(:,1), points(:,2), 'simplify', true);
        hull = hull(1:size(hull)-1);

        convex_hull = [points(hull,1), points(hull,2)];
        grown_obstacles{i} = convex_hull;

    end
    drawPolygons(f, grown_obstacles, [1 0 0], 'o', 2);
    [finalPolygons V, E] = createVGraph(f, grown_obstacles, startPt, endPt);
    figure(f);
    axis equal;
    
    noOfNodes = size(V, 1);
    for i = 1:noOfNodes,
        % initialize the farthest node to be itself;
        farthestPreviousHop(i) = i;     % used to compute the RTS/CTS range;
        farthestNextHop(i) = i;
    end

    [path, totalCost, farthestPreviousHop, farthestNextHop] = dijkstra(noOfNodes, E, noOfNodes-1, noOfNodes, farthestPreviousHop, farthestNextHop);
    pathC = V(path, :);
    lines = [];
    for i = 1:size(pathC, 1)- 1
        x1 = pathC(i, 1);
        y1 = pathC(i, 2);
        x2 = pathC(i+1, 1);
        y2 = pathC(i+1, 2);
        lines = [lines; x1 y1 x2 y2];
    end
    drawLines(f, lines, [0 1 0], 3);   
    
    
end
