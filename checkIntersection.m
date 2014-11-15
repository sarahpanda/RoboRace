function int = checkIntersection(p1, p2)
    int = 0;
    for v =1:size(p1, 1)
        x = p1(v, 1);
        y = p1(v, 2);
        if (inpoly(x, y, p2(:,1), p2(:,2)) ~= 0)
            int = 1;
            break;
        end
    end
end
