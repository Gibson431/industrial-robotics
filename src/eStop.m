% robot = Elle(eye(4));
a = arduino

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