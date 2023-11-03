classdef eStop < handle
    
    properties
        arduino
        status
        startTime
    end
    
    methods
        function self = eStop(arduino)
            self.arduino = arduino;
            self.status = 1; % 0 = stopped, 1 = running, 2 = on hold
            self.startTime = tic;
            
        end
        
        function checkEStop(self)
            while true
                
                elapsedTime = toc(self.startTime);
                if elapsedTime < 1
                    disp(elapsedTime);
                end
                
                %if less than one return/disp
                
                stopPin = readDigitalPin(self.arduino, 'D2');
                resPin = readDigitalPin(self.arduino, 'D3');
                
                if stopPin == 1
                    disp('running')
                    self.status = 1
                end
                
                if stopPin == 0
                    disp('stop pin pressed');
                    if self.status == 1
                        self.status = 0;
                        self.startTime = tic
                        disp('stop')
                    else
                        disp('holding')
                    end
                end
                
                if self.status == 0 && resPin == 0
                    disp('res pin pressed');
                    
                    if self.status == 2
                        self.status = 1;
                        disp('resuming')
                    end
                end
                
                
                disp(elapsedTime);
                
            end
        end
    end
end