classdef Ned < omronTM5
    properties
        % robot;
        substrate;
        substrateCount = 16;
        substrateIndex = 0;
        stepList = [];
        holdingObject = false;
        heldObject;
        routeCount = 1;
    end
    methods
        function self = Ned(tr)
            baseTr = eye(4);
            if nargin == 1
                baseTr = tr;
            end
            self.model.base = baseTr * transl(0.9,0.5,0);
            self.model.animate([0 0 0 0 0 0]);
            self.substrate = RobotSubstrate(self.substrateCount);
        end
        %% Move Robot


        function self = doStep(self)
            if ~isempty(self.stepList)
                self.jog(self.stepList(1,:));

                if length(self.stepList(:,end)) == 1
                    self.routeCount = self.routeCount + 1;
                    self.holdingObject = false;
                    self.calcNextRoute();
                    self.stepList = [];
                else
                    self.stepList = self.stepList(2:end, :);
                end

                drawnow();
                pause(0.1);

            elseif (self.holdingObject)
                self.holdingObject = false;
                self = self.calcNextRoute();
            else
                self = self.calcNextRoute();
            end
        end

        function self = jog(self, qVals)
            self.model.animate(qVals);
            if (self.holdingObject)
                self.heldObject.base = self.model.fkine(qVals) * SE3(trotx(-pi/2));
                self.heldObject.animate(0);
            end
        end

        function self = calcNextRoute(self)

            disp('recalc');
            % steps = length(self.substrate.substrateModel);

            initialGuess = [
                -2.2619    1.2566   -2.2724   -0.5027    1.6336         0
                -2.4504    0.9425   -1.8396   -0.6283    1.5708         0  %actual
                -2.5447    0.7854   -1.4608   -0.8796    1.5708         0 %actual
                -2.6389    0.7854   -1.5149   -0.8168    1.6336    2.6389
                ];

       
            %             group1Guess = [
            %                  -2.2619    1.2566   -2.2724   -0.5027    1.6336         0
            %                  -2.2619    1.2566   -2.2724   -0.5027    1.6336         0 %actual
            % %                 0           0.9739   -1.9478   -0.5655    1.5080    1.7907
            % %                 -0.1885     0.9425   -1.8937   -0.5027    1.5708    1.7907
            %                 ];
            %             group2Guess = [
            %                   -2.4504    0.9425   -1.8396   -0.6283    1.5708         0
            %                   -2.4504    0.9425   -1.8396   -0.6283    1.5708         0  %actual
            % %                 0           0.9739   -1.9478   -0.5655    1.5080    1.7907
            % %                 -0.1885     0.9425   -1.8937   -0.5027    1.5708    1.7907
            %                 ];
            %
            %             group3Guess = [
            %                 -2.5447    0.7854   -1.4608   -0.8796    1.5708         0
            %                 -2.5447    0.7854   -1.4608   -0.8796    1.5708         0 %actual
            % %                 0           0.9739   -1.9478   -0.5655    1.5080    1.7907
            % %                 -0.1885     0.9425   -1.8937   -0.5027    1.5708    1.7907
            %                 ];
            %
            %             group4Guess = [
            %                 -2.6389    0.7854   -1.5149   -0.8168    1.6336    2.6389
            %                 -2.6389    0.7854   -1.5149   -0.8168    1.6336    2.6389
            % %                 0           0.9739   -1.9478   -0.5655    1.5080    1.7907
            % %                 -0.1885     0.9425   -1.8937   -0.5027    1.5708    1.7907
            %                 ];


            if mod(self.routeCount, 2) == 1
                i = self.routeCount;
                guess = floor(i/4)+1;
                guess = initialGuess(guess,:);
                elleIndex = floor(self.routeCount/2)+1;
                bTr = self.substrate.substrateModel{elleIndex}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos,by_pos, bz_pos + 0.1) * trotx(-pi);
                waypoint2 = transl(bx_pos,by_pos,bz_pos + 0.02) * trotx(-pi);

                currentJointState = self.model.getpos();

                nextJointState = self.model.ikcon(waypoint1, guess);
                self = self.moveNed(currentJointState, nextJointState);

                nextJointState = self.model.ikcon(waypoint2, guess);
                self = self.moveNed(self.stepList(end,:), nextJointState);

            else
                i = floor(self.routeCount/2);
                guess = 0;
                if i <= 4
                    waypoint3 = transl(0.21,1.75-(i-1)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.21,1.75-(i-1)*14,0.2) * trotx(-pi);

                    guess = initialGuess(1,:);

                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);
                end

                if 4 < i
                    waypoint3 = transl(0.28,1.82+(i-5)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.28,1.82+(i-5)*14,0.2) * trotx(-pi);

                    guess = initialGuess(1,:);

                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);

                end

                if 8 < i
                    waypoint3 = transl(0.35,1.75+(i-9)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.35,1.75+(i-9)*14,0.2) * trotx(-pi);

                    guess = initialGuess(3,:);
                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);

                end

                if 12 < i
                    waypoint3 = transl(0.42,1.82+(i-13)*14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.42,1.82+(i-13)*14,0.2) * trotx(-pi);

                    guess = initialGuess(4,:);

                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);

                end
                currentJointState = self.model.getpos();

                nextJointState = self.model.ikcon(waypoint3, guess);
                self = self.moveNedSubstrate(i, currentJointState, nextJointState);

                nextJointState = self.model.ikcon(waypoint4, guess);
                self = self.moveNedSubstrate(i, self.stepList(end,:), nextJointState);
            end
        end

        function self = moveNed(self,fromJointState, toJointState)
            currentJointState = fromJointState;
            steps = 20;
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
        end

        function self = moveNedSubstrate(self,i,fromJointState, toJointState)
            self = self.moveNed(fromJointState, toJointState);
            self.holdingObject = true;
            self.heldObject = self.substrate.substrateModel{i};
        end
    end
end