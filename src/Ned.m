classdef Ned
    properties
        robot;
    end
    methods
        function self = Ned(tr)
            baseTr = transl(0,0,0);
            if nargin ~= 0
                baseTr = tr;
            end
            self.robot = UR3(baseTr);
            self.robot.model.animate([0 -pi/2 0 0 0 0]);
        end
    end
end