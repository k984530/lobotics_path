% 시작점 및 초기 회전 행렬
start_points = [2, 1.8, 0; 2, 2.2, 0; 5, 2, 0];
R_init = eye(3);  % 초기 회전: 0도

% 목표 지점 및 목표 회전 행렬 설정
end_points = start_points + 6;
angle = 30 * pi / 180;
R_roll = [1, 0, 0; 0, cos(angle), -sin(angle); 0, sin(angle), cos(angle)];
R_pitch = [cos(angle), 0, sin(angle); 0, 1, 0; -sin(angle), 0, cos(angle)];
R_yaw = [cos(angle), -sin(angle), 0; sin(angle), cos(angle), 0; 0, 0, 1];
R_goal = R_yaw * R_pitch * R_roll;

% 장애물 위치 및 크기 설정
obstacle_center = mean([start_points(1,:); end_points(1,:)], 1) + [0, 1, 0];  % 초기지점과 목표지점 사이에 위치
obstacle_size = [5, 5, 5];

% Potential function parameters
K_att = 0.5;
K_rep = 100;
rho_0 = 2.0;
K_rot = 0.1;

% Visualization settings
figure;

% 3D View
subplot(2,2,1);
title('3D View');
xlabel('X'); ylabel('Y'); zlabel('Z');
hold on; grid on;
view(3);
axis([0 15 0 15 0 15]);

% XY Plane
subplot(2,2,2);
title('XY Plane');
xlabel('X'); ylabel('Y');
hold on; grid on;
axis([0 15 0 15]);

% XZ Plane
subplot(2,2,3);
title('XZ Plane');
xlabel('X'); ylabel('Z');
hold on; grid on;
axis([0 15 0 15]);

% YZ Plane
subplot(2,2,4);
title('YZ Plane');
xlabel('Y'); ylabel('Z');
hold on; grid on;
axis([0 15 0 15]);

% Main loop
current_points = start_points;
R_current = R_init;

threshold_position = 0.5; % 목표 지점에 가까워지면 조정 시작
refining_rate = 0.3;     % 변화량을 조절하는 비율

while norm(mean(current_points, 1) - mean(end_points, 1)) > 0.1 || norm(logm(R_current' * R_goal), 'fro') > 0.1
    rotated_end_points = (R_goal * (end_points - mean(end_points, 1))')' + mean(end_points, 1);
    F_total = zeros(size(current_points));
    for i = 1:3
        F_att = -K_att * (current_points(i,:) - end_points(i,:));
        r = norm(current_points(i,:) - obstacle_center);
        F_rep = zeros(1,3);
        if r < rho_0
            F_rep = K_rep * ((1./r - 1/rho_0) * (1./r.^3)) * (current_points(i,:) - obstacle_center);
        end
        F_total(i,:) = F_att + F_rep;
    end

    % 목표 지점에 가까워지면 변화량 조절
    if norm(mean(current_points, 1) - mean(end_points, 1)) < threshold_position
        F_total = F_total * refining_rate;
    end

    current_points = current_points + F_total * 0.01;

    % 회전 조절
    [cur_roll, cur_pitch, cur_yaw] = mat2RPY(R_current);
    [goal_roll, goal_pitch, goal_yaw] = mat2RPY(R_goal);

    delta_roll = goal_roll - cur_roll;
    delta_pitch = goal_pitch - cur_pitch;
    delta_yaw = goal_yaw - cur_yaw;

    % 목표 회전에 가까워지면 변화량 조절
    if rotationError(R_current, R_goal) < 0.1
        delta_roll = delta_roll * refining_rate;
        delta_pitch = delta_pitch * refining_rate;
        delta_yaw = delta_yaw * refining_rate;
    end

    R_current = R_current * eul2rotm([delta_yaw * 0.01, delta_pitch * 0.01, delta_roll * 0.01], 'ZYX');


    % Apply the rotation to the triangle vertices
    centroid = mean(current_points, 1);
    rotated_points = (R_current * (current_points - centroid)')' + centroid;

    % Visualization: Clear plots for current iteration
    for k=1:4
        subplot(2,2,k);
        cla;
    end


 % 3D visualization
subplot(2,2,1);
fill3(rotated_points(:,1), rotated_points(:,2), rotated_points(:,3), 'y');
fill3(start_points(:,1), start_points(:,2), start_points(:,3), 'b');
fill3(rotated_end_points(:,1), rotated_end_points(:,2), rotated_end_points(:,3), 'g');
drawObstacle(obstacle_center, obstacle_size);

    % XY Plane
subplot(2,2,2);
fill(rotated_points(:,1), rotated_points(:,2), 'y');
fill(start_points(:,1), start_points(:,2), 'b');
fill(rotated_end_points(:,1), rotated_end_points(:,2), 'g');
drawObstacle(obstacle_center, [obstacle_size(1), obstacle_size(2), 0]);

    % XZ Plane
subplot(2,2,3);
fill(rotated_points(:,1), rotated_points(:,3), 'y');
fill(start_points(:,1), start_points(:,3), 'b');
fill(rotated_end_points(:,1), rotated_end_points(:,3), 'g');
drawObstacle(obstacle_center, [obstacle_size(1), 0, obstacle_size(3)]);

    % YZ Plane
subplot(2,2,4);
fill(rotated_points(:,2), rotated_points(:,3), 'y');
fill(start_points(:,2), start_points(:,3), 'b');
fill(rotated_end_points(:,2), rotated_end_points(:,3), 'g');
drawObstacle(obstacle_center, [0, obstacle_size(2), obstacle_size(3)]);

    pause(0.01);
end

% Draw the obstacle
function drawObstacle(center, size)
    [x,y,z] = meshgrid([-size(1)/2, size(1)/2], [-size(2)/2, size(2)/2], [-size(3)/2, size(3)/2]);
    x = x + center(1);
    y = y + center(2);
    z = z + center(3);
    for i = 1:numel(x)
        plot3(x(i), y(i), z(i), 'ro');
    end
end

% Skew-symmetric function
function S = skew(v)
    S = [    0, -v(3),  v(2);
          v(3),     0, -v(1);
         -v(2),  v(1),     0];
end


% Calculate rotation error using matrix logarithm
function omega = rotationLogMap(R)
    rodrigues = logm(R);  % Compute the matrix logarithm
    omega = [rodrigues(3,2); rodrigues(1,3); rodrigues(2,1)];
end

% Extract roll, pitch, yaw angles from rotation matrix
function [roll, pitch, yaw] = mat2RPY(R)
    sy = sqrt(R(1,1) * R(1,1) +  R(2,1) * R(2,1));
    singular = sy < 1e-6;
    if ~singular
        roll = atan2(R(3,2), R(3,3));
        pitch = atan2(-R(3,1), sy);
        yaw = atan2(R(2,1), R(1,1));
    else
        roll = atan2(-R(2,3), R(2,2));
        pitch = atan2(-R(3,1), sy);
        yaw = 0;
    end
end

% Calculate the magnitude of the rotation error
function e_magnitude = rotationError(R_current, R_goal)
    [cur_roll, cur_pitch, cur_yaw] = mat2RPY(R_current);
    [goal_roll, goal_pitch, goal_yaw] = mat2RPY(R_goal);
    e_magnitude = sqrt((goal_roll - cur_roll)^2 + (goal_pitch - cur_pitch)^2 + (goal_yaw - cur_yaw)^2);
end