classdef gripper < handle
    %% Combine pincers to create gripper

    properties
        fingerL;
        fingerR;
        base;
        % set the open and close q values for the gripper
        gripOpen = [deg2rad(40) deg2rad(-40) deg2rad(1)];
        gripClose = [deg2rad(43.2) deg2rad(-40) deg2rad(1)];
        currentQ = [];
        openmatrix;
        closematrix;
        steps = 5;
    end

    methods
        function self = gripper(endPose)
            self.fingerL = finger(endPose * trotx(pi/2) * troty(pi));
            self.fingerR = finger(endPose * trotx(pi/2));
            self.fingerL.model.delay = 0;
            self.fingerR.model.delay = 0;
            self.fingerL.model.base = endPose * trotx(pi/2)*troty(pi);
            self.fingerR.model.base = endPose * trotx(pi/2);
            self.openmatrix = jtraj(self.gripClose,self.gripOpen,self.steps);
            self.closematrix = jtraj(self.gripOpen,self.gripClose,self.steps);
            self.currentQ = self.gripClose;
            self.Close;
        end

        function moveBase(self, base)
            self.fingerL.model.base = base.T * trotx(pi/2) * troty(pi);
            self.fingerR.model.base = base.T * trotx(pi/2);

            self.fingerL.model.animate(self.currentQ);
            self.fingerR.model.animate(self.currentQ);
        end

        function Open(self)
            qvals = jtraj(self.currentQ, self.gripOpen, self.steps);
            self.currentQ = self.gripOpen;

            for j = 1:self.steps
                    qNetpot = qvals(j,:);
                    self.fingerL.model.animate(qNetpot);
                    self.fingerR.model.animate(qNetpot);
                    drawnow();
            end

        end

        function Close(self)
            qvals = jtraj(self.currentQ, self.gripClose, self.steps);
            self.currentQ = self.gripClose;

            for j = 1:self.steps
                    qNetpot = qvals(j,:);
                    self.fingerL.model.animate(qNetpot);
                    self.fingerR.model.animate(qNetpot);
                    drawnow();
            end
        end


    end
end