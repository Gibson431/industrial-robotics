clear 
close all
clc
hold on
robot = Ned(eye(4));
flats = PlaceObject("2_Flats.ply",[1.5,0.3,0]);
% robot.model.teach();
while true
    robot.doStep();
    pause(0.1);
end

%% guesses

%start offset guess
%     0.2827    0.3142    2.0019   -2.3248   -1.5708    2.4504 -> near row
%     0.3770    0.2513    1.9478   -2.1991   -1.5708    2.4504
%     0.4712    0.1885    1.5149   -1.6965   -1.5708    2.4504
%     0.5655    0.3142    1.2444   -1.5708   -1.5708    2.4504 -> far row


%start pos guesses
%     0.1885    0.4712    2.1642   -2.7018   -1.5080    2.4504 -> near row
%     0.2827    0.4712    2.1642   -2.7018   -1.5080    2.4504
%     0.3770    0.5027    2.0019   -2.5133   -1.5080    2.4504
%     0.4712    0.5655    1.8937   -2.5133   -1.5080    2.4504 -> far row

% above tray guess
%     0   -0.4398   -1.1362   -1.5708    1.5080         0  %note: may
%     need to do better guesses than this but we will try it out

% end pos guess
%              0   -1.0681   -0.7034   -1.4451    1.3195         0 -> far
%              0   -0.7540   -1.4067   -1.0681    1.3195         0
%              0   -0.5655   -2.0019   -0.5655    1.3195         0
%              0   -0.4084   -2.3806   -0.3770    1.3195         0 -> near
