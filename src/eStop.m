classdef eStop < matlab.apps.AppBase
    
    properties
        StopButton1 % Variable to indicate if button1 is pressed
    end
    
    methods (Access = protected)
        function createComponents(app)
            led_pin = 'D8'; % Change value to whichever digital pin is meant to be read.
            button1_pin = 'D2'; % Change value to whichever digital pin is meant to be read.
            button2_pin = 'D3'; % Change value to whichever digital pin is meant to be read.
            
            % Set the StopButton1 to false initially
            app.StopButton1 = false;
            
            % Create a loop to continuously check the button state
            while true
                buttonState = readDigitalPin(f, button1_pin);
                if buttonState == 1
                    app.StopButton1 = true; % Set StopButton1 to true if button1 is pressed
                end
                
                if app.StopButton1
                    break; % Exit the loop if button1 is pressed
                end
            end
            
            % Your code here
        end
    end
end