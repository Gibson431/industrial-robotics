close all
clear 
clc
hold on
flats = PlaceObject("2_Flats.ply",[1.5,0.3,0]);
robot = Elle(eye(4));
robot.model.teach();
% while true
%     robot.doStep();
% end