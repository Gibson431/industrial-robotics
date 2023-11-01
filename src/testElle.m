close all
clear
clc
hold on
% flats = PlaceObject("2_Flats.ply",[1.5,0.3,0]);
robot = Elle(eye(4));
% robot.model.teach();
while true
    robot.doStep();
    pause(0.2);
end


% % Check if the emergency stop button is pressed
% if emergency.StopButton1
%     disp('Emergency Stop button is pressed. Elle should stop.');
%     elleRobot.stop(); % Implement Elle's stop method
% else
%     disp('Emergency Stop button is not pressed. Elle continues operation.');
%     elleRobot.performActions(); % Replace with your Elle's action method
% end


%% guesses
%initial offset
%    -1.5080   -0.2513   -1.2566   -1.7593    1.5080         0
%    -1.1310   -0.2513   -1.1310   -1.7593    1.5080         0
%    -0.8796   -0.2513   -1.1310   -1.7593    1.5080         0
%    -0.7540   -0.2513   -1.1310   -1.7593    1.5080         0

% start pos guess
%     2.0106   -0.7540    2.0106   -1.2566    2.0106         0 ->1.5
%     1.5080   -1.0053    2.3876   -1.3823    1.5080         0
%     1.1310   -1.0053    2.3876   -1.3823    1.2566         0
%     0.5027   -1.0053    2.3876   -1.3823    0.5027         0 ->1

% above tray guess
%    -1.6336   -1.2566    1.2566   -1.5080   -1.5080         0

% end pos guesses
%    -2.2619   -1.2566    2.2619   -2.6389   -1.5080         0 %end nearby
%    -2.2619   -1.2566    2.2619   -2.6389   -1.5080         0 %end nearby
%    -2.2619   -1.0053    2.0106   -2.6389   -1.5080         0 %end far
%    -2.2619   -1.0053    2.0106   -2.6389   -1.5080         0 %end far