classdef Ned < omronTM5
    properties
        % robot;
        substrate;
        substrateCount = 16;
        substrateIndex = 0;
        stepList = [];
        holdingObject = false;
        heldObject;
        routeCount = 1;
        macroStep = 20;
        microStep = 5;
        guesses = {[
            0.2827    0.3142    2.0019   -2.3248   -1.5708    2.4504
            0.1885    0.4712    2.1642   -2.7018   -1.5080    2.4504
            0   -0.4398   -1.1362   -1.5708    1.5080         0
            0   -0.5969   -1.5691   -0.9425    1.3823         0            ], [
            0.3770    0.2513    1.9478   -2.1991   -1.5708    2.4504
            0.2827    0.4712    2.1642   -2.7018   -1.5080    2.4504
            0   -0.4398   -1.1362   -1.5708    1.5080         0
            0   -0.5969   -1.5691   -0.9425    1.3823         0            ], [
            0.4712    0.1885    1.5149   -1.6965   -1.5708    2.4504
            0.3770    0.5027    2.0019   -2.5133   -1.5080    2.4504
            0   -0.4398   -1.1362   -1.5708    1.5080         0
            0   -0.5969   -1.5691   -0.9425    1.3823         0            ], [
            0.5655    0.3142    1.2444   -1.5708   -1.5708    2.4504
            0.4712    0.5655    1.8937   -2.5133   -1.5080    2.4504
            0   -0.4398   -1.1362   -1.5708    1.5080         0
            0   -0.5969   -1.5691   -0.9425    1.3823         0            ]}
    end
    methods
        function self = Ned(tr)
            baseTr = eye(4);
            if nargin == 1
                baseTr = tr;
            end
            self.model.base = baseTr * transl(0.9,0.5,0);
            self.model.animate([0 0 0 0 0 0]);
            self.substrate = RobotSubstrate(self.substrateCount);
        end
        %% Move Robot
        
        
        function self = doStep(self)
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
                self = self.calcNextRoute();
            else
                self = self.calcNextRoute();
            end
        end
        
        function self = jog(self, qVals)
            self.model.animate(qVals);
            if (self.holdingObject)
                self.heldObject.base = self.model.fkine(qVals) * SE3(trotx(-pi/2));
                self.heldObject.animate(0);
            end
        end
        
        function self = calcNextRoute(self)
            
            disp('recalc');
            % steps = length(self.substrate.substrateModel);
            
            
            
            if mod(self.routeCount, 2) == 1
                currentJointState = self.model.getpos();
                
                if self.routeCount > 32
                    self = self.moveNed(currentJointState, [0 0 0 0 0 0], 3);
                    
                end
                elleIndex = floor(self.routeCount/2)+1;
                bTr = self.substrate.substrateModel{elleIndex}.base;
                
                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);
                
                waypoint1 = transl(bx_pos,by_pos, bz_pos + 0.1) * trotx(-pi);
                waypoint2 = transl(bx_pos,by_pos,bz_pos + 0.02) * trotx(-pi);
                
                groupIndex = floor((elleIndex-1)/4)+1;
                nextJointState = self.model.ikcon(waypoint1, self.guesses{groupIndex}(1,:));
                self = self.moveNed(currentJointState, nextJointState, self.macroStep);
                
                nextJointState = self.model.ikcon(waypoint2, self.guesses{groupIndex}(2,:));
                self = self.moveNed(self.stepList(end,:), nextJointState, self.microStep);
                
            else
                currentJointState = self.model.getpos();
                
                elleIndex = floor(self.routeCount/2);
                groupIndex = floor((elleIndex-1)/4)+1;
                isEven = mod(groupIndex, 2);
                rowIndex = mod(elleIndex-1, 4);
                
                xPos = 1.75-(rowIndex)*0.14-isEven*0.07;
                yPos = 0.21+(groupIndex-1)*0.07;
                
                waypoint3 = transl(xPos,yPos,0.2) * trotx(-pi);
                waypoint4 = transl(xPos,yPos,0.05) * trotx(-pi);
                
                nextJointState = self.model.ikcon(waypoint3, self.guesses{groupIndex}(3,:));
                self = self.moveNedSubstrate(elleIndex, currentJointState, nextJointState, self.macroStep);
                
                nextJointState = self.model.ikcon(waypoint4, self.guesses{groupIndex}(4,:));
                self = self.moveNedSubstrate(elleIndex, self.stepList(end,:), nextJointState, self.microStep);
            end
        end
        
        function self = moveNed(self,fromJointState, toJointState, steps)
            currentJointState = fromJointState;
            % steps = 20;
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
        end
        
        function self = moveNedSubstrate(self,i,fromJointState, toJointState, steps)
            self = self.moveNed(fromJointState, toJointState, steps);
            self.holdingObject = true;
            self.heldObject = self.substrate.substrateModel{i};
        end
    end
end