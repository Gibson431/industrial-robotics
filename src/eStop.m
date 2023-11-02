status = 1; % 0 = stopped, 1 = running, 2 = on hold
lastStopState = 1;

stopPin = readDigitalPin(arduino, 'D2');
% resPin = readDigitalPin(arduino, 'D3');

while true

if (lastStopState && stopPin == 1)
    if (status ~= 0)
        status = 0;
        disp('estop pressed')
    else
        status = 2;
        disp('on hold')
    end
end

if  status == 2 && (resPin == 1) 
    status = 1
    disp('running')
end
        
lastStopState = stopPin;
end