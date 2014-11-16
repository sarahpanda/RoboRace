function []=  drawLines(f, lines, colour, m)
    figure(f);
    for p = 1:size(lines,1)
        p1 = lines(p,:);
        line([p1(1) p1(3)],[p1(2) p1(4)], 'Color', colour, 'LineWidth', 1*m);%, 'Marker', marker);
        hold on;
    end
end
