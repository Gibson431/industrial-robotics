classdef Elle < CustomUR3
    properties
        netpot;
        netpotCount = 16;
        netpotIndex = 0;
        stepList;
        holdingObject = false;
        heldObject;
        routeCount = 1;
        guesses = {[
            -0.7540   -0.2513   -1.1310   -1.7593    1.5080         0
            2.0106   -0.7540    2.0106   -1.2566    2.0106         0
            -1.6336   -1.2566    1.2566   -1.5080   -1.5080         0
            -2.2619   -1.2566    2.2619   -2.6389   -1.5080         0
            ],[
            -1.1310   -0.2513   -1.1310   -1.7593    1.5080         0
            1.5080   -1.0053    2.3876   -1.3823    1.5080         0
            -1.6336   -1.2566    1.2566   -1.5080   -1.5080         0
            -2.2619   -1.2566    2.2619   -2.6389   -1.5080         0
            ],[
            -0.8796   -0.2513   -1.1310   -1.7593    1.5080         0
            1.1310   -1.0053    2.3876   -1.3823    1.2566         0
            -1.6336   -1.2566    1.2566   -1.5080   -1.5080         0
            -2.2619   -1.0053    2.0106   -2.6389   -1.5080         0
            ],[
            -0.7540   -0.2513   -1.1310   -1.7593    1.5080         0
            0.5027   -1.0053    2.3876   -1.3823    0.5027         0
            -1.6336   -1.2566    1.2566   -1.5080   -1.5080         0
            -2.2619   -1.0053    2.0106   -2.6389   -1.5080         0
            ]}
        
        
        
    end
    methods
        function self = Elle(tr)
            
            baseTr = eye(4);
            if nargin ~= 0
                baseTr = tr;
            end
            self.model.base = baseTr * transl(1.5,0,0);
            self.model.animate([0 0 0 0 0 pi/2]);
            self.netpot = RobotNetpots(self.netpotCount);
        end
        
        %% Move Robot
        
        
        function self = doStep(self)
            % disp("step list length top: ");
            % disp(length(self.stepList));
            if ~isempty(self.stepList)
                self.jog(self.stepList(1,:));
                
                if length(self.stepList(:,end)) == 1
                    self.routeCount = self.routeCount + 1;
                    self.holdingObject = false;
                    self.calcNextRoute();
                    self.stepList = [];
                else
                    self.stepList = self.stepList(2:end, :);
                end
                
                drawnow();
                pause(0.1);
                
            elseif (self.holdingObject)
                self.holdingObject = false;
                self.calcNextRoute();
            else
                self.calcNextRoute();
            end
        end
        
        function self = jog(self, qVals)
            self.model.animate(qVals);
            if (self.holdingObject)
                self.heldObject.base = self.model.fkine(qVals)*SE3(transl(0,0,0.05));
                self.heldObject.animate(0);
            end
        end
        
        function self = rmrc(self)
            deltaT = 0.05;                                                              % Discrete time step
            
            minManipMeasure = 0.1;
            steps = 100;
            deltaTheta = 2*pi/steps;
            x = [];
            
            
        end
        
        function self = calcNextRoute(self)
            steps = length(self.netpot.netpotModel);
            
            if mod(self.routeCount, 2) == 1
                i = self.routeCount;
                guess = floor(i/4)+1;
                guess = initialGuess(guess,:);
                netIndex = floor(self.routeCount/2)+1;
                bTr = self.netpot.netpotModel{netIndex}.base;
                
                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);
                
                waypoint1 = transl(bx_pos,by_pos + 0.2, bz_pos + 0.01) * trotx(-pi/2) * trotz(pi) * troty(pi);
                waypoint2 = transl(bx_pos,by_pos + 0.05,bz_pos + 0.01) * trotx(-pi/2) * trotz(pi) * troty(pi);
                
                
                currentJointState = self.model.getpos;
                
                nextJointState = self.model.ikcon(waypoint1, self.guesses{groupIndex}(1,:));
                self = self.moveElle(currentJointState, nextJointState);
                
                nextJointState = self.model.ikcon(waypoint2, self.guesses{groupIndex}(2,:));
                self = self.moveElle(self.stepList(end,:), nextJointState);
                
            else
                i = floor(self.routeCount/2);
                % guess = 0;
                if i <= 4
                    % waypoint3 = transl(0.1,0.4-(i-1)*1.4,0.5) * trotx(-pi);
                    % waypoint4 = transl(0.1,0.4-(i-1)*1.4,0.1) * trotx(-pi);
                    waypoint3 = transl(1.27,0.2+(i-1)*0.7,0.2)*trotx(-pi/2);
                    waypoint4 = transl(1.27,0.2+(i-1)*0.7,0.05)*trotx(-pi/2);
                    
                    
                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    
                    % initialGuesses = {waypoint1Guess(1,:),waypoint2Guess(1,:),waypoint3Guess,waypoint4Guess}
                    %
                    % wSteps = length(waypoint);
                end
                
                if 4 < i
                    waypoint3 = transl(0.28,1.82+(i-5)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.28,1.82+(i-5)*14,0.2) * trotx(-pi);
                    
                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    %
                    % initialGuesses = {waypoint1Guess,waypoint2Guess,waypoint3Guess,waypoint4Guess}
                    %
                    % initialGuesses = {waypoint1Guess(2,:),waypoint2Guess(2,:),waypoint3Guess,waypoint4Guess}
                    %
                    % wSteps = length(waypoint);
                    
                end
                
                if 8 < i
                    waypoint3 = transl(0.35,1.75+(i-9)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.35,1.75+(i-9)*14,0.2) * trotx(-pi);
                    
                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    %
                    % initialGuesses = {waypoint1Guess(3,:),waypoint2Guess(3,:),waypoint3Guess,waypoint4Guess}
                    %
                    % wSteps = length(waypoint);
                end
                
                if 12 < i
                    waypoint3 = transl(0.42,1.82+(i-13)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.42,1.82+(i-13)*14,0.2) * trotx(-pi);
                    
                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    %
                    % initialGuesses = {waypoint1Guess(4,:),waypoint2Guess(4,:),waypoint3Guess,waypoint4Guess}
                    %
                    % wSteps = length(waypoint);
                end
                currentJointState = self.model.getpos;
                
                nextJointState = self.model.ikcon(waypoint3, self.guesses{groupIndex}(3,:));
                self = self.moveElleNetpot(i, currentJointState, nextJointState, 20);
                
                nextJointState = self.model.ikcon(waypoint4, self.guesses{groupIndex}(4,:));
                self = self.moveElleNetpot(i, self.stepList(end,:), nextJointState, 5);
                
            end
            
        end
        
        function self =  moveElle(self,fromJointState, toJointState)
            currentJointState = fromJointState;
            steps = 20;
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
        end
        
        function self =  moveElleNetpot(self,i,fromJointState,toJointState)
            self.moveElle(fromJointState, toJointState);
            self.holdingObject = true;
            self.heldObject = self.netpot.netpotModel{i};
        end
    end
end