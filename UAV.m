% UAV의 초기 위치와 방향을 설정합니다.
x = 0;
y = 0;
z = 10;

% 그래픽 핸들을 초기화합니다.
h = [];

% 그림을 그립니다.
figure;
hold on;
axis equal;
grid on;
xlim([-10, 20]);
ylim([-10, 10]);
zlim([0, 20]);
view(3); % 3D 뷰를 설정합니다.

% 시간에 따라 UAV를 움직입니다.
for t = 0:0.1:10 % 10초 동안 움직입니다.
    % UAV의 위치를 업데이트합니다.
    x = x + 0.1; % x축을 따라 천천히 전진합니다.
    
    % 이전의 UAV를 지웁니다.
    delete(h);
    
    % UAV의 전진 방향을 축으로 회전 변환 행렬을 계산합니다.
    angle = t; % 회전 각도를 시간에 따라 변화시킵니다.
    ux = 1; uy = 0; uz = 0; % UAV의 전진 방향을 회전 축으로 설정합니다.
    c = cos(angle);
    s = sin(angle);
    R = [c+ux^2*(1-c) ux*uy*(1-c)-uz*s ux*uz*(1-c)+uy*s;
         uy*ux*(1-c)+uz*s c+uy^2*(1-c) uy*uz*(1-c)-ux*s;
         uz*ux*(1-c)-uy*s uz*uy*(1-c)+ux*s c+uz^2*(1-c)];
    
    % x축 방향으로 2배 긴 이등변 삼각형의 꼭지점을 정의합니다.
    triangle = [2 0 0; -1 sqrt(3)/2 0; -1 -sqrt(3)/2 0]' * 0.5;
    
    % 변환 행렬을 적용합니다.
    transformed_triangle = R * triangle;
    transformed_triangle(1, :) = transformed_triangle(1, :) + x;
    transformed_triangle(2, :) = transformed_triangle(2, :) + y;
    transformed_triangle(3, :) = transformed_triangle(3, :) + z;
    
    % UAV를 그립니다.
    h = fill3(transformed_triangle(1, :), transformed_triangle(2, :), transformed_triangle(3, :), 'r');
    
    pause(0.1);
    % 그림을 갱신합니다.
    drawnow;
end
