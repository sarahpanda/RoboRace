function [] = roboRace()

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
    drawPolygons(f, obstacles, [0 0 1], 'x');
    r = radius;


    % Grow the obstacle
    grown_obstacles = {};
    
    for i = 2:length(obstacles)
        points = [];
        for k = 1:size(obstacles{i},1)
            vx = obstacles{i}(k,1);
            vy = obstacles{i}(k,2);
            points = [points; [vx+r, vy+r]; [vx-r, vy+r]; [vx-r,vy-r]; [vx+r,vy-r]];
        end
        hull = convhull(points(:,1), points(:,2));
        hull = hull(1:size(hull)-1);

        convex_hull = [points(hull,1), points(hull,2)];
        grown_obstacles{i-1} = convex_hull;

    end
    drawPolygons(f, grown_obstacles, [1 0 0], 'o');
    cleanPolygons = createVGraph(grown_obstacles);
    drawPolygons(f, cleanPolygons, [0 1 0], 'o');
    
end
