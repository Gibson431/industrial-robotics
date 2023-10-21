classdef Gripper
 properties
        % robot;
        
    end
    methods
        function self = Gripper
           
            g1L1 = Link('d',0,'a',0.05,'alpha',pi,'qlim',[-pi pi]) 
            g1L2 = Link('d',0,'a',0.05,'alpha',pi/2,'qlim',[-pi pi]) 
            g1L3 = Link('d',0,'a',0.02,'alpha',pi,'qlim',[-pi pi])
            
            gripper1 = SerialLink([g1L1 g1L2 g1L3],'name','gripper')          

            % self.robot = UR3(baseTr);
            self.model.base = baseTr;
            self.model.animate([0 -pi/2 0 0 0 pi/2]);

            self.netpot = RobotNetpots(self.netpotCount);
            % self.doStep();
            % self.model.teach();
            
            q = zeros(1,gripper1.n); 

            gripper1.plot(q); 

            gQ = robot.model.fkine(robot.model.getpos)

            gripper1.base = gQ

            gripper1.plot(gripper1.getpos, 'nowrist','notiles');

        end

end

