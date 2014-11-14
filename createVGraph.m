function cleanedVertices = createVGraph(vertices)

deleted = [];

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
          end
          
      end
      vertices{i} = otherVertices;
  end
  
end
cleanedVertices = vertices;
end