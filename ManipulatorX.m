% Robotics System Toolbox에서 로봇 모델 생성
robot = robotics.RigidBodyTree;

% 로봇 팔 링크 길이 정의
L1 = 1; % 첫 번째 링크 길이 (단위: 미터)
L2 = 1; % 두 번째 링크 길이 (단위: 미터)
L3 = 1; % 세 번째 링크 길이 (단위: 미터)

% 로봇 링크 생성
body1 = robotics.RigidBody('link1');
jnt1 = robotics.Joint('jnt1', 'revolute');
tform1 = trvec2tform([0, 0, 0]);
setFixedTransform(jnt1, tform1);
body1.Joint = jnt1;

body2 = robotics.RigidBody('link2');
jnt2 = robotics.Joint('jnt2', 'revolute');
tform2 = trvec2tform([L1, 0, 0]);
setFixedTransform(jnt2, tform2);
body2.Joint = jnt2;

body3 = robotics.RigidBody('link3');
jnt3 = robotics.Joint('jnt3', 'revolute');
tform3 = trvec2tform([L2, 0, 0]);
setFixedTransform(jnt3, tform3);
body3.Joint = jnt3;

% 로봇 링크 연결
addBody(robot, body1, 'base');
addBody(robot, body2, 'link1');
addBody(robot, body3, 'link2');

% 홈 구성
showdetails(robot);

% 관절 각도 설정 (라디안)
q1 = 0.2;
q2 = 0.3;
q3 = 0.4;

% 로봇 팔 각 관절에 각각 각도 설정
jointConfigs = homeConfiguration(robot);
jointNames = {'jnt1', 'jnt2', 'jnt3'};

for i = 1:numel(jointNames)
    jointIdx = findJointIdx(robot, jointNames{i});
    jointConfigs(jointIdx).JointPosition = eval(['q', num2str(i)]);
end

% 로봇 팔 그리기
figure;
show(robot, jointConfigs, 'PreservePlot', false);
title('3차원 Three-Link 로봇 팔');

% 뷰 설정 (원하는 각도 및 스케일로 설정)
view([45, 30]);
axis([-1.5, 1.5, -1.5, 1.5, -1.5, 1.5]); % 좌표축 범위 설정
