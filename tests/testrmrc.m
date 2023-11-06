
hold on
robot = Ned(eye(4));
robot.model.animate([0 0 0 0 0 0]);
%% 

xdot = [0 0 0 0 0 1];
k = 1;

x = k * xdot;
J = robot.model.jacob0(robot.model.getpos);
qdot =pinv(J)*x';
qNext = robot.model.getpos + (qdot'*0.1);
robot.model.animate(qNext);

