classdef eStop
    properties
        arduinoObj
        buttonPin
    end
    
    methods
        function obj = eStop(comPort, buttonPin)
            % Constructor: Initialize the Arduino and button pin
            obj.arduinoObj = arduino(comPort, 'Uno', 'Libraries', 'Adafruit\MotorShieldV2');
            obj.buttonPin = buttonPin;
            
            % Set the button pin mode to input
            configurePin(obj.arduinoObj, obj.buttonPin, 'DigitalInput');
        end
        
        function buttonPress(obj)
            % Run this method to continuously check if the button is pressed
            while true
                buttonState = readDigitalPin(obj.arduinoObj, obj.buttonPin);
                
                if buttonState == 0
                    disp('Estop pressed. Stopping the code.');
                    break; % Exit the loop and stop the code
                end
            end
        end
        
        function delete(obj)
            % Destructor: Clean up when the object is deleted
            clear obj.arduinoObj;
        end
    end
end

 %% e stop
  
comPort = 'cu.usbmodem14301'; %change this depending on your computer com port 
buttonPin = 'D2'; % replace with the actual pin connected to the button

% Create an instance of the class
buttonControl = ArduinoButtonControl(comPort, buttonPin);

% Call the method to stop the code when the button is pressed
buttonControl.stopWhenButtonPressed();

% Clean up when you're done
clear buttonControl;
