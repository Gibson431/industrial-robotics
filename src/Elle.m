classdef Elle < UR3
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
            % self.robot = UR3(baseTr);
            self.model.animate([0 -pi/2 0 0 0 pi/2]);
            stepElle(self);

%             self.netpot = RobotNetpots(self.netpotCount);
%             self.model.teach();
          
        end
        
        %% Moving ELLE
        function self =  stepElle(self)
            % INITIAL GUESSES
            waypoint1Guess = [
                0.3770   -0.8796    2.2619   -1.3823    1.6336         0
                0   -1.1310    .5133   -1.3823    1.6336         0
                3.7699   -2.0106   -2.5133   -1.7593   -1.0053         0
                3.2673   -2.0106   -2.3876   -2.0106   -1.3823         0
                ];
            
            waypoint2Guess = [
                0.3770   -0.8796    2.0106   -1.1310    1.8850    0.0000
                0   -1.1310    .5133   -1.3823    1.6336         0
                3.7699   -2.0106   -2.5133   -1.7593   -1.0053         0
                3.2673   -2.0106   -2.3876   -2.0106   -1.3823         0
                ];

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
                
                waypoint3Guess =    [0.3770   -0.8796    0.6283    0.1257    1.7593         0]
                waypoint4Guess =    [0.3770   -0.8796    0.6283    0.1257    1.7593         0]

                
                if i <= 4
                    waypoint4 = transl(-0.1,0.4-i*0.1,0.2) * troty(-pi/2);
                    waypoint3 = waypoint4 * transl(0,0,0.2);

                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    
                    initialGuesses = {waypoint1Guess(1,:),waypoint2Guess(1,:),waypoint3Guess,waypoint4Guess}

                    
                    wSteps = length(waypoint);
                end
                
                if 4 < i
                    waypoint4 = transl(-0.15,0.4-(i-4)*0.05,0.2)* troty(-pi/2);
                    waypoint3 = waypoint4 * transl(0,0,0.2);

                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    
                    initialGuesses = {waypoint1Guess,waypoint2Guess,waypoint3Guess,waypoint4Guess}

                    initialGuesses = {waypoint1Guess(2,:),waypoint2Guess(2,:),waypoint3Guess,waypoint4Guess}
                    
                    wSteps = length(waypoint);
                    
                end
                
                if 8 < i
                    waypoint4 = transl(0.2,0.4-(i-8)*0.05,0.2)* troty(-pi/2);
                    waypoint3 = waypoint4 * transl(0,0,0.2);

                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    
                    initialGuesses = {waypoint1Guess(3,:),waypoint2Guess(3,:),waypoint3Guess,waypoint4Guess}
                    
                    wSteps = length(waypoint);
                    
                end
                
                if 12 < i
                    waypoint4 = transl(0.25,0.4-(i-12)*0.05,0.2)* troty(-pi/2);
                    waypoint3 = waypoint4 * transl(0,0,0.2);

                    waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    
                    initialGuesses = {waypoint1Guess(4,:),waypoint2Guess(4,:),waypoint3Guess,waypoint4Guess}
                    
                    wSteps = length(waypoint);
                    
                end
                
                for j = 1:wSteps
                    if j==1
                        nextJointState = self.model.ikcon(waypoint{j}, initialGuesses{j});
                    else
                        nextJointState = self.model.ikcon(waypoint{j});                     
                    end
                    if j<=2
                        % nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0]);
                        self.moveElle(nextJointState);
                    end
                    if 2<j
                        % nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 1]);
                        % nextJointState = self.model.ikcon(waypoint{j});
                        self.moveElleNetpot(steps,i,nextJointState);
                    end
                    % if 4<j
                    %     nextJointState = self.model.ikine(waypoint{j},'mask',[1 1 1 1 1 0]);
                    %     self.moveElle(nextJointState);
                    % end
                end
            end
        end
        
        function self =  moveElle(self,nextJointState)
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
            %      J = self.model.jacob0(qMatrix(l,:));
            %      J = J(1:2,:);
            %      qdot = inv(J)*xdot;
            %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
            %  end
            qMatrix = jtraj(currentJointState,nextJointState,steps)
            
            for i = 1:steps
                % self.netpot.netpotModel{i}.base = self.model.fkine(qMatrix(i,:)) * SE3(troty(pi/2));
                
                self.model.animate(qMatrix(i,:));
                drawnow();
                pause(0.1);
            end
        end
        
        function self =  moveElleNetpot(self,steps,i,nextJointState)
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
            %      J = self.model.jacob0(qMatrix(l,:));
            %      J = J(1:2,:);
            %      qdot = inv(J)*xdot;
            %      qMatrix(l+1,:) =  qMatrix(l,:) + deltaT*qdot';
            %  end
            % Animate gripper and brick with end-effector
            for j = 1:steps
                self.netpot.netpotModel{i}.base = self.model.fkine(qMatrix(j,:)) * SE3(troty(pi/2)) *SE3(trotx(-pi/2));
                
                self.model.animate(qMatrix(j,:));
                self.netpot.netpotModel{i}.animate(0);
                
                drawnow();
                pause(0.1);
            end
        end
    end
end