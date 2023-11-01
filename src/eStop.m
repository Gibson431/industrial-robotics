classdef eStop < handle
    properties
        isRunning = true;
        arduino;
        
    end
    
    methods
        function obj = testEstop()
            a = arduino();  % Initialize the Arduino object
            stopBut = readDigitalPin(a, 'D2');
            resBut = readDigitalPin(a, 'D3');
        end
        
        function Loop(obj)
            while true
                                
                if isRunning && stopBut == 1
                    disp('Stop button is pressed. Stopping the script...');
                    
                end
                
                if isRunning  && stopBut == 0
                    disp('Stop button is pressed. Stopping the script...');
                    break;
                end
                
                if resBut == 1
                    obj.isRunning = true;
                    disp('Resume button is pressed. Resuming the script...');
                end

            end
        end
       
    end
end

