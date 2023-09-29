% 두 링크 로봇 팔의 길이 설정
L1 = 1; % 첫 번째 링크 길이 (단위: 미터)
L2 = 1; % 두 번째 링크 길이 (단위: 미터)

% 시작 위치와 목표 위치 설정 (x, y 좌표)
start_x = 0;
start_y = 0;
target_x = 1;
target_y = 1;

% 이동 간격 설정 (단위: 미터)
step_size = 0.01;

% 이동 속도 설정 (단위: 라디안)
angular_velocity = 0.1; % 라디안/초

% 시작 위치에서 목표 위치까지 선형 보간
distance = norm([target_x - start_x, target_y - start_y]);
num_steps = ceil(distance / step_size);

% 초기 figure 생성
figure;
axis([-2 2 -2 2]); % 축 범위 설정
xlabel('X 좌표 (미터)');
ylabel('Y 좌표 (미터)');
title('두 링크 로봇 팔');

hold on;

for t = 1:num_steps
    % 현재 위치 보간
    current_x = start_x + (target_x - start_x) * (t - 1) / (num_steps - 1);
    current_y = start_y + (target_y - start_y) * (t - 1) / (num_steps - 1);
    
    % 역기구학 (Inverse Kinematics) 계산
    theta2 = acos((current_x^2 + current_y^2 - L1^2 - L2^2) / (2 * L1 * L2));
    theta1 = atan2(current_y, current_x) - atan2((L2 * sin(theta2)), (L1 + L2 * cos(theta2)));
    
    % 로봇 팔 그리기
    if t > 1
        % 이전 팔 위치 삭제
        delete(arm_plot);
    end
    arm_plot = plot([0, L1 * cos(theta1), current_x], [0, L1 * sin(theta1), current_y], 'bo-', 'LineWidth', 2);
    axis equal;
    
    % 관절 위치 표시
    plot(0, 0, 'ro', 'MarkerSize', 10);
    legend('로봇 팔', '관절 1', '현재 위치', 'Location', 'Best');
    
    % 잠시 기다리기 (로봇 팔을 보기 위해)
    pause(0.1);
end

hold off;
