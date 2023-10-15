% useROS = false;
% X_BASE_DISTANCE = 0.6;
% if ~useROS
%     disp('TODO: the assignment');
%     ned = Ned(transl(-X_BASE_DISTANCE/2,0,0));
%     ned.robot.model.faces
%     elle = Elle(transl(X_BASE_DISTANCE/2,0,0));
% end
%
% tr = ned.robot.model.base;
%     x_pos = tr.t(1);
%     y_pos = tr.t(2);
%     z_pos = tr.t(3);
%
%     flats = PlaceObject("2_Flats.ply",[x_pos+0.2,y_pos-0,z_pos+0]);
%     rotate(flats, [0,0,1], 90, [0,0,0]);
%     %
%     % PlaceObject("Net_Pot.ply",[x_pos+0,y_pos+0,z_pos+0]);
%     %
%     % PlaceObject("30mm_Substrate.ply",[x_pos+0,y_pos+0,z_pos+0]);
%     table = PlaceObject("table.ply",[x_pos-0.2,y_pos+0.8,z_pos-0.95]);
%     rotate(table, [0,0,1], 90, [0,0,0]);
%
%
%
%     positions = {};
%     steps = 16;
%
%     % Set position of bricks based on robot location
%     for i = 1:steps
%         if i < 5
%             positions{i} = tr * SE3(transl(-0.2+i*0.1,-0.05,0)) * SE3(trotx(pi/2));
%         end
%
%         if  5 <= i
%             % self.netpotModel{i}.base = SE3(trotx(-pi/2)) * SE3(transl(-0.2+(i-4)*0.1,-0.05,0.1)) ;
%             positions{i} = tr * SE3(transl(-0.2+(i-4)*0.1,-0.05,0.02)) * SE3(trotx(pi/2));
%         end
%
%         if 8 < i
%             % self.netpotModel{i}.base = SE3(trotx(-pi/2)) * SE3(transl(-0.2+(i-8)*0.1,-0.05,0.2)) ;
%             positions{i} = tr * SE3(transl(-0.2+(i-8)*0.1,-0.05,0.04)) * SE3(trotx(pi/2));
%         end
%
%         if 12 < i
%             % self.netpotModel{i}.base = SE3(trotx(-pi/2)) * SE3(transl(-0.5+(i-12)*0.1,-0.05,0.3)) ;
%             positions{i} = tr * SE3(transl(-0.2+(i-12)*0.1,-0.05,0.06)) * SE3(trotx(pi/2));
%         end
%
%     end
%
%     self.bricks = RobotNetpots(positions);


classdef main < handle
    properties
        ned;
        elle;
        substrate;
        netpot;
        netpotCount = 16;
        substrateCount = 16;
        origin;
    end

    methods(Static)
        function self = main(x,y,z)
            close all;
            clc;
            hold on;
            X_BASE_DISTANCE = 0.6;

            if nargin == 0
                self.ned = Ned(transl(X_BASE_DISTANCE/2,0,0));
                self.elle = Elle(transl(-X_BASE_DISTANCE/2,0,0));
            else
                self.ned = Ned(transl((X_BASE_DISTANCE/2)+x,y,z));
                self.elle = Elle(transl((-X_BASE_DISTANCE/2)+x,y,z));
            end

            self.AddObjects(self);
            self.AddNetpots(self);
            self.AddSubstrate(self);

        end
        %% Add environment
        function self = AddObjects(self)

            origin = self.ned.robot.model.base;
            x_pos = origin.t(1);
            y_pos = origin.t(2);
            z_pos = origin.t(3);

            % surf([-2.5,-2.5;+1.5,+1.5] ,[-3.5,+0.4;-3.5,+0.4] ,[z_pos-0.95,z_pos-0.95;...
            %     z_pos-0.95,z_pos-0.95],'CData',imread('concrete.jpg'),'FaceColor','texturemap');

            flats = PlaceObject("2_Flats.ply",[x_pos-0.3,y_pos,z_pos]);
            rotate(flats, [0,0,1], 90, [0,0,0]);

            table = PlaceObject("table.ply",[x_pos-0.65,y_pos+0.85,z_pos-0.95]);
            rotate(table, [0,0,1], 90, [0,0,0]);
            % 
            % PlaceObject("table.ply",[x_pos+0.4,y_pos+0.4,z_pos-0.95]);
            % 
            % 
            % PlaceObject("Security_Fence.ply",[x_pos-2,y_pos-2,z_pos-0.95]);
            % PlaceObject("Security_Fence.ply",[x_pos,y_pos-2,z_pos-0.95]);
            % 
            % PlaceObject("wall.ply",[x_pos-0.8,y_pos+0.4,z_pos]);
            % wall = PlaceObject("wall.ply",[x_pos-1.9,y_pos-1.5,z_pos]);
            % rotate(wall, [0,0,1], 90, [0,0,0]);
            % 
            % security_cam = PlaceObject("SecurityCam.ply",[x_pos+1.2,y_pos-0.4,z_pos+0.8]);
            % rotate(security_cam, [0,0,1], 180, [0,0,0]);
            % 
            % e_stop = PlaceObject("e-stop.ply",[x_pos-2,y_pos+0.3,z_pos-0.4]);
            % rotate(e_stop, [1,0,0], 90, [0,0,0]);
            % 
            % person = PlaceObject("person.ply",[x_pos-0.3,y_pos+1.6,z_pos-0.95]);
            % rotate(person, [0,0,1], 135, [0,0,0]);
            % 
            % PlaceObject("FireExtinguisher.ply",[x_pos+0.9,y_pos-1.5,z_pos-0.95]);

            self.origin = origin;
        end
        %% Add Netpots
        function self = AddNetpots(self)
            % positions = {};
            % steps = self.netpotCount;

            % Set position of bricks based on robot location
            % for i = 1:steps
            %     positions{i} = origin;
            % end

            self.netpot = RobotNetpots(self.netpotCount);
        end
        %% Add Substrate
        function self = AddSubstrate(self)
            % positions = {};
            % steps = self.netpotCount;

            % Set position of bricks based on robot location
            % for i = 1:steps
            %     positions{i} = origin;
            % end

            self.substrate = RobotSubstrate(self.substrateCount);
        end

    %% Moving Robots
            function self = Run(self)
            steps = length(self.netpotCount);

            %iterate through the netpots by going to waypoints which minimise collision
            for i = 1 : steps
                disp(['Netpot: ', num2str(i)])

                bTr = self.netpot.netpotModel{i}.base;
                self.netpot.netpotModel{1}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos,by_pos,0.4)*trotx(-pi);
                waypoint2 = transl(bx_pos,by_pos,bz_pos+0.01)*trotx(pi);
                waypoint3 = transl(-0.3,0,0.6)*trotx(pi);

                % for the first 3 bricks, set final waypoints to correct height
                if i <=4
                    waypoint4 = transl(0.4,0.3-i*0.15,0.4) * trotx(pi);
                    waypoint5 = transl(0.4,0.3-i*0.15,0.01) * trotx(pi);
                    waypoint = {waypoint3,waypoint1,waypoint2,waypoint3,waypoint4,waypoint5};
                    wSteps = length(waypoint);
                end

                % for the next 3 bricks, set final waypoints to correct height
                if 4 < i
                    waypoint4 = transl(0.4,0.3-((i-3)*0.15),0.4)* trotx(pi);
                    waypoint5 = transl(0.4,0.3-((i-3)*0.15),0.04)* trotx(pi);
                    waypoint = {waypoint3, waypoint1,waypoint2,waypoint3,waypoint4,waypoint5};
                    wSteps = length(waypoint);
                end

                % For the last 3 bricks, set final waypoints to correct height
                if 8 < i
                    waypoint4 = transl(0.4,0.3-((i-6)*0.15),0.4)* trotx(pi);
                    waypoint5 = transl(0.4,0.3-((i-6)*0.15),0.07)* trotx(pi);
                    waypoint = {waypoint3, waypoint1,waypoint2,waypoint3,waypoint4,waypoint5};
                    wSteps = length(waypoint);
                end

                if 12 < i
                    waypoint4 = transl(0.4,0.3-((i-6)*0.15),0.4)* trotx(pi);
                    waypoint5 = transl(0.4,0.3-((i-6)*0.15),0.07)* trotx(pi);
                    waypoint = {waypoint3, waypoint1,waypoint2,waypoint3,waypoint4,waypoint5};
                    wSteps = length(waypoint);
                end

                % At each waypoint, move either UR3+gripper or UR3+gripper+brick
                for j = 1:wSteps
                    currentJointState = self.robot.model.getpos;
                    nextJointState = self.robot.model.ikcon(waypoint{j});

                    if j<=3
                        self.MoveUR3(self,nextJointState);

                    else
                        self.MoveUR3Brick(self,nextJointState,i);

                    end
                end

                % command window status completion
                percent = (i/steps)*100;
                disp([num2str(percent),'% completed'])

            end
        end

        % Function to move the UR3 and gripper
        function self = MoveUR3(self,nextJointState)
            currentJointState = self.robot.model.getpos;

            steps = 20;
            qMatrix = jtraj(currentJointState,nextJointState,steps);

            % Animate gripper with end-effector
            for i = 1:steps
                self.Gripper.GripperL.base = self.elle.model.fkine(qMatrix(i,:))*SE3(trotx(pi/2));
                self.Gripper.GripperR.base = self.elle.model.fkine(qMatrix(i,:))*SE3(trotx(pi/2));

                self.robot.model.animate(qMatrix(i,:));
                self.Gripper.GripperL.animate(zeros(1,3));
                self.Gripper.GripperR.animate(zeros(1,3));
                drawnow();
                pause(0.01);
            end
        end

        % Function to move the UR3, gripper and current brick
        function self = MoveUR3Brick(self,nextJointState,i)
            currentJointState = self.robot.model.getpos;

            qSteps = 20;
            qMatrix = jtraj(currentJointState, nextJointState,qSteps);

            % Animate gripper and brick with end-effector
            for j = 1:qSteps
                self.Gripper.GripperL.base = self.robot.model.fkine(qMatrix(j,:))*SE3(troty(pi/2));
                self.Gripper.GripperR.base = self.robot.model.fkine(qMatrix(j,:))*SE3(troty(pi/2));
                self.bricks.brickModel{i}.base = self.robot.model.fkine(qMatrix(j,:))*SE3(trotx(pi/2));

                self.robot.model.animate(qMatrix(j,:));
                self.Gripper.GripperL.animate(zeros(1,3));
                self.Gripper.GripperR.animate(zeros(1,3));
                self.bricks.brickModel{i}.animate(0);

                drawnow();
                pause(0.01);
            end

        end
    
    end


end

