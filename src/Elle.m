classdef Elle < UR3
    properties
        % robot;
        netpot;
        netpotCount = 16;
        netpotIndex = 0;
        stepList;
        holdingObject = false;
        heldObject;
        routeCount = 1;
    end
    methods
        function self = Elle(tr)

            baseTr = eye(4);
            if nargin ~= 0
                baseTr = tr;
            end
            % self.robot = UR3(baseTr);
            self.model.base = baseTr * transl(1.5,0,0);
            self.model.animate([0 -pi/2 0 0 0 pi/2]);

            self.netpot = RobotNetpots(self.netpotCount);
            % self.doStep();
            % self.model.teach();

        end

        %% Move Robot
        %end pos
        % (1) (1.38,0.1,0)(1.38,0.28,0)(1.38,0.46,0)(1.38,0.64,0)
        % (2) (1.46,0.19,0)(1.46,0.37,0)(1.46,0.55,0)(1.46,0.73,0)
        % (3) (1.52,0.1,0)(1.52,0.28,0)(1.52,0.46,0)(1.52,0.64,0)
        % (4) (1.6,0.19,0)(1.6,0.37,0)(1.6,0.55,0)(1,6,0.73,0)

        % guess
        %            group1Guess = [
        %                1.8850   -0.8796    1.8850   -1.0053    1.8850         0
        %                1.8850   -0.8796    1.8850   -1.0053    1.8850         0
        %

        %   group2Guess = [1.5080   -0.8796    2.1363   -1.2566    1.5080         0



        function self = doStep(self)
            disp("step list length top: ");
            disp(length(self.stepList));
            if length(self.stepList) ~= 0
                self.model.animate(self.stepList(1,:)); %goes from waypoint 2 position to up right position
                if (self.holdingObject)
                    self.heldObject.base = self.model.fkine(self.stepList(1,:)) * SE3(trotx(-pi/2));
                    self.heldObject.animate(0);
                end

                if length(self.stepList) >= 1
                    self.routeCount = self.routeCount + 1;
                    self.holdingObject = false;
                    self.calcNextRoute();
                    self.stepsList = []; %Unrecognized property 'stepsList' for class 'Elle' after 2nd step
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
                self.heldObject.base = self.model.fkine(qVals) * SE3(trotx(-pi/2));
                self.heldObject.animate(0);
            end
        end

        function self = calcNextRoute(self)
            disp('recalc');
            % steps = length(self.substrate.substrateModel);
            initialGuess = [
                0.3770   -0.8796    2.2619   -1.3823    1.6336         0
                0.3770   -0.8796    2.2619   -1.3823    1.6336         0
                0.3770   -0.8796    2.2619   -1.3823    1.6336         0
                0.3770   -0.8796    2.2619   -1.3823    1.6336         0
                0   -1.1310    .5133   -1.3823    1.6336         0
                0   -1.1310    .5133   -1.3823    1.6336         0
                0   -1.1310    .5133   -1.3823    1.6336         0
                0   -1.1310    .5133   -1.3823    1.6336         0
                3.7699   -2.0106   -2.5133   -1.7593   -1.0053         0
                3.7699   -2.0106   -2.5133   -1.7593   -1.0053         0
                3.7699   -2.0106   -2.5133   -1.7593   -1.0053         0
                3.7699   -2.0106   -2.5133   -1.7593   -1.0053         0
                3.2673   -2.0106   -2.3876   -2.0106   -1.3823         0
                3.2673   -2.0106   -2.3876   -2.0106   -1.3823         0
                3.2673   -2.0106   -2.3876   -2.0106   -1.3823         0
                3.2673   -2.0106   -2.3876   -2.0106   -1.3823         0
                ];


            disp("route count: ");
            disp(self.routeCount);
            if mod(self.routeCount, 2) == 1
                i = self.routeCount;
                guess = floor(i/4)+1;
                guess = initialGuess(guess,:);
                bTr = self.netpot.netpotModel{i}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos,by_pos + 0.2, bz_pos + 0.01) * trotx(-pi/2) * trotz(pi) * troty(pi);
                waypoint2 = transl(bx_pos,by_pos + 0.05,bz_pos + 0.01) * trotx(-pi/2) * trotz(pi) * troty(pi);


                currentJointState = self.model.getpos;

                nextJointState = self.model.ikcon(waypoint1, initialGuess(i,:));
                self = self.moveElle(currentJointState, nextJointState);

                nextJointState = self.model.ikcon(waypoint2,initialGuess(i,:));
                self = self.moveElle(self.stepList(end,:), nextJointState);

            else
                i = floor(self.routeCount/2)+1;
                % guess = 0;
                if i <= 4
                    waypoint3 = transl(0.1,0.4-(i-1)*1.4,0.5) * trotx(-pi);
                    waypoint4 = transl(0.1,0.4-(i-1)*1.4,0.1) * trotx(-pi);
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

                % nextJointState = self.model.ikcon(waypoint3,guess);
                % self.moveNedSubstrate(i, nextJointState);
               
                currentJointState = self.model.getpos;

                nextJointState = self.model.ikcon(waypoint3);
                self = self.moveElleNetpot(i, currentJointState, nextJointState);

                nextJointState = self.model.ikcon(waypoint4);
                disp(length(self.stepList))
                self = self.moveElleNetpot(i, self.stepList(end,:), nextJointState);
                
            end

            % for j = 1:wSteps
            %     if j==1
            %         nextJointState = self.model.ikcon(waypoint{j}, initialGuesses{j});
            %     else
            %         nextJointState = self.model.ikcon(waypoint{j});
            %     end
            %     if j<=2
            %         % nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0]);
            %         self.moveElle(nextJointState);
            %     end
            %     if 2<j
            %         % nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 1]);
            %         % nextJointState = self.model.ikcon(waypoint{j});
            %         self.moveElleNetpot(steps,i,nextJointState);
            %     end
            %     % if 4<j
            %     %     nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0]);
            %     %     self.moveElle(nextJointState);
            %     % end
            % end
            disp("step list length end: ");
            disp(length(self.stepList));
        end

        function self =  moveElle(self,fromJointState, toJointState)
            currentJointState = fromJointState;
            steps = 20;
            % s = lspb(0,1,steps);
            % qMatrix = nan(steps,6);
            % for k = 1:steps
            %     qMatrix(k,:) = (1-s(k))*currentJointState + s(k)*nextJointState;
            % end
            % x = zeros(6,steps);
            %  for l = 1:steps-1
            %      xdot = (x(:,l+1) - x(:,l))/deltaT;
            %      J = self.model.jacob0(qMatrix(l,:));
            %      J = J(1:2,:);
            %      qdot = inv(J)*xdot;
            %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
            %  end
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
            for i = 1:steps
                % self.netpot.netpotModel{i}.base = self.model.fkine(qMatrix(i,:)) * SE3(troty(pi/2));

                self.model.animate(qMatrix(i,:));
                drawnow();
                pause(0.1);
            end
        end

        function self =  moveElleNetpot(self,i,fromJointState,toJointState)
            % self.moveElle(fromJointState, toJointState);
            self.holdingObject = true;
            self.heldObject = self.netpot.netpotModel{i};
            % s = lspb(0,1,steps);
            % qMatrix = nan(steps,6);
            % for k = 1:steps
            %     qMatrix(k,:) = (1-s(k))*currentJointState + s(k)*nextJointState;
            % end
            qSteps = 20;
            qMatrix = jtraj(fromJointState, toJointState,qSteps);
            % x = zeros(6,steps);
            %  for l = 1:steps-1
            %      xdot = (x(:,l+1) - x(:,l))/deltaT;
            %      J = self.model.jacob0(qMatrix(l,:));
            %      J = J(1:2,:);
            %      qdot = inv(J)*xdot;
            %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
            %  end
            % Animate gripper and brick with end-effector
            for j = 1:qSteps
                self.netpot.netpotModel{i}.base = self.model.fkine(qMatrix(j,:)) * SE3(troty(pi/2)) *SE3(trotx(-pi/2));

                self.model.animate(qMatrix(j,:));
                self.netpot.netpotModel{i}.animate(0);

                drawnow();
                pause(0.1);
            end
        end
    end
end