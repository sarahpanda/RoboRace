function cleanedVertices = createVGraph(vertices)

deleted = [];

sets = {};

% discard vertices within polygons
for k = 2:size(vertices,2)
  thisPolygon = vertices{k};
  
  for i = 2:size(vertices,2)
      if i == k
          continue;
      end
      otherVertices = vertices{i};
      
      for j = size(otherVertices,1):-1:1
          if inpoly(otherVertices(j,1), otherVertices(j,2), thisPolygon(:,1), thisPolygon(:,2))~=0
             deleted = [deleted; otherVertices(j,:)];
             otherVertices(j,:)=[];
             
             
             % combine the overlapping polygons
             
             no_intersection_yet = 1;
             
             for m = 1:length(sets)
                 this_set = [k,i];
                 if size(intersect(this_set, sets{m})) ~= 0
                   united_sets = union(this_set, sets{m});
                   sets{m} = united_sets;
                   no_intersection_yet = 0;
                 end
             end
             
             if no_intersection_yet == 1
                 sets{length(sets)+1} = [k,i];
             end
          end
          
      end
      vertices{i} = otherVertices;
  end
  
end

cleanedVertices = vertices;

finalVertices = [];
setOfPolygonsIncluded = [];
for i = 1:length(sets)
  allvertices = [];
  for j = 1:size(sets{i},2)
      for k = 1:size(cleanedVertices{sets{i}(j)},1)
          allvertices = [allvertices; cleanedVertices{sets{i}(j)}(k,:)];
      end     
  end
  allverticesIdx = convhull(allvertices(:,1), allvertices(:,2));
  finalVertices{length(finalVertices)+1} = allvertices(allverticesIdx, :);
  setOfPolygonsIncluded = union(setOfPolygonsIncluded, sets{i});
end
allPoly = 1:length(vertices)
nonIntersectingPolygons = setdiff(allPoly, setOfPolygonsIncluded);

for i = 1:size(nonIntersectingPolygons,2)
    finalVertices{length(finalVertices)+1} = cleanedVertices{i};
end

% plot the new polygons
f = figure;
for i = 1:length(finalVertices)
   for j = 1:size(finalVertices{i},1)
       p1 = finalVertices{i}(j,:);
       if j ~= size(finalVertices{i},1)
           p2 = finalVertices{i}(j+1,:);
       else 
           p2 = finalVertices{i}(1,:);
       end
       line([p1(1) p2(1)],[p1(2) p2(2)], 'Color', [1, 0, 0], 'Marker', 'o');
       hold on;
   end
end
end