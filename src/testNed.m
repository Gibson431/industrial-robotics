clear 
close all
clc
robot = Ned(eye(4));
while true
    robot.doStep();
end