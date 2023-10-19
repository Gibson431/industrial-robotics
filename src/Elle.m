classdef Elle
    properties
        robot;
        netpot;
        netpotCount = 16;
    end
    methods
        function self = Elle(tr)
            close all;
            clc;
            baseTr = transl(0,0,0);
            if nargin ~= 0
                baseTr = tr;
            end
            self.robot = UR3(baseTr);
            self.robot.model.animate([0 -pi/2 0 0 0 pi/2]);
            % stepElle(self);
        end
        %% Moving ELLE
        function self =  stepElle(self)

            self.netpot = RobotNetpots(self.netpotCount);
            steps = length(self.netpot.netpotModel);

            for i = 1 : steps
                bTr = self.netpot.netpotModel{i}.base;
                % self.netpot.netpotModel{1}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos + 0.1,by_pos, bz_pos) * troty(-pi/2) * trotz(-pi);
                waypoint2 = transl(bx_pos+0.02,by_pos,bz_pos) * troty(-pi/2) * trotz(-pi);

                if i <= 4
                    waypoint3 = transl(-0.2,-0.2,0.6) *troty(pi/2);
                    waypoint4 = transl(-0.05,0.3-i*0.1,0.2)* troty(pi/2);

                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4,waypoint3};
                    wSteps = length(waypoint);
                end

                if 4 < i
                    waypoint3 = transl(-0.025,0.3-(i-4)*0.05,0.1)* troty(pi/2);
                    waypoint = {waypoint1,waypoint2,waypoint3};

                    wSteps = length(waypoint);

                end

                if 8 < i
                    waypoint3 = transl(0.025,0.3-(i-8)*0.05,0.1)* troty(pi/2);
                    waypoint = {waypoint1,waypoint2,waypoint3};

                    wSteps = length(waypoint);

                end

                if 12 < i
                    waypoint3 = transl(0.05,0.3-(i-12)*0.05,0.1)* troty(pi/2);
                    waypoint = {waypoint1,waypoint2,waypoint3};

                    wSteps = length(waypoint);

                end

                for j = 1:wSteps
                    % nextJointState = self.robot.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0])
                    if j<=2
                        nextJointState = self.robot.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0]);
                        self.moveElle(nextJointState);
                    end
                    if 2<j
                        % nextJointState = self.robot.model.ikine(waypoint{j},'mask',[1 1 1 1 1 1]);
                        nextJointState = self.robot.model.ikcon(waypoint{j});
                        self.moveElleNetpot(steps,i,nextJointState);
                    end
                    if 3<j
                        nextJointState = self.robot.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0]);
                        self.moveElle(nextJointState);
                    end
                end
            end
        end

    function self =  moveElle(self,nextJointState)
        currentJointState = self.robot.model.getpos;
        steps = 20;
        s = lspb(0,1,steps);
        qMatrix = nan(steps,6);
        for k = 1:steps
            qMatrix(k,:) = (1-s(k))*currentJointState + s(k)*nextJointState;
        end
        % x = zeros(6,steps);
        %  for l = 1:steps-1
        %      xdot = (x(:,l+1) - x(:,l))/deltaT;
        %      J = self.robot.model.jacob0(qMatrix(l,:));
        %      J = J(1:2,:);
        %      qdot = inv(J)*xdot;
        %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
        %  end
        % qMatrix = jtraj(currentJointState,nextJointState,steps);
        for i = 1:steps
            % self.netpot.netpotModel{i}.base = self.robot.model.fkine(qMatrix(i,:)) * SE3(troty(pi/2));

            self.robot.model.animate(qMatrix(i,:));
            drawnow();
            pause(0.1);
        end
    end

    function self =  moveElleNetpot(self,steps,i,nextJointState)
        currentJointState = self.robot.model.getpos;
        s = lspb(0,1,steps);
        qMatrix = nan(steps,6);
        for k = 1:steps
            qMatrix(k,:) = (1-s(k))*currentJointState + s(k)*nextJointState;
        end
        % qSteps = 20;
        % qMatrix = jtraj(currentJointState, nextJointState,qSteps);
        % x = zeros(6,steps);
        %  for l = 1:steps-1
        %      xdot = (x(:,l+1) - x(:,l))/deltaT;
        %      J = self.robot.model.jacob0(qMatrix(l,:));
        %      J = J(1:2,:);
        %      qdot = inv(J)*xdot;
        %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
        %  end
        % Animate gripper and brick with end-effector
        for j = 1:steps
            self.netpot.netpotModel{i}.base = self.robot.model.fkine(qMatrix(j,:)) * SE3(troty(pi/2)) *SE3(trotx(pi/2));

            self.robot.model.animate(qMatrix(j,:));
            self.netpot.netpotModel{i}.animate(0);

            drawnow();
            pause(0.1);
        end
    end
end
end