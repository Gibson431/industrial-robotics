classdef Ned < omronTM5
    methods
        function self = Ned(tr)
            baseTr = eye(4);
            if nargin == 1
                baseTr = tr;
            end
            self.model.base = baseTr;
            self.model.animate([0 pi/2 0 0 0 0]);
        end
    end
end