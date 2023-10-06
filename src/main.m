useROS = false;
X_BASE_DISTANCE = 0.6;
if ~useROS
    disp('TODO: the assignment');
    ned = Ned(transl(-X_BASE_DISTANCE/2,0,0));
    ned.robot.model.faces
    elle = Elle(transl(X_BASE_DISTANCE/2,0,0));
end

tr = ned.robot.model.base;
    x_pos = tr.t(1);
    y_pos = tr.t(2);
    z_pos = tr.t(3);

    flats = PlaceObject("2_Flats.ply",[x_pos+0.2,y_pos-0,z_pos+0]);
    rotate(flats, [0,0,1], 90, [0,0,0]);
    %
    % PlaceObject("Net_Pot.ply",[x_pos+0,y_pos+0,z_pos+0]);
    %
    % PlaceObject("30mm_Substrate.ply",[x_pos+0,y_pos+0,z_pos+0]);
    table = PlaceObject("table.ply",[x_pos-0.2,y_pos+0.8,z_pos-0.95]);
    rotate(table, [0,0,1], 90, [0,0,0]);



    positions = {};
    steps = 16;

    % Set position of bricks based on robot location
    for i = 1:steps
        if i < 5
            positions{i} = tr * SE3(transl(-0.2+i*0.1,-0.05,0)) * SE3(trotx(pi/2));
        end

        if  5 <= i
            % self.netpotModel{i}.base = SE3(trotx(-pi/2)) * SE3(transl(-0.2+(i-4)*0.1,-0.05,0.1)) ;
            positions{i} = tr * SE3(transl(-0.2+(i-4)*0.1,-0.05,0.02)) * SE3(trotx(pi/2));
        end

        if 8 < i
            % self.netpotModel{i}.base = SE3(trotx(-pi/2)) * SE3(transl(-0.2+(i-8)*0.1,-0.05,0.2)) ;
            positions{i} = tr * SE3(transl(-0.2+(i-8)*0.1,-0.05,0.04)) * SE3(trotx(pi/2));
        end

        if 12 < i
            % self.netpotModel{i}.base = SE3(trotx(-pi/2)) * SE3(transl(-0.5+(i-12)*0.1,-0.05,0.3)) ;
            positions{i} = tr * SE3(transl(-0.2+(i-12)*0.1,-0.05,0.06)) * SE3(trotx(pi/2));
        end

    end

    self.bricks = RobotNetpots(positions);


% classdef main < handle
%     properties
%         ned;
%         elle;
%         netpotCount = 16;
%         substrateCout = 16;
%     end
% 
%     methods(Static)
%         function self = A2(x,y,z)
%             close all;
%             clc;
%             hold on;
%             X_BASE_DISTANCE = 0.6;
% 
%             if nargin == 0
%                 self.ned = Ned(transl(-X_BASE_DISTANCE/2,0,0));
%                 self.elle = Elle(transl(X_BASE_DISTANCE/2,0,0));
%             else
%                 self.ned = Ned(transl((-X_BASE_DISTANCE/2)+x,y,z));
%                 self.elle = Elle(transl((X_BASE_DISTANCE/2)+x,y,z));
%             end
%             % self.AddObjects(self);
%             % self.AddNetpots();
%             % self.AddSubstrate();
% 
%         end
%         %% Add environment
%         function self = AddObjects(self)
%             tr = self.ned.model.base;
%             x_pos = tr.t(1);
%             y_pos = tr.t(2);
%             z_pos = tr.t(3);
% 
%             flats = PlaceObject("2_Flats.ply",[x_pos+0.2,y_pos-0,z_pos+0]);
%             rotate(flats, [0,0,1], 90, [0,0,0]);
% 
%             table = PlaceObject("table.ply",[x_pos-0.2,y_pos+0.8,z_pos-0.95]);
%             rotate(table, [0,0,1], 90, [0,0,0]);
%         end
%         %% Add Netpots
%         function self = AddNetpots(self)
% 
%         end
%         %% Add Substrate
%         function self = AddSubstrate(self)
% 
%         end
%     end
% 
% end

