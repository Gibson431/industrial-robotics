classdef Ned < omronTM5
    methods
        function self = Ned(tr)
            self.model.base = tr;
            self.model.animate([0 pi/2 0 0 0 0]);
        end
    end
end