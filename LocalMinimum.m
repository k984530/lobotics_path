% 초기 설정
start_point = [5, 50];
goal_point = [95, 50];
map_size = [100, 100];

% 세 개의 장애물 설정
obstacle_centers = [50, 40; 70, 50; 50, 60];
obstacle_radius = 12;

% Potential field 생성
[X, Y] = meshgrid(1:map_size(1), 1:map_size(2));
attractive_potential = sqrt((X-goal_point(1)).^2 + (Y-goal_point(2)).^2);
repulsive_potential = zeros(map_size);

for i = 1:size(obstacle_centers, 1)
    repulsive_field = (obstacle_radius^3) ./ ((X-obstacle_centers(i, 1)).^2 + (Y-obstacle_centers(i, 2)).^2) - obstacle_radius^2;
    repulsive_field(repulsive_field > 1) = 0;
    repulsive_field(repulsive_field < -obstacle_radius^2) = -obstacle_radius^2; % 장애물 내부를 고려
    repulsive_potential = repulsive_potential + repulsive_field;
end

potential_field = attractive_potential - repulsive_potential;

% Potential field 표시
figure;
imagesc(potential_field);
colormap('jet');
hold on;
h_start = plot(start_point(1), start_point(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
h_goal = plot(goal_point(1), goal_point(2), 'go', 'MarkerSize', 10, 'LineWidth', 2);
h_path = plot(start_point(1), start_point(2), 'b.-'); % 초기 경로
axis equal;

% 로봇의 움직임 시뮬레이션
current_point = start_point;
path = [current_point];
while norm(current_point - goal_point) > 1
    [dx, dy] = gradient(-potential_field); % 경사 상승 방향으로 움직임
    current_dir = [dx(current_point(2), current_point(1)), dy(current_point(2), current_point(1))];
    
    % 새로운 위치 계산 및 반올림
    current_point = round(current_point + current_dir);
    
    % 배열 범위를 벗어나는지 확인
    if current_point(1) < 1 || current_point(1) > map_size(1) || current_point(2) < 1 || current_point(2) > map_size(2)
        break;
    end
    
    % 경로 업데이트 및 시각화
    path = [path; current_point];
    set(h_path, 'XData', path(:,1), 'YData', path(:,2));
    
    % 약간의 지연을 줘서 실시간으로 움직임 관찰
    pause(0.05);
end
