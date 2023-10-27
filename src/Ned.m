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

            group1Guess = [
                0.2827    0.3142    2.0019   -2.3248   -1.5708    2.4504
                0.1885    0.4712    2.1642   -2.7018   -1.5080    2.4504
                2.6389    0.2199    1.3526   -1.5708   -1.5708    2.4504
                2.8274    0.6283    1.7314   -2.3876   -1.5080    2.4504
                ];

            group2Guess = [
                0.3770    0.2513    1.9478   -2.1991   -1.5708    2.4504
                0.2827    0.4712    2.1642   -2.7018   -1.5080    2.4504
                2.6389    0.2199    1.3526   -1.5708   -1.5708    2.4504
                2.8274    0.6283    1.7314   -2.3876   -1.5080    2.4504
                ];

            group3Guess = [
                0.4712    0.1885    1.5149   -1.6965   -1.5708    2.4504
                0.3770    0.5027    2.0019   -2.5133   -1.5080    2.4504
                2.6389    0.2199    1.3526   -1.5708   -1.5708    2.4504
                2.5447    0.6283    1.7314   -2.3876   -1.5080    2.4504
                ];

            group4Guess = [
                0.5655    0.3142    1.2444   -1.5708   -1.5708    2.4504
                0.4712    0.5655    1.8937   -2.5133   -1.5080    2.4504
                2.6389    0.2199    1.3526   -1.5708   -1.5708    2.4504
                2.5447    0.6283    1.7314   -2.3876   -1.5080    2.4504
                ];
            guesses = {group1Guess, group2Guess, group3Guess, group4Guess};

            if mod(self.routeCount, 2) == 1
                % i = self.routeCount;
                % guess = floor(i/4)+1;
                % guess = initialGuess(guess,:);
                elleIndex = floor(self.routeCount/2)+1;
                bTr = self.substrate.substrateModel{elleIndex}.base;

                bx_pos = bTr.t(1);
                by_pos = bTr.t(2);
                bz_pos = bTr.t(3);

                waypoint1 = transl(bx_pos,by_pos, bz_pos + 0.1) * trotx(-pi);
                waypoint2 = transl(bx_pos,by_pos,bz_pos + 0.02) * trotx(-pi);

                currentJointState = self.model.getpos();

                groupIndex = floor(elleIndex/4)+1;
                nextJointState = self.model.ikcon(waypoint1, guesses{groupIndex}(1,:));
                self = self.moveNed(currentJointState, nextJointState, 20);

                nextJointState = self.model.ikcon(waypoint2, guesses{groupIndex}(2,:));
                self = self.moveNed(self.stepList(end,:), nextJointState, 5);

            else
                i = floor(self.routeCount/2);
                guess = 0;
                if i <= 4
                    waypoint3 = transl(0.21,1.75-(i-1)*0.14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.21,1.75-(i-1)*0.14,0.2) * trotx(-pi);

                    % guess = initialGuess(1,:); % no longer using initial guess array

                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);
                end

                if 4 < i
                    waypoint3 = transl(0.28,1.82+(i-5)*0.14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.28,1.82+(i-5)*0.14,0.2) * trotx(-pi);

                    % guess = initialGuess(1,:);

                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);

                end

                if 8 < i
                    waypoint3 = transl(0.35,1.75+(i-9)*0.14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.35,1.75+(i-9)*0.14,0.2) * trotx(-pi);

                    % guess = initialGuess(3,:);
                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);

                end

                if 12 < i
                    waypoint3 = transl(0.42,1.82+(i-13)*0.14,0.5) * trotx(-pi);
                    waypoint4 = transl(0.42,1.82+(i-13)*0.14,0.2) * trotx(-pi);

                    % guess = initialGuess(4,:);

                    % waypoint = {waypoint1,waypoint2,waypoint3,waypoint4};
                    % wSteps = length(waypoint);

                end
                currentJointState = self.model.getpos();
                
                elleIndex = floor(self.routeCount/2)+1;
                groupIndex = floor(elleIndex/4)+1;
                nextJointState = self.model.ikcon(waypoint3, guesses{groupIndex}(3,:));
                self = self.moveNedSubstrate(i, currentJointState, nextJointState, 20);

                nextJointState = self.model.ikcon(waypoint4, guesses{groupIndex}(4,:));
                self = self.moveNedSubstrate(i, self.stepList(end,:), nextJointState, 5);
            end
        end

        function self = moveNed(self,fromJointState, toJointState, steps)
            currentJointState = fromJointState;
            % steps = 20;
            qMatrix = jtraj(currentJointState,toJointState,steps);
            self.stepList = [self.stepList; qMatrix];
        end

        function self = moveNedSubstrate(self,i,fromJointState, toJointState, steps)
            self = self.moveNed(fromJointState, toJointState, steps);
            self.holdingObject = true;
            self.heldObject = self.substrate.substrateModel{i};
        end
    end
end