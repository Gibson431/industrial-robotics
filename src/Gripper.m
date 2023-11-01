classdef Gripper < handle
    %% Combine pincers to create gripper

    properties
        fingerL;
        fingerR;
        base;
        % set the open and close q values for the gripper
        gripOpenE = [deg2rad(40) deg2rad(-40) deg2rad(1)];
        gripCloseE = [deg2rad(43.2) deg2rad(-40) deg2rad(1)];

        gripOpenN = [deg2rad(29.6) deg2rad(-40) deg2rad(10)];
        gripCloseN = [deg2rad(36.8) deg2rad(-40) deg2rad(10)];

        currentQ = [];
        openmatrix;
        closematrix;
        steps = 5;
    end

    methods
        function self = Gripper(endPose,robot)
            self.fingerL = finger(endPose * trotx(pi/2) * troty(pi));
            self.fingerR = finger(endPose * trotx(pi/2));
            % self.fingerL.model.delay = 0;
            % self.fingerR.model.delay = 0;
            self.fingerL.model.base = endPose * trotx(pi/2)*troty(pi);
            self.fingerR.model.base = endPose * trotx(pi/2);
            % self.openmatrix = jtraj(self.gripClose,self.gripOpen,self.steps);
            % self.closematrix = jtraj(self.gripOpen,self.gripClose,self.steps);
            
            if robot == 1
            self.currentQ = self.gripOpenN;
            self.Open(robot);
            self.openmatrix = jtraj(self.gripCloseN,self.gripOpenN,self.steps);
            self.closematrix = jtraj(self.gripOpenN,self.gripCloseN,self.steps);
            else
                self.currentQ = self.gripCloseE;
                self.Close(robot);
                self.openmatrix = jtraj(self.gripCloseE,self.gripOpenE,self.steps);
            self.closematrix = jtraj(self.gripOpenE,self.gripCloseE,self.steps);
            end
        end

        function moveBase(self, base)
            self.fingerL.model.base = base.T * trotx(pi/2) * troty(pi);
            self.fingerR.model.base = base.T * trotx(pi/2);

            self.fingerL.model.animate(self.currentQ);
            self.fingerR.model.animate(self.currentQ);
        end

        function Open(self,robot)
            % qvals = jtraj(self.currentQ, self.gripOpen, self.steps);
            % self.currentQ = self.gripOpen;
            if robot == 1
                qvals = jtraj(self.currentQ, self.gripOpenN, self.steps);
                self.currentQ = self.gripOpenN;
            else
                qvals = jtraj(self.currentQ, self.gripOpenE, self.steps);
                self.currentQ = self.gripOpenE;
            end
            for j = 1:self.steps
                    qNetpot = qvals(j,:);
                    self.fingerL.model.animate(qNetpot);
                    self.fingerR.model.animate(qNetpot);
                    drawnow();
            end

        end

        function Close(self,robot)
            % qvals = jtraj(self.currentQ, self.gripClose, self.steps);
            % self.currentQ = self.gripClose;
            if robot == 1
                qvals = jtraj(self.currentQ, self.gripCloseN, self.steps);
                self.currentQ = self.gripCloseN;
            else
                qvals = jtraj(self.currentQ, self.gripCloseE, self.steps);
                self.currentQ = self.gripCloseE;
            end
            for j = 1:self.steps
                    qNetpot = qvals(j,:);
                    self.fingerL.model.animate(qNetpot);
                    self.fingerR.model.animate(qNetpot);
                    drawnow();
            end
        end


    end
end