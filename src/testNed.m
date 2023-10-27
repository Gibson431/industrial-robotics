clear 
close all
clc
hold on
robot = Ned(eye(4));
flats = PlaceObject("2_Flats.ply",[1.5,0.3,0]);
robot.model.teach();
% while true
%     robot.doStep();
% end