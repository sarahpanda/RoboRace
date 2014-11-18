function moveRobot(serPort)
    % move roomba from start to end
    load('path.mat');
    
    angVelocity = 0.1;
    fwdVelocity = 0.1;
    
    current_pos = 1;
    current_orientation = pi/2;
    
    coords = [pathC(1,1) pathC(1,2) current_orientation];      %create a vecot with x, y, angle coordinates
    
    f1 = figure();
    axis([-10 10 -10 10]);
    axis equal;
    
    for i = 1:size(pathC,1)
        plot(pathC(i,1), pathC(i,2), 'rX');
        axis equal;
        hold on;
    end
        
    
    for i = 1:size(pathC,1)-1
        next_pos = current_pos + 1
        
        angleToRotate = atan2(pathC(next_pos,2) - pathC(current_pos,2), pathC(next_pos,1) - pathC(current_pos,1)) -  current_orientation
        
        SetFwdVelAngVelCreate(serPort, 0, angVelocity*sign(angleToRotate));
        pause(0.01);
        
        angle = 0;
        
        while abs(angle) < abs(angleToRotate)
            a2 = AngleSensorRoomba(serPort);
            coords(3) = coords(3) + a2;
                    
            angle = angle + a2;
            pause(0.01);
        end
        
        
        SetFwdVelAngVelCreate(serPort, 0, 0);
        pause(0.01);
        
        % move straight towards the distances
        total_dist = norm(pathC(next_pos,1:2) - pathC(current_pos,1:2),2)
        
        
        fprintf('Rotated by %d\n', angle*180/pi);
        
        SetFwdVelAngVelCreate(serPort, fwdVelocity, 0);
        pause(0.01);
        
        dist = 0;
        
        
        while abs(dist) < abs(total_dist)
            dist_moved = DistanceSensorRoomba(serPort);
            dist = dist + dist_moved;
            coords = coords + [(dist_moved*cos(coords(3))) (dist_moved*sin(coords(3))) 0];
            axis equal;
            plot(coords(1), coords(2), 'b-');
            hold on;
            pause(0.01);
        end
        
        SetFwdVelAngVelCreate(serPort, 0, 0);
        pause(0.01);
        fprintf('Moved forward by %d\n', dist);
        current_pos = current_pos+1;
        current_orientation = current_orientation + angleToRotate;
        axis equal;
        plot(pathC(next_pos,1), pathC(next_pos,2), 'gX');
        hold on;
    end
    
    SetFwdVelAngVelCreate(serPort, 0, 0);
    pause(0.01);
end