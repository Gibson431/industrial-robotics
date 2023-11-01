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
            -1.5708   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -1.5708   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            ],[
            -2  -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -2   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            ],[
            -2   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -2   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            ],[
            -1.5708   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -1.5708   -0.7854   -1.5708-0.7854   0    1.5708    3.1415
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            -1.5708    0.7854    1.5708   -2.3562   -1.5708         0
            ]};
%         gripperOffset = SE3(transl(0,0,0.05));

    end
    methods
        function self = Elle(tr)

            baseTr = eye(4);
            if nargin ~= 0
                baseTr = tr;
            end
            self.model.base = baseTr * transl(1.5,-0.05,0);
            self.model.animate([0 0 0 0 0 pi/2]);
            self.netpot = RobotNetpots(self.netpotCount);
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

                % drawnow();
                % pause(0.1);

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
                self.heldObject.base = self.model.fkine(qVals)*self.gripperOffset*SE3(trotx(pi/2));
                self.heldObject.animate(0);
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
                self = self.moveElle(currentJointState, [0 0 0 0 0 0], 20);
                return
            end
            if mod(self.routeCount, 2) == 1
                currentJointState = self.model.getpos();


                netIndex = floor(self.routeCount/2)+1;
                bTr = self.netpot.netpotModel{netIndex}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = SE3(transl(bx_pos,by_pos, bz_pos + 0.1)*trotx(pi))*inv(self.gripperOffset);
                waypoint2 = SE3(transl(bx_pos,by_pos,bz_pos)*trotx(pi))*inv(self.gripperOffset);

                groupIndex = floor((netIndex-1)/4)+1;
                nextJointState = self.model.ikcon(waypoint1, self.guesses{groupIndex}(1,:));
                self = self.moveElle(currentJointState, nextJointState,20);

                nextJointState = self.model.ikcon(waypoint2, self.guesses{groupIndex}(2,:));
                self = self.moveElle(self.stepList(end,:), nextJointState,5);

            else
                currentJointState = self.model.getpos();
                netIndex = floor(self.routeCount/2);
                groupIndex = floor((netIndex-1)/4)+1;
                isEven = mod(groupIndex, 2);
                rowIndex = mod(netIndex-1, 4);

                xPos = 1.75-(rowIndex)*0.14-isEven*0.07;
                yPos = 0.21+(groupIndex-1)*0.07;

                waypoint3 = SE3(transl(xPos,yPos,0.2)*trotx(pi)) * inv(self.gripperOffset);
                waypoint4 = SE3(transl(xPos,yPos,0.05)*trotx(pi)) * inv(self.gripperOffset);

                nextJointState = self.model.ikcon(waypoint3, self.guesses{groupIndex}(3,:));
                self = self.moveElleNetpot(netIndex, currentJointState, nextJointState, 20);

                nextJointState = self.model.ikcon(waypoint4, self.guesses{groupIndex}(4,:));
                self = self.moveElleNetpot(netIndex, self.stepList(end,:), nextJointState, 5);

            end

        end

        function self =  moveElle(self,fromJointState, toJointState, steps)
            currentJointState = fromJointState;
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