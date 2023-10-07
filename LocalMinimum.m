% 환경 설정
close all; clear; clc;

% 화면 크기 설정
figure;
axis([0 100 0 100]); % x와 y 축 범위 설정
hold on;

% 초기 위치 및 목표 위치 설정
start_pos = [10 50];
end_pos = [90 50];

% 장애물 위치 설정
obstacle_pos = [40 58; 40 42; 50 50];
obstacle_radius = 3;

% 원 그리기
plot(start_pos(1), start_pos(2), 'ro', 'MarkerSize', 5, 'LineWidth', 2);
plot(end_pos(1), end_pos(2), 'bo', 'MarkerSize', 5, 'LineWidth', 2);

% 장애물 그리기
for i=1:3
    rectangle('Position', [obstacle_pos(i,1)-obstacle_radius, obstacle_pos(i,2)-obstacle_radius, obstacle_radius*2, obstacle_radius*2], ...
              'Curvature', [1 1], 'FaceColor', 'g');
end

% 플레이어 움직임 설정
player_pos = start_pos;
player_radius = 1;

player_h = plot(player_pos(1), player_pos(2), 'ko', 'MarkerSize', player_radius*10, 'LineWidth', 2);

% 플레이어 움직이기
step_size = 0.5;
while sqrt(sum((player_pos-end_pos).^2)) > step_size
    % 장애물에 닿으면 멈추기
    for i=1:3
        if sqrt(sum((player_pos-obstacle_pos(i,:)).^2)) <= (player_radius+obstacle_radius)
            break;
        end
    end
    
    % 다음 위치 계산
    dir = (end_pos - player_pos) / sqrt(sum((end_pos - player_pos).^2));
    player_pos = player_pos + dir * step_size;

    % 그래픽 업데이트
    set(player_h, 'XData', player_pos(1), 'YData', player_pos(2));
    drawnow;
    pause(0.1)
end
