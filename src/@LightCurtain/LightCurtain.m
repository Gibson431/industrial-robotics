classdef LightCurtain < handle
    properties
        leftTr
        rightTr
        height
        laserCentres = 0.1;
        plotobjs = []
    end
    methods
        function self = LightCurtain(leftTr, rightTr, height)
            self.leftTr = leftTr;
            self.rightTr = rightTr;
            self.height = height;
            laserStartPoint = [];
            laserEndPoint = [];
            for i = leftTr.t(3) : self.laserCentres : leftTr.t(3)+height
                laserStartPoint = [laserStartPoint; leftTr.t(1), leftTr.t(2), leftTr.t(3)+i];
            end

            for i = rightTr.t(3) : self.laserCentres : rightTr.t(3)+height
                laserEndPoint = [laserEndPoint; rightTr.t(1), rightTr.t(2), rightTr.t(3)+i];
            end

            numLasers = size(laserStartPoint(:,1));
            for i = 1 : numLasers
                self.plotobjs = [self.plotobjs, plot3(laserStartPoint(i, 1),laserStartPoint(i, 2),laserStartPoint(i, 3) ,'r*')];
                self.plotobjs = [self.plotobjs, plot3(laserEndPoint(i, 1),laserEndPoint(i, 2),laserEndPoint(i, 3) ,'r*')];
                self.plotobjs = [self.plotobjs, plot3([laserStartPoint(i, 1),laserEndPoint(i, 1)],[laserStartPoint(i, 2),laserEndPoint(i, 2)],[laserStartPoint(i, 3),laserEndPoint(i, 3)] ,'r')];
            end

        end

        function stop = checkCollision(self, vertex, base)
            stop = 0;
            for i = 1 : length(vertex{1}(:,1))
                if  vertex{1}(i,1)+base.t(1) > self.leftTr.t(1)
                    stop = 1;
                end
            end
        end
    end
end