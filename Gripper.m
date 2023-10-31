classdef Gripper < handle
    properties (Access = public)
        gripperLeft;
        gripperRight;
        base;
    end

    methods
        function self = Gripper()
            % self.base = tr;
            self.CreateModel();
        end
        function self = CreateModel(self)
            % L(1) = Link('d',0,'a',0.05,'alpha',pi,'qlim',[-pi pi]);
            % L(2) = Link('d',0,'a',0.05,'alpha',pi/2,'qlim',[-pi pi]);
            % L(3) = Link('d',0,'a',0.02,'alpha',pi,'qlim',[-pi pi]);

            L(1) = Link('d',0,'a',0.1,'alpha',0,'qlim',[-pi pi],'offset',0);
            L(2) = Link('d',0,'a',0.05,'alpha',0,'qlim',[-pi pi],'offset',pi/4);
            L(3) = Link('d',0,'a',0.05,'alpha',0,'qlim',[-pi pi],'offset',pi/8);


            self.gripperLeft = SerialLink(L,'name','gripperLeft');
            self.gripperLeft.base = self.base

            R(1) = Link('d',0,'a',-0.1,'alpha',-pi,'qlim',[-pi pi],'offset',0);
            R(2) = Link('d',0,'a',-0.05,'alpha',0,'qlim',[-pi pi],'offset',pi/4);
            R(3) = Link('d',0,'a',-0.05,'alpha',0,'qlim',[-pi pi],'offset',pi/8);

            self.gripperRight = SerialLink(R,'name','gripperLeft');
            self.gripperRight.base = self.base 


            % % self.robot = UR3(baseTr);
            % self.model.base = baseTr;
            % self.model.animate([0 -pi/2 0 0 0 pi/2]);
            %
            % self.netpot = RobotNetpots(self.netpotCount);
            % % self.doStep();
            % self.gripperLeft.teach();
            %
            % q = zeros(1,self.gripperLeft.n);
            %
            % self.gripperLeft.plot(q);
            %
            % gQ = robot.model.fkine(robot.model.getpos)
            %
            % self.gripperLeft.base = gQ
            %
            
            hold on;
            self.gripperLeft.plot([0,0,0], 'nowrist','notiles');
            self.gripperRight.plot([0,0,0], 'nowrist','notiles');

        end
        % function self = Plot(self,tr)
        %     self.base = tr;
        %     self.gripperLeft.base = tr * transl(0.01,0,0);
        %     self.gripperRight.base = tr * transl(0.01,0,0);
        % end
    end
end

