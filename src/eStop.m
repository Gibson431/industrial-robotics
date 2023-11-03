classdef eStop < handle

    properties
        arduino
        status
        startTime
    end

    methods
        function self = eStop()
            self.arduino = arduino;
            self.status = 0; % 0 = stopped, 1 = running, 2 = on hold
            self.startTime = tic;

        end

        function isTriggered = checkEStop(self)

            elapsedTime = toc(self.startTime);
            if elapsedTime < 1
                disp(elapsedTime);
                isTriggered = self.status;
                return;
            end

            stopPin = readDigitalPin(self.arduino, 'D2');
            resPin = readDigitalPin(self.arduino, 'D3');

            if stopPin == 0
                self.status = 1;
            end

            if self.status == 1 && resPin == 0
                self.status = 0;
            end

            disp(elapsedTime);
            isTriggered = self.status;
            self.startTime = tic;
        end
    end
end