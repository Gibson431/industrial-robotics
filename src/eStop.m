
% Create an instance of the Elle class (assuming you have Elle class defined)
robot = Elle(eye(4));
% robot.model.teach();
while true
    robot.doStep();
end

button1_pin = 'D2'; 
% button2_pin = 'D3'; 
% robot = Elle(eye(4));
a = arduino

% Set the StopButton1 to false initially

% Create a loop to continuously check the button state
while true
    buttonState = readDigitalPin(f, button1_pin);
    if buttonState == 1
        app.StopButton1 = true; % Set StopButton1 to true if button1 is pressed
    end
    
    if app.StopButton1
        break; % Exit the loop if button1 is pressed
    buttonPin = readDigitalPin(a, 'D2') % Change value to whichever digital pin is meant to be read.

    if buttonPin == 1
        % Code to run when buttonPin is equal to 1
        disp('Button is not pressed. Running code...');
        % Replace with your code to be executed
    else if buttonPin == 0
        % Code to pause when buttonPin is equal to 0
        disp('Button is pressed. Pausing...');
        % Add any necessary pause or delay here
        break;  
        
    end
end

% if buttonPin == 1
%     
% else if buttonPin == 0
%         disp('huh');
%     end
% end
% 
 
%     
% classdef eStop < handle
%     properties
%         isRunning = true;
%         arduino;
%         
%     end
%     
%     methods
%         function obj = testEstop()
%             a = arduino();  % Initialize the Arduino object
%             stopBut = readDigitalPin(a, 'D2');
%             resBut = readDigitalPin(a, 'D3');
%         end
%         
%         function Loop(obj)
%             while true
%                                 
%                 if isRunning && stopBut == 1
%                     disp('Stop button is pressed. Stopping the script...');
%                     
%                 end
%                 
%                 if isRunning  && stopBut == 0
%                     disp('Stop button is pressed. Stopping the script...');
%                     break;
%                 end
%                 
%                 if resBut == 1
%                     obj.isRunning = true;
%                     disp('Resume button is pressed. Resuming the script...');
%                 end
% 
%             end
%         end
%        
%     end
% end

