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

%% guesses

% end pos guesses
%    -2.2619   -1.2566    2.2619   -2.6389   -1.5080         0 %end nearby 
%    -2.2619   -1.0053    2.0106   -2.6389   -1.5080         0 %end far
%    
% start pos guess 
%     2.0106   -0.7540    2.0106   -1.2566    2.0106         0 ->1.5
%     1.5080   -1.0053    2.3876   -1.3823    1.5080         0
%     1.1310   -1.0053    2.3876   -1.3823    1.2566         0
%     0.5027   -1.0053    2.3876   -1.3823    0.5027         0 ->1
