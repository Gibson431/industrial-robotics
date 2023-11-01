close all
clear
clc
hold on
% Create an instance of the Elle class (assuming you have Elle class defined)
robot = Elle(eye(4));
% robot.model.teach();
while true
    robot.doStep();
end

% Create an instance of the eStop class
emergency = eStop();


% Check if the emergency stop button is pressed
if emergency.StopButton1
    disp('Emergency Stop button is pressed. Elle should stop.');
    elleRobot.stop(); % Implement Elle's stop method
else
    disp('Emergency Stop button is not pressed. Elle continues operation.');
    elleRobot.performActions(); % Replace with your Elle's action method
end


% Clean up and release resources
clear elleRobot;
clear eStop;