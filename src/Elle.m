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
            ]};
        gripperOffset = SE3(transl(0,0,0.05));



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
                self.heldObject.base = self.model.fkine(qVals)*self.gripperOffset;
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
                currentJointState = self.model.getpos();

                if self.routeCount >= 31
                    self = self.moveElle(currentJointState, [0 0 0 0 0 0], 20);

                end
                netIndex = floor(self.routeCount/2)+1;
                bTr = self.netpot.netpotModel{netIndex}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos,by_pos + 0.2, bz_pos + 0.01) * trotx(-pi/2) * trotz(pi) * troty(pi);
                waypoint2 = transl(bx_pos,by_pos + 0.05,bz_pos + 0.01) * trotx(-pi/2) * trotz(pi) * troty(pi);

                groupIndex = floor((netIndex-1)/4)+1;
                nextJointState = self.model.ikcon(waypoint1, self.guesses{groupIndex}(1,:));
                self = self.moveElle(currentJointState, nextJointState,20);

                nextJointState = self.model.ikcon(waypoint2, self.guesses{groupIndex}(2,:));
                self = self.moveElle(self.stepList(end,:), nextJointState,5);

            else
                currentJointState = self.model.getpos();
                % waypoint3 = transl(1.27,0.2+(i-1)*0.7,0.2)*trotx(-pi/2);
                % waypoint4 = transl(1.27,0.2+(i-1)*0.7,0.05)*trotx(-pi/2);
                netIndex = floor(self.routeCount/2)
                groupIndex = floor((netIndex-1)/4)+1;
                isEven = mod(groupIndex, 2)
                rowIndex = mod(netIndex-1, 4);
                % guess = 0;
                % if netIndex <= 4
                %     waypoint3 = transl(1.27,0.2+(netIndex-1)*0.07,0.2)*trotx(-pi/2);
                %     waypoint4 = transl(1.27,0.2+(netIndex-1)*0.07,0.05)*trotx(-pi/2);
                % end
                % 
                % if 4 < netIndex
                %     waypoint3 = transl(0.28,1.82+(netIndex-5)*0.14,0.5) * trotx(-pi);
                %     waypoint4 = transl(0.28,1.82+(netIndex-5)*0.14,0.2) * trotx(-pi);
                % end
                % 
                % if 8 < netIndex
                %     waypoint3 = transl(0.35,1.75+(netIndex-9)*0.14,0.5) * trotx(-pi);
                %     waypoint4 = transl(0.35,1.75+(netIndex-9)*0.14,0.2) * trotx(-pi);
                % end
                % 
                % if 12 < netIndex
                %     waypoint3 = transl(0.42,1.82+(netIndex-13)*0.14,0.5) * trotx(-pi);
                %     waypoint4 = transl(0.42,1.82+(netIndex-13)*0.14,0.2) * trotx(-pi);
                % end
                % currentJointState = self.model.getpos;

                xPos = 1.75-(rowIndex)*0.14-isEven*0.07;
                yPos = 0.21+(groupIndex-1)*0.07;

                waypoint3 = SE3(transl(xPos,yPos,0.2) * trotx(-pi/2))*inv(self.gripperOffset);
                waypoint4 = SE3(transl(xPos,yPos,0.05) * trotx(-pi/2))*inv(self.gripperOffset);

                nextJointState = self.model.ikcon(waypoint3, self.guesses{groupIndex}(3,:));
                self = self.moveElleNetpot(netIndex, currentJointState, nextJointState, 20);

                nextJointState = self.model.ikcon(waypoint4, self.guesses{groupIndex}(4,:));
                self = self.moveElleNetpot(netIndex, self.stepList(end,:), nextJointState, 5);

            end

        end

        function self =  moveElle(self,fromJointState, toJointState, steps)
            currentJointState = fromJointState;
            % steps = 20;
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
        end

        function self =  moveElleNetpot(self,i,fromJointState,toJointState, steps)
            self.moveElle(fromJointState, toJointState,steps);
            self.holdingObject = true;
            self.heldObject = self.netpot.netpotModel{i};
        end
    end
end