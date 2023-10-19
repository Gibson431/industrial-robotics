classdef Ned < omronTM5
    properties
        robot;
    end
    methods
        function self = Ned(tr)
            %             self.model.base = tr;
            %             self.model.animate([0 pi/2 0 0 0 0]);
            %             self.robot = omronTM5(baseTr);
            baseTr = transl(0,0,0);
            if nargin ~= 0
                baseTr = tr;
            end
            self.robot = omronTM5(baseTr);
            self.model.base = tr;
            self.robot.model.animate([0 pi/2 0 0 0 0]);
        end
    end
end