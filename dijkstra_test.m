clear;

VertexMatrix = [0 0; 6 6; 1 3; 2 2]; 
DistanceMatrix = [inf inf 5 6; inf inf 7 inf; 5 7 inf 4; 6 inf 4 inf];

noOfNodes  = size(VertexMatrix, 1); %count number of nodes
rand('state', 0);
figure(1);
clf;
hold on;
netXloc = VertexMatrix(:, 1);
netYloc = VertexMatrix(:, 2); 

for i = 1:noOfNodes
    plot(netXloc(i), netYloc(i), '.');
    text(netXloc(i), netYloc(i), num2str(i));
    for j = 1:noOfNodes
      if DistanceMatrix(i,j) == inf
        continue;
      end
      line([netXloc(i) netXloc(j)], [netYloc(i) netYloc(j)], 'LineStyle', ':');
      hold on;       
    end;
end;


activeNodes = [];
for i = 1:noOfNodes,
    % initialize the farthest node to be itself;
    farthestPreviousHop(i) = i;     % used to compute the RTS/CTS range;
    farthestNextHop(i) = i;
end;

[path, totalCost, farthestPreviousHop, farthestNextHop] = dijkstra(noOfNodes, DistanceMatrix, noOfNodes-1, noOfNodes, farthestPreviousHop, farthestNextHop); %pass to Dijkstra (number of nodes, DistanceMatrix, Start node, Final node, ..., ...)
path
totalCost
if length(path) ~= 0
    for i = 1:(length(path)-1)
        line([netXloc(path(i)) netXloc(path(i+1))], [netYloc(path(i)) netYloc(path(i+1))], 'Color','r','LineWidth', 0.50, 'LineStyle', '-.');
    end;
end;
hold off;
return;
