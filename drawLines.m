function []=  drawLines(f, lines, colour, marker)
    figure(f);
    size(lines)
    for p = 1:size(lines,1)
        p1 = lines(p,:);
        line([p1(1) p1(3)],[p1(2) p1(4)], 'Color', colour);%, 'Marker', marker);
        hold on;
    end
end
