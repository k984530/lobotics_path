% 초기 위치 및 목표 위치 설정
start_points_initial = [0, 0; 2, 0; 2, 1];
start_points = start_points_initial;  % 이동할 시작지점 복사
target_points = [8, 8; 8, 10; 7, 10];

% 이동 상수
alpha = 0.01; % 천천히 이동하도록 상수 값을 작게 설정

% 종료 기준
threshold = 0.01;

figure;
axis([0 8 0 10]); % [0,0], [10,10] 캔버스 설정
xlabel('X');
ylabel('Y');
title('Movement of Triangle Points using Potential Function');
grid on;
hold on;

% 시작지점과 목표지점 표기
for i = 1:3
    plot(start_points_initial(i, 1), start_points_initial(i, 2), 'ro');
    text(start_points_initial(i, 1), start_points_initial(i, 2), sprintf('Start %d', i), 'VerticalAlignment', 'bottom');
end

for i = 1:3
    plot(target_points(i, 1), target_points(i, 2), 'go');
    text(target_points(i, 1), target_points(i, 2), sprintf('Target %d', i), 'VerticalAlignment', 'bottom');
end

while true
    max_distance = 0; % 각 꼭지점과 목표 위치 사이의 최대 거리를 추적
    
    for i = 1:3
        % 어트랙티브 포텐셜 계산
        attractive_force = alpha * (target_points(i, :) - start_points(i, :));
        
        % 위치 업데이트
        start_points(i, :) = start_points(i, :) + attractive_force;
        
        % 거리 계산
        distance = norm(target_points(i, :) - start_points(i, :));
        max_distance = max(max_distance, distance);
    end
    
    % 현재 축 내용 지우기
    cla;
    
    % 시작지점 표기를 반복적으로 유지
    for i = 1:3
        plot(start_points_initial(i, 1), start_points_initial(i, 2), 'ro');
    end
    
    for i = 1:3
        plot(target_points(i, 1), target_points(i, 2), 'go');
    end
    
    % 현재 삼각형 그리기
    fill(start_points(:,1), start_points(:,2), 'r');
    pause(0.1); % 천천히 이동하도록 지연 추가
    
    % 종료 기준 검사
    if max_distance < threshold
        break;
    end
end

% 최종 목표 위치 그리기
fill(target_points(:,1), target_points(:,2), 'g');
