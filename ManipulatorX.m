% 각 관절의 길이를 정의합니다. (마지막 조인트 길이 제거)
L = [1, 1, 1];

% 그래픽 핸들을 저장할 배열을 초기화합니다.
h = zeros(1, 3); % 3개의 링크만 있습니다.

% 그림을 그립니다.
figure;
hold on;
axis equal;
grid on;
xlim([-4, 4]);
ylim([-4, 4]);
zlim([0, 4]);
view(3); % 3D 뷰를 설정합니다.

% 시간에 따라 로봇을 움직입니다.
for t = 0:0.01:10 % 10초 동안 움직입니다.
    % 각 관절의 각도를 정의합니다. (마지막 조인트 각도 제거)
    theta = [sin(t), sin(2*t), sin(3*t)];
    
    % 이전의 링크들을 지웁니다.
    delete(h(h~=0));
    
    % 로봇의 링크를 그립니다.
    for i = 1:3 % 3개의 링크만 있습니다.
        if i == 1
            % 첫 번째 링크의 시작점은 원점입니다.
            start = [0, 0, 0];
            R = makehgtform('zrotate', theta(i));
        else
            % 그 외의 링크의 시작점은 이전 링크의 끝점입니다.
            start = endP;
            R = makehgtform('xrotate', theta(i));
        end
        
        % 링크의 끝점을 계산합니다.
        endP = start + (R(1:3, 1:3) * [0; 0; L(i)])'; 
        
        % 링크를 그립니다.
        h(i) = plot3([start(1), endP(1)], [start(2), endP(2)], [start(3), endP(3)], 'k', 'LineWidth', 2);
    end
    
    
    % 그림을 갱신합니다.
    drawnow;
    pause(0.05);
end

% 회전 행렬을 만드는 함수를 정의합니다.
function T = makehgtform(varargin)
    T = eye(4);
    
    if nargin > 0
        for i = 1:length(varargin)
            if strcmp(varargin{i}, 'xrotate')
                ang = varargin{i+1};
                Rx = [1 0 0 0; 0 cos(ang) -sin(ang) 0; 0 sin(ang) cos(ang) 0; 0 0 0 1];
                T = T * Rx;
            elseif strcmp(varargin{i}, 'zrotate')
                ang = varargin{i+1};
                Rz = [cos(ang) -sin(ang) 0 0; sin(ang) cos(ang) 0 0; 0 0 1 0; 0 0 0 1];
                T = T * Rz;
            end
        end
    end
end
