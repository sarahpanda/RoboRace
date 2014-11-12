function obstacles = roboRace()

% read coordinates

[x,y,zero] = textread('map.txt');
totalObs= x(1);
curr_obs = 1;
pointer = 1;
obstacles = [];

radius = 0.2;

f = figure();

for i = 1:totalObs
    vertex_beg = pointer+1;
    vertices_cnt = x(vertex_beg);
    
    this_obstacle = [x(vertex_beg+1:vertex_beg+vertices_cnt) y(vertex_beg+1:vertex_beg+vertices_cnt)];
    
    obs = repmat(curr_obs,vertices_cnt,1);
    obstacles = [obstacles; obs, this_obstacle];
    
    for j = 1:vertices_cnt-1
       line([this_obstacle(j,1),this_obstacle(j+1,1)], [this_obstacle(j,2),this_obstacle(j+1,2)]);
       hold on;
    end
    line([this_obstacle(vertices_cnt,1),this_obstacle(1,1)], [this_obstacle(vertices_cnt,2),this_obstacle(1,2)]);
    hold on;
    
    % update counters 
    curr_obs  = curr_obs + 1;
    pointer = pointer + vertices_cnt+1;
end

r = radius;

% Grow the obstacle
for i = 1:totalObs
  if i == 1
      continue;
  end
  
  indices = find(obstacles(:,1) == i);
  points = [];
  for k = 1:size(indices,1)
    vx = obstacles(indices(k),2);
    vy = obstacles(indices(k),3);
    points = [points; [vx+r, vy+r]; [vx-r, vy+r]; [vx-r,vy-r]; [vx+r,vy-r]];
  end
  
  hull = convhull(points(:,1), points(:,2));
  
  for k = 1:size(hull,1)-1
      p1 = points(hull(k),:);
      p2 = points(hull(k+1),:);
      
      line([p1(1) p2(1)],[p1(2) p2(2)], 'Color', [1, 0, 0]);
      hold on;
  end
  p1 = points(hull(size(hull,1)),:);
  p2 = points(hull(1),:);
  line([p1(1) p2(1)],[p1(2) p2(2)], 'Color', [1, 0, 0]);
  hold on;
  
end


end