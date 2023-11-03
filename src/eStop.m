classdef eStop
    
    properties
        arduino
        status
    end
    
    methods
        function obj = EStop(arduino)
            obj.arduino = arduino;
            obj.status = 1; % 0 = stopped, 1 = running, 2 = on hold
            startTime = 0;
            
        end
        
        function checkEStop(obj)
            while true
                
                elapsedTime = toc(startTime);
                if elapsedTime < 1
                    disp(elapsedTime);
                end
                
                %if less than one return/disp
                
                stopPin = readDigitalPin(obj.arduino, 'D2');
                resPin = readDigitalPin(obj.arduino, 'D3');
                
                if stopPin == 1
                    disp('running')
                end
                
                if stopPin == 0
                    disp('stop pin pressed');
                    if obj.status == 1
                        obj.status = 0;
                        startTime = tic
                        disp('stop')
                    else
                        disp('holding')
                    end
                end
                
                if obj.status == 0 && resPin == 0
                    disp('res pin pressed');
                    
                    if obj.status == 2
                        obj.status = 1;
                        disp('resuming')
                    end
                end
                
                
                disp(elapsedTime);
                
            end
        end
    end
end