classdef Ned < omronTM5
    properties
        substrate;
        substrateCount = 16;
    end
    methods
        function self = Ned(tr)
            close all;
            clc;
            baseTr = eye(4);
            if nargin == 1
                baseTr = tr;
            end
            self.model.base = baseTr;
            self.model.animate([0 pi/2 0 0 0 0]);
            self.stepNed();
        end
        %% Move Robot
        function self =  stepNed(self)

            self.substrate = RobotSubstrate(self.substrateCount);
            steps = length(self.substrate.substrateModel);

            for i = 1 : steps
                bTr = self.substrate.substrateModel{i}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos,by_pos, bz_pos + 0.1) * trotx(-pi);
                waypoint2 = transl(bx_pos,by_pos,bz_pos + 0.02) * trotx(-pi);

                if i <= 4
                    waypoint3 = transl(-0.2,-0.2,0.9) * trotx(-pi);
                    waypoint4 = transl(-0.05,0.3-i*0.1,0.2) * trotx(-pi);

                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    wSteps = length(waypoint);
                end

                if 4 < i
                    waypoint3 = transl(-0.2,-0.2,0.9) * trotx(-pi);

                    waypoint4 = transl(-0.025,0.3-(i-4)*0.05,0.2) * trotx(-pi);
                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};

                    wSteps = length(waypoint);

                end

                if 8 < i
                    waypoint3 = transl(-0.2,-0.2,0.9) * trotx(-pi);

                    waypoint4 = transl(0.025,0.3-(i-8)*0.05,0.2) * trotx(-pi);
                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};

                    wSteps = length(waypoint);

                end

                if 12 < i
                    waypoint3 = transl(-0.2,-0.2,0.9) * trotx(-pi);

                    waypoint4 = transl(0.05,0.3-(i-12)*0.05,0.2) * trotx(-pi);
                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};

                    wSteps = length(waypoint);

                end

                for j = 1:wSteps
                    nextJointState = self.model.ikcon(waypoint{j});
                    % nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 1]);
                    if j<=2
                        % nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 0 0 0]);
                        self.moveNed(nextJointState);
                    end
                    if 2<j
                        self.moveNedSubstrate(steps,i,nextJointState);
                    end

                end
            end
        end

        function self =  moveNed(self,nextJointState)
            currentJointState = self.model.getpos;
            steps = 20;
            % s = lspb(0,1,steps);
            % qMatrix = nan(steps,6);
            % for k = 1:steps
            %     qMatrix(k,:) = (1-s(k))*currentJointState + s(k)*nextJointState;
            % end
            % x = zeros(6,steps);
            %  for l = 1:steps-1
            %      xdot = (x(:,l+1) - x(:,l))/deltaT;
            %      J = self.robot.model.jacob0(qMatrix(l,:));
            %      J = J(1:2,:);
            %      qdot = inv(J)*xdot;
            %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
            %  end

            qMatrix = jtraj(currentJointState,nextJointState,steps);
            for i = 1:steps
                % self.netpot.netpotModel{i}.base = self.robot.model.fkine(qMatrix(i,:)) * SE3(troty(pi/2));

                self.model.animate(qMatrix(i,:));
                drawnow();
                pause(0.1);
            end
        end

        function self =  moveNedSubstrate(self,steps,i,nextJointState)
            currentJointState = self.model.getpos;
            % s = lspb(0,1,steps);
            % qMatrix = nan(steps,6);
            % for k = 1:steps
            %     qMatrix(k,:) = (1-s(k))*currentJointState + s(k)*nextJointState;
            % end
            qSteps = 20;
            qMatrix = jtraj(currentJointState, nextJointState,qSteps);
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
                self.substrate.substrateModel{i}.base = self.model.fkine(qMatrix(j,:)) * SE3(trotx(-pi/2));

                self.model.animate(qMatrix(j,:));
                self.substrate.substrateModel{i}.animate(0);

                drawnow();
                pause(0.1);
            end
        end
    end
end