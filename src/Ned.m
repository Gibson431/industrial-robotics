classdef Ned < omronTM5_700
    properties
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
        endGuesses = [
            0   -1.0681   -0.7034   -1.4451    1.3195         0 
            0   -0.7540   -1.4067   -1.0681    1.3195         0
            0   -0.5655   -2.0019   -0.5655    1.3195         0
            0   -0.4084   -2.3806   -0.3770    1.3195         0 
            ]
        gripperOffset = SE3(transl(0,0,0.13));
        gripper;
        hasROS = false;
        controller;

    end
    methods
        function self = Ned(tr)
            baseTr = eye(4);
            if nargin ~= 0
                baseTr = tr;
            end
            self.model.base = baseTr * transl(1.1,0.5,0);
            self.model.animate([0 0 0 0 0 0]);
            self.substrate = RobotSubstrate(self.substrateCount);

            endEffector = self.model.fkine(self.model.getpos).T;
            self.gripper = Gripper(endEffector,1);
        end
        %% Move Robot
        function self = doStep(self)
            if self.hasROS
                if ~self.controller.checkGoal()
                    return
                end
            end
            if ~isempty(self.stepList)
                self.jog(self.stepList(1,:));
                
                if length(self.stepList(:,end)) == 1
                    self.routeCount = self.routeCount + 1;
                    self.holdingObject = false;
                    self.gripper.Open(1);
                    if self.hasROS
                        self.controller.actuate_gripper();
                    end
                    self.stepList = [];
                    self.calcNextRoute();
                else
                    self.stepList = self.stepList(2:end, :);
                end
                
                % drawnow();
                % pause(0.1);
                
            elseif (self.holdingObject)
                self.holdingObject = false;
                self.gripper.Open(1);
                if self.hasROS
                    self.controller.actuate_gripper();
                end
                self = self.calcNextRoute();
            else
                self = self.calcNextRoute();
            end
        end
        
        function self = jog(self, qVals)
            self.model.animate(qVals);
            self.gripper.moveBase(self.model.fkine(self.model.getpos));
            if (self.holdingObject)
                self.heldObject.base = self.model.fkine(qVals)*self.gripperOffset;
                self.heldObject.animate(0);
            end
            if self.hasROS
                self.controller.SetGoal(1.8, qVals, 1);
                self.controller.doGoal();
            end
        end

        function self = jogRMRC(self, xDot)
            k = 0.2;
            x = k * xDot;
            J = self.model.jacob0(self.model.getpos);
            qdot =pinv(J)*x';
            qNext = self.model.getpos + (qdot'*0.1);

            self.jog(qNext);
        end
        
        function self = calcNextRoute(self)
            currentJointState = self.model.getpos();

            if self.routeCount > 32
                self = self.moveNed(currentJointState, [0 0 0 0 0 0], self.macroStep);
                return
            end
            if mod(self.routeCount, 2) == 1
                currentJointState = self.model.getpos();

                elleIndex = floor(self.routeCount/2)+1;
                bTr = self.substrate.substrateModel{elleIndex}.base;
                
                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);
                
                waypoint1 = SE3(transl(bx_pos,by_pos, bz_pos + 0.1)*trotx(-pi))*inv(self.gripperOffset);
                waypoint2 = SE3(transl(bx_pos,by_pos,bz_pos)*trotx(-pi))*inv(self.gripperOffset);
                
                groupIndex = floor((elleIndex-1)/4)+1;
                nextJointState = self.model.ikine(waypoint1, self.guesses{groupIndex}(1,:));
                self = self.moveNed(currentJointState, nextJointState, self.macroStep);
                
                nextJointState = self.model.ikine(waypoint2, self.guesses{groupIndex}(2,:));
                self = self.moveNed(self.stepList(end,:), nextJointState, self.microStep);
                
            else
                currentJointState = self.model.getpos();
                
                elleIndex = floor(self.routeCount/2);
                groupIndex = floor((elleIndex-1)/4)+1;
                isEven = mod(groupIndex, 2);
                rowIndex = mod(elleIndex-1, 4);
                
                xPos = 1.75-(rowIndex)*0.14-isEven*0.07;
                yPos = 0.21+(groupIndex-1)*0.07;
                
                waypoint3 = SE3(transl(xPos,yPos,0.1)*trotx(-pi))*inv(self.gripperOffset);
                waypoint4 = SE3(transl(xPos,yPos,0.05)*trotx(-pi))*inv(self.gripperOffset);
                
                nextJointState = self.model.ikcon(waypoint3, self.endGuesses(rowIndex+1,:));
                self = self.moveNedSubstrate(elleIndex, currentJointState, nextJointState, self.macroStep);
                
                nextJointState = self.model.ikcon(waypoint4, self.endGuesses(rowIndex+1,:));
                self = self.moveNedSubstrate(elleIndex, self.stepList(end,:), nextJointState, self.microStep);
                                
                self.gripper.Close(1);

            end
        end
        
        function self = moveNed(self,fromJointState, toJointState, steps)
            currentJointState = fromJointState;
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
        end
        
        function self = moveNedSubstrate(self,i,fromJointState, toJointState, steps)
            self = self.moveNed(fromJointState, toJointState, steps);
            self.holdingObject = true;
            self.heldObject = self.substrate.substrateModel{i};
            if self.hasROS
                self.controller.actuate_gripper();
            end
        end
    end
end