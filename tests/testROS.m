close all
clear
clc
robot = Ned();
robot.controller = TM5Controller;
robot.hasROS = true;
robot.controller.Connect('localhost');
robot.controller.SetGoal(5,[0 0 0 0 0 0], 1);
robot.controller.doGoal();
while true
    robot.doStep();
    pause(2);
end