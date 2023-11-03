classdef RobotPerson < handle
    properties
        model;
    end
    methods
        function self = RobotPerson(baseTr)
            origin = eye(4);
            if nargin < 1
                origin = baseTr;
            end

            [faceData,vertexData] = plyread('person.ply','tri');
            link1 = Link('alpha', 0,'a',0,'d',0,'offset',pi/2);
            self.model = SerialLink(link1,'name','Person');
            self.model.faces = {faceData,[]};
            self.model.points = {vertexData,[]};
            workspaceDimensions = [-1, 1,-1, 1, 0, 2];

            plot3d(self.model,0,'workspace',workspaceDimensions,'view',[-30,30],'delay',0,'noarrow','nowrist','notiles');
            self.model.base = baseTr;
            self.MoveBase(eye(4));
        end

        function MoveBase(self, newBase)
            self.model.base = self.model.base * SE3(newBase);
            self.model.animate(0);
        end
    end
end